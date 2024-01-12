import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_fileease/core/bloc/send_file/enums/download_status_enum.dart';
import 'package:flutter_fileease/core/bloc/send_file/file_model.dart';
import 'package:flutter_fileease/core/bloc/send_file/send_file_bloc.dart';
import 'package:flutter_fileease/core/firebase_core.dart';
import 'package:flutter_fileease/core/user/user_bloc.dart';
import 'package:flutter_fileease/services/convert_value_service.dart';
import 'package:flutter_fileease/services/navigation_service.dart';
import 'package:flutter_fileease/services/web_service.dart';

class CoreFirebaseStorage {
  final storageRef = FirebaseStorage.instance;
  List<FirebaseFileModel> filesListRoot = [];
  final firebaseSendBloc = BlocProvider.of<FirebaseSendFileBloc>(
    NavigationService.navigatorKey.currentContext!,
  );
  Future<void> sendFirebaseFilesListRoot() async {
    await firebaseSendBloc.setFilesListAndPushFirebase(filesListRoot);
  }

  String get getConnectionCollectionFirebaseDocumentName =>
      firebaseSendBloc.getConnectionCollectionFirebaseDocumentName();

  //Updated for web read errors
  void uploadFilesFromPlatformFilesList(List<PlatformFile> platformFileList) {
    var fileList = <File>[];
    var fileSizeList = <int>[];
    var fileByteList = <Uint8List>[];
    var fileNameList = <String>[];
    if (WebService.isWeb) {
      fileList = platformFileList
          .map((file) => File.fromRawPath(file.bytes!))
          .toList();
    } else {
      fileList = platformFileList.map((file) => File(file.path!)).toList();
    }
    fileSizeList = platformFileList.map((file) => file.size).toList();
    if (WebService.isWeb) {
      fileByteList = platformFileList.map((file) => file.bytes!).toList();
    } else {
      for (final file in fileList) {
        fileByteList.add(file.readAsBytesSync());
      }
    }
    fileNameList = platformFileList.map((file) => file.name).toList();
    fileList.map((file) async {
      unawaited(
        convertAndSendFileModel(
          file,
          fileNameList[fileList.indexOf(file)],
          fileSizeList[fileList.indexOf(file)],
          fileByteList[fileList.indexOf(file)],
          'files/',
        ),
      );
    }).toList();
  }

  Future<void> convertAndSendFileModel(
    File file,
    String fileName,
    int fileSize,
    Uint8List fileBytes,
    String destination,
  ) async {
    final fileSizeVoid = ConvertValueService().getFileSize(fileSize, 1);
    final timestamp = await FirebaseCore().getServerTimestamp();
    unawaited(
      BlocProvider.of<UserBloc>(
        NavigationService.navigatorKey.currentContext!,
      ).decreaseUserCloudStorageAndSendFirebase(fileSize / 1024),
    );
    final fileModel = FirebaseFileModel(
      name: fileName,
      bytesTransferred: '0',
      totalBytes: fileBytes.toString(),
      size: fileSizeVoid,
      percentage: '0',
      url: '',
      downloadPath: '',
      downloadStatus: FirebaseFileModelDownloadStatus.notDownloaded,
      path: (WebService.isWeb)
          ? '$fileName-${timestamp.toDate()}'
          : file.path, //file path null in flutter web
      timestamp: timestamp,
    );
    filesListRoot.add(fileModel);
    uploadFile(
      file,
      'files/$getConnectionCollectionFirebaseDocumentName/sender/',
      fileName,
      fileBytes: fileBytes,
      urlCallback: (url) {
        fileModel.url = url;
        changeFileInFilesListRoot(fileModel);
        unawaited(sendFirebaseFilesListRoot());
      },
      listenUploadTaskCallback: (bytesTransferred, totalBytes) {
        fileModel
          ..bytesTransferred = bytesTransferred
          ..totalBytes = totalBytes
          ..percentage =
              ((int.parse(bytesTransferred) / int.parse(totalBytes)) * 100)
                  .toStringAsFixed(0);
        changeFileInFilesListRoot(fileModel);
        firebaseSendBloc.calculateTotalAndNowSpacesInFileList();
        sendFirebaseFilesListRoot();
      },
      uploadSuccessCallback: () {},
    );
  }

  Future<String> changeFileNameWithAddTimestamp(String fileName) async {
    final fileNameFirst = fileName.split('.').first;
    final fileNameLast = fileName.split('.').last;
    final timestamp =
        (await FirebaseCore().getServerTimestamp()).seconds.toString();
    return '$fileNameFirst-$timestamp.$fileNameLast';
  }

  void changeFileInFilesListRoot(FirebaseFileModel file) {
    final index = filesListRoot.indexWhere(
      (item) =>
          item.path == file.path &&
          item.name == file.name &&
          item.timestamp == file.timestamp,
    );
    filesListRoot[index] = file;
  }

  void uploadFile(
    File file,
    String destination,
    String? fileName, {
    Uint8List? fileBytes,
    void Function(String bytesTransferred, String totalBytes)?
        listenUploadTaskCallback,
    void Function(String url)? urlCallback,
    void Function()? uploadSuccessCallback,
  }) {
    final fileNameChild =
        (fileName == null) ? file.path.split('/').last : fileName;
    final ref = storageRef.ref(destination).child(fileNameChild);
    final uploadTask =
        (WebService.isWeb) ? ref.putData(fileBytes!) : ref.putFile(file);
    listenUploadTask(uploadTask, (bytesTransferred, totalBytes) {
      listenUploadTaskCallback?.call(bytesTransferred, totalBytes);
      uploadSuccessCallback?.call();
    });
    getUrlWhenCompleteTask(uploadTask, urlCallback);
  }

  void listenUploadTask(
    UploadTask uploadTask,
    void Function(String bytesTransferred, String totalBytes)?
        listenUploadTaskCallback,
  ) {
    uploadTask.snapshotEvents.listen((event) {
      if (event.bytesTransferred != 0 || event.totalBytes != 0) {
        listenUploadTaskCallback?.call(
          event.bytesTransferred.toString(),
          event.totalBytes.toString(),
        );
      }
    });
  }

  void getUrlWhenCompleteTask(
    UploadTask uploadTask,
    void Function(String url)? urlCallback,
  ) {
    uploadTask.whenComplete(() async {
      urlCallback?.call(await uploadTask.snapshot.ref.getDownloadURL());
    });
  }
}
