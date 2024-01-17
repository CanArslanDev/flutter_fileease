import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_fileease/core/bloc/firebase_core/firebase_core_bloc.dart';
import 'package:flutter_fileease/core/bloc/firebase_core/profile_photo_file_model.dart';
import 'package:flutter_fileease/core/bloc/send_file/download_file/download_file_model.dart';
import 'package:flutter_fileease/core/bloc/send_file/enums/send_file_request_enum.dart';
import 'package:flutter_fileease/core/bloc/send_file/enums/send_file_uploading_enum.dart';
import 'package:flutter_fileease/core/bloc/send_file/file_model.dart';
import 'package:flutter_fileease/core/bloc/send_file/send_file_model.dart';
import 'package:flutter_fileease/core/bloc/status_enum.dart';
import 'package:flutter_fileease/core/firebase_core.dart';
import 'package:flutter_fileease/core/user/user_bloc.dart';
import 'package:flutter_fileease/services/navigation_service.dart';

class FirebaseSendFileUtils {
  void changeFilesListFilesDownloadEnumAndUpdateFirebaseFilesList(
    List<FirebaseFileModel> filesList,
    List<FirebaseDownloadFileModel> downloadFilesList,
    void Function() ifChangedValue,
    void Function(List<FirebaseFileModel> filesList) updateFirebaseFilesList,
  ) {
    var changedValue = false;
    for (final file in downloadFilesList) {
      final index = filesList.indexWhere(
        (item) => item.path == file.path &&
                item.name == file.name &&
                (file.downloadPath == 'web')
            ? file.fileCreatedTimestamp.seconds == item.timestamp.seconds
            : file.fileCreatedTimestamp == item.timestamp,
      );
      if (index != -1 &&
          filesList[index].downloadStatus != file.downloadStatus) {
        final changedFile = filesList[index]
          ..downloadStatus = file.downloadStatus
          ..downloadPath = file.downloadPath;
        filesList[index] = changedFile;
        changedValue = true;
      }
    }
    if (changedValue) {
      ifChangedValue.call();
    }
    updateFirebaseFilesList.call(filesList);
  }

  Future<bool> checkUserID(
    String userID,
    void Function(FirebaseSendFileRequestEnum status, String errorMessage)
        firebaseSendFileRequestError,
  ) async {
    if (userID.isEmpty) {
      firebaseSendFileRequestError.call(
        FirebaseSendFileRequestEnum.error,
        'User ID is empty',
      );
      return false;
    } else if (double.tryParse(userID) == null) {
      firebaseSendFileRequestError.call(
        FirebaseSendFileRequestEnum.error,
        'User ID is not a valid ID',
      );
      return false;
    } else if (BlocProvider.of<FirebaseCoreBloc>(
          NavigationService.navigatorKey.currentContext!,
        ).getStatus() ==
        FirebaseCoreStatus.loading) {
      firebaseSendFileRequestError.call(
        FirebaseSendFileRequestEnum.error,
        'Loading services, please wait and try again',
      );
      return false;
    } else if (BlocProvider.of<UserBloc>(
          NavigationService.navigatorKey.currentContext!,
        ).getDeviceID() ==
        userID) {
      firebaseSendFileRequestError.call(
        FirebaseSendFileRequestEnum.error,
        'You cannot send files to yourself',
      );
      return false;
    } else if (await FirebaseCore().checkUserIDForIdsCollection(userID) ==
        false) {
      firebaseSendFileRequestError.call(
        FirebaseSendFileRequestEnum.error,
        'User ID not found',
      );
      return false;
    }
    return true;
  }

  void calculateTotalAndNowSpacesInFileList(
    double fileTotalSpaceAsKB,
    double fileNowSpaceAsKB,
    List<FirebaseFileModel> filesList,
    void Function(double fileTotalSpaceAsKB, double fileNowSpaceAsKB)
        finalSpace,
  ) {
    var totalSpace = fileTotalSpaceAsKB;
    var nowSpace = fileNowSpaceAsKB;
    for (final file in filesList) {
      totalSpace += double.parse(file.totalBytes);
      nowSpace += double.parse(file.bytesTransferred);
    }
    finalSpace.call(
      double.parse((totalSpace / 1024).toStringAsFixed(0)),
      double.parse((nowSpace / 1024).toStringAsFixed(0)),
    );
  }

  List<FirebaseFileModel> changeFilesDownloadStatusThePrevious(
    List<FirebaseFileModel> newFilesList,
    List<FirebaseFileModel> oldFilesList,
  ) {
    final returnFilesList = newFilesList;
    for (final file in returnFilesList) {
      final newFile = file;

      final index = oldFilesList.indexWhere(
        (item) =>
            item.path == file.path &&
            item.name == file.name &&
            item.timestamp == file.timestamp,
      );
      if (index != -1) {
        newFile.downloadStatus = oldFilesList[index].downloadStatus;
        returnFilesList[index] = newFile;
      }
    }
    return returnFilesList;
  }

  FirebaseSendFileModel getDefaultModel() {
    return FirebaseSendFileModel(
      receiverID: '',
      receiverUsername: '',
      receiverDeviceToken: '',
      senderID: '',
      senderUsename: '',
      senderDeviceToken: '',
      firebaseDocumentName: '',
      filesCount: 0,
      sendSpeed: '0MB/s',
      filesList: [],
      downloadFilesList: [],
      status: FirebaseSendFileRequestEnum.stable,
      errorMessage: '',
      uploadingStatus: FirebaseSendFileUploadingEnum.stable,
      fileTotalSpaceAsKB: 0,
      fileNowSpaceAsKB: 0,
      timestamp: Timestamp.fromDate(DateTime.now()), //for a tenporary
      receiverProfilePhoto: ProfilePhotoModel(name: '', downloadUrl: ''),
    );
  }
}
