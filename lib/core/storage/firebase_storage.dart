import 'dart:async';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_fileease/core/bloc/send_file/enums/download_status_enum.dart';
import 'package:flutter_fileease/core/bloc/send_file/file_model.dart';
import 'package:flutter_fileease/core/bloc/send_file/send_file_bloc.dart';
import 'package:flutter_fileease/core/firebase_core.dart';
import 'package:flutter_fileease/core/user/user_bloc.dart';
import 'package:flutter_fileease/services/convert_value_service.dart';
import 'package:flutter_fileease/services/navigation_service.dart';

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

  void uploadFilesFromList(List<File> fileList) {
    filesListRoot = BlocProvider.of<FirebaseSendFileBloc>(
      NavigationService.navigatorKey.currentContext!,
    ).getFilesList() as List<FirebaseFileModel>;
    fileList.map((file) async {
      unawaited(
        convertAndSendFileModel(
          file,
          'files/',
        ),
      );
    }).toList();
  }

  Future<void> convertAndSendFileModel(
    File file,
    String destination,
  ) async {
    final fileName = file.path.split('/').last;
    // final fileName =
    //     await changeFileNameWithAddTimestamp(file.path.split('/').last);
    final fileSize = ConvertValueService().getFileSize(file.path, 1);
    unawaited(
      BlocProvider.of<UserBloc>(
        NavigationService.navigatorKey.currentContext!,
      ).decreaseUserCloudStorageAndSendFirebase(file.lengthSync() / 1024),
    );
    final fileModel = FirebaseFileModel(
      name: fileName,
      bytesTransferred: '0',
      totalBytes: file.lengthSync().toString(),
      size: fileSize,
      percentage: '0',
      url: '',
      downloadPath: '',
      downloadStatus: FirebaseFileModelDownloadStatus.notDownloaded,
      path: file.path,
      timestamp: await FirebaseCore().getServerTimestamp(),
    );
    filesListRoot.add(fileModel);
    uploadFile(
      file,
      'files/$getConnectionCollectionFirebaseDocumentName/sender/',
      fileName,
      urlCallback: (url) {
        fileModel.url = url;
        changeFileInFilesListRoot(fileModel);
        sendFirebaseFilesListRoot();
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
    void Function(String bytesTransferred, String totalBytes)?
        listenUploadTaskCallback,
    void Function(String url)? urlCallback,
    void Function()? uploadSuccessCallback,
  }) {
    final fileNameChild =
        (fileName == null) ? file.path.split('/').last : fileName;
    try {
      final ref = storageRef.ref(destination).child(fileNameChild);
      final uploadTask = ref.putFile(file);
      listenUploadTask(uploadTask, (bytesTransferred, totalBytes) {
        listenUploadTaskCallback?.call(bytesTransferred, totalBytes);
        uploadSuccessCallback?.call();
      });
      getUrlWhenCompleteTask(uploadTask, urlCallback);
    } catch (e) {
      debugPrint('error occured $e');
    }
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
