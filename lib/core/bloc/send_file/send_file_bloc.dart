import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_fileease/core/base_core/core_system.dart';
import 'package:flutter_fileease/core/bloc/firebase_core/profile_photo_file_model.dart';
import 'package:flutter_fileease/core/bloc/send_file/download_file/download_file_model.dart';
import 'package:flutter_fileease/core/bloc/send_file/download_file/download_file_utils.dart';
import 'package:flutter_fileease/core/bloc/send_file/enums/download_status_enum.dart';
import 'package:flutter_fileease/core/bloc/send_file/enums/send_file_request_enum.dart';
import 'package:flutter_fileease/core/bloc/send_file/enums/send_file_uploading_enum.dart';
import 'package:flutter_fileease/core/bloc/send_file/file_model.dart';
import 'package:flutter_fileease/core/bloc/send_file/leave_connection.dart';
import 'package:flutter_fileease/core/bloc/send_file/send_file_firebase.dart';
import 'package:flutter_fileease/core/bloc/send_file/send_file_internet_bandwidth_speed/send_file_internet_bandwidth_speed.dart';
import 'package:flutter_fileease/core/bloc/send_file/send_file_model.dart';
import 'package:flutter_fileease/core/bloc/send_file/send_file_utils.dart';
import 'package:flutter_fileease/core/firebase_core.dart';
import 'package:flutter_fileease/core/user/models/latest_connections_model.dart';
import 'package:flutter_fileease/core/user/requests/connection_request_model.dart';
import 'package:flutter_fileease/core/user/user_bloc.dart';
import 'package:flutter_fileease/services/http_service.dart';
import 'package:flutter_fileease/services/navigation_service.dart';

class FirebaseSendFileBloc extends Cubit<FirebaseSendFileModel> {
  FirebaseSendFileBloc()
      : super(
          FirebaseSendFileModel(
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
          ),
        );

  final sendFileUtils = FirebaseSendFileUtils();
  final internetBandwidthSpeed = SendFileInternetBandwidthSpeed();
  final sendFileFirebase = FirebaseSendFileFirebase();
  final sendFileLeaveConnection = FirebaseSendFileLeaveConnection();
  bool openedLeaveAlertDialog = false;
  void setConnection(
    String receiverID,
    String receiverUsername,
    String receiverDeviceToken,
    String senderID,
    String senderUsename,
    String senderDeviceToken,
  ) {
    emit(
      state.copyWith(
        receiverID: receiverID,
        receiverUsername: receiverUsername,
        receiverDeviceToken: receiverDeviceToken,
        senderID: senderID,
        senderUsename: senderUsename,
        senderDeviceToken: senderDeviceToken,
        firebaseDocumentName: '$senderID-$receiverID',
      ),
    );
    unawaited(_setProfilePhotoFromReceiverID());
  }

  Future<void> _setProfilePhotoFromReceiverID() async {
    if (!ifSenderIDEqualUserID) {
      final userBloc = BlocProvider.of<UserBloc>(
        NavigationService.navigatorKey.currentContext!,
      );
      final profilePhoto = userBloc.getProfilePhoto();
      emit(state.copyWith(receiverProfilePhoto: profilePhoto));
      return;
    }
    await FirebaseCoreSystem()
        .getUserFromUsersCollection(state.receiverDeviceToken)
        .then((value) {
      if (value != null) {
        final profilePhoto = ProfilePhotoModel.fromMap(
          value['profilePhoto'] as Map<String, dynamic>,
        );
        emit(state.copyWith(receiverProfilePhoto: profilePhoto));
      }
    });
  }

  bool ifConnectionExist() {
    return state.senderID != '' && state.receiverID != '';
  }

  void downloadFilesInFilesList() {
    FirebaseDownloadFileUtils().downloadFilesInFilesList(
        state.filesList, state.downloadFilesList, (downloadModel, fileModel) {
      state.downloadFilesList.add(downloadModel);
      downloadFile(fileModel.name, fileModel.path, fileModel.url,
          (downloadStatus, downloadPath) {
        if (downloadStatus != fileModel.downloadStatus) {
          downloadModel
            ..downloadStatus = downloadStatus
            ..downloadPath = downloadPath;
          changeDownloadFileInDownloadFilesList(downloadModel);
          unawaited(sendFileFirebase.updateFirebaseDownloadFilesList(state));
        }
      });
    });
  }

  void changeDownloadFileInDownloadFilesList(FirebaseDownloadFileModel file) {
    final index = state.downloadFilesList.indexWhere(
      (item) =>
          item.path == file.path &&
          item.name == file.name &&
          item.fileCreatedTimestamp == file.fileCreatedTimestamp,
    );
    state.downloadFilesList[index] = file;
  }

  Future<void> downloadFile(
    String fileName,
    String filePath,
    String fileUrl,
    void Function(
      FirebaseFileModelDownloadStatus downloadStatus,
      String downloadPath,
    ) downloadStatus,
  ) async {
    var downloadPathLocation = '';
    downloadStatus.call(
      FirebaseFileModelDownloadStatus.downloading,
      downloadPathLocation,
    );
    await HttpService().downloadFile(
      fileUrl,
      fileName,
      downloadPath: (downloadPath) => downloadPathLocation = downloadPath,
    );
    downloadStatus.call(
      FirebaseFileModelDownloadStatus.downloaded,
      downloadPathLocation,
    );
  }

  Future<void> leaveConnection() async {
    await sendFileLeaveConnection.leaveCurrentConnection();
  }

  Future<void> listenConnection() async {
    await sendFileFirebase.listenConnection(
      state.firebaseDocumentName,
      (querySnapshot) async {
        await controlLeaveConnection(querySnapshot);
        getFirebaseConnectionsCollection(querySnapshot);

        unawaited(sendLatestConnectionsToUserBloc());
        if (ifSenderIDEqualUserID) {
          changeFilesListFilesDownloadEnumAndUpdateFirebaseFilesList();
        } else {
          downloadFilesInFilesList();
        }
      },
    );
  }

  Future<void> controlLeaveConnection(
    DocumentSnapshot<Object?> querySnapshot,
  ) async {
    final mapState = querySnapshot.data()! as Map<dynamic, dynamic>;
    if (mapState['senderID'] == '' &&
        mapState['receiverID'] == '' &&
        state.senderID != '' &&
        state.receiverID != '' &&
        (sendFileLeaveConnection.exitedConnection ==
            mapState['exitedConnection'] as bool)) {
      await leaveConnection();
    } else {
      if (sendFileLeaveConnection.exitedConnection != true) {
        sendFileLeaveConnection.exitedConnection = true;
      }
    }
  }

  bool get ifSenderIDEqualUserID =>
      state.senderID ==
      BlocProvider.of<UserBloc>(
        NavigationService.navigatorKey.currentContext!,
      ).getDeviceID();

  Future<void> setFirebaseConnectionsCollection() async =>
      sendFileFirebase.setFirebaseConnectionsCollection(state);

  Future<void> updateFirebaseConnectionsCollection() async {
    state.sendSpeed =
        internetBandwidthSpeed.getInternetSendSpeed(state.fileNowSpaceAsKB);
    await sendFileFirebase.updateFirebaseConnectionsCollection(state);
  }

  Future<void> sendLatestConnectionsToUserBloc() async {
    if (state.status == FirebaseSendFileRequestEnum.exited ||
        state.senderID == '' ||
        state.receiverID == '' ||
        state.senderDeviceToken == '' ||
        state.receiverDeviceToken == '') {
      return;
    }
    BlocProvider.of<UserBloc>(
      NavigationService.navigatorKey.currentContext!,
    ).listUnionLatestConnectionsInState(
      UserLatestConnectionsModel(
        receiverID: state.receiverID,
        receiverDeviceToken: state.receiverDeviceToken,
        senderID: state.senderID,
        senderDeviceToken: state.senderDeviceToken,
        filesCount: state.filesList.length,
        filesList: state.filesList,
        fileTotalSpaceAsKB: state.fileTotalSpaceAsKB,
        timestamp: state.timestamp,
      ),
    );
    await BlocProvider.of<UserBloc>(
      NavigationService.navigatorKey.currentContext!,
    ).sendFirebaseLatestConnectionsList();
  }

  void getFirebaseConnectionsCollection(
    DocumentSnapshot<Object?> querySnapshot,
  ) {
    final mapState = querySnapshot.data()! as Map<dynamic, dynamic>;
    mapState['firebaseDocumentName'] = state.firebaseDocumentName;
    final newState = FirebaseSendFileModel.fromMap(mapState);
    if (ifSenderIDEqualUserID) {
      newState.filesList = sendFileUtils.changeFilesDownloadStatusThePrevious(
        newState.filesList,
        state.filesList,
      );
    }
    emit(
      state.copyWith(
        receiverID: newState.receiverID,
        receiverUsername: newState.receiverUsername,
        senderID: newState.senderID,
        senderUsename: newState.senderUsename,
        firebaseDocumentName: newState.firebaseDocumentName,
        filesCount: newState.filesCount,
        sendSpeed: newState.sendSpeed,
        filesList: newState.filesList,
        downloadFilesList: newState.downloadFilesList,
        status: FirebaseSendFileRequestEnum.values[newState.status.index],
        errorMessage: newState.errorMessage,
        uploadingStatus: FirebaseSendFileUploadingEnum
            .values[newState.uploadingStatus.index],
        fileTotalSpaceAsKB: newState.fileTotalSpaceAsKB,
        fileNowSpaceAsKB: newState.fileNowSpaceAsKB,
        timestamp: newState.timestamp,
      ),
    );
  }

  void changeFilesListFilesDownloadEnumAndUpdateFirebaseFilesList() {
    sendFileUtils.changeFilesListFilesDownloadEnumAndUpdateFirebaseFilesList(
        state.filesList,
        state.downloadFilesList,
        () => sendFileFirebase.updateFirebaseFilesList(state), (filesList) {
      emit(state.copyWith(filesList: filesList));
    });
  }

  Future<bool> sendConnectRequest(
    String userID,
  ) async {
    final functionUserID = userID.replaceAll(' ', '');
    final checkUserIDBool = await sendFileUtils.checkUserID(functionUserID,
        (requestEnum, errorMessage) {
      emit(
        state.copyWith(
          status: requestEnum,
          errorMessage: errorMessage,
        ),
      );
    });
    if (checkUserIDBool == false) {
      return false;
    }
    setErrorMessage('');
    setStatus(FirebaseSendFileRequestEnum.connecting);
    await setUserSendFileRequest(functionUserID);
    setStatus(FirebaseSendFileRequestEnum.sendedRequest);
    return true;
  }

  Future<void> setUserSendFileRequest(String userID) async {
    final userToken =
        await FirebaseCoreSystem().getUserTokenFromUsersCollection(userID);
    final user = await sendFileFirebase.getUserFromUserCollection(userToken);
    final userConnectionList = (user['connectionRequests'] as List<dynamic>)
      ..add(
        UserConnectionRequestModel(
          username: BlocProvider.of<UserBloc>(
            NavigationService.navigatorKey.currentContext!,
          ).getUsername(),
          profilePhoto: BlocProvider.of<UserBloc>(
            NavigationService.navigatorKey.currentContext!,
          ).getProfilePhoto(),
          connectionID: BlocProvider.of<UserBloc>(
            NavigationService.navigatorKey.currentContext!,
          ).getDeviceID(),
          requestUserDeviceToken: BlocProvider.of<UserBloc>(
            NavigationService.navigatorKey.currentContext!,
          ).getToken(),
          timestamp: await FirebaseCore().getServerTimestamp(),
        ).toMap(),
      );
    await sendFileFirebase.updateUserConnectionRequest(
      userToken,
      userConnectionList,
    );
  }

  void calculateTotalAndNowSpacesInFileList() {
    sendFileUtils.calculateTotalAndNowSpacesInFileList(
        state.fileTotalSpaceAsKB, state.fileNowSpaceAsKB, state.filesList,
        (fileTotalSpaceAsKB, fileNowSpaceAsKB) {
      emit(
        state.copyWith(
          fileTotalSpaceAsKB: fileTotalSpaceAsKB,
          fileNowSpaceAsKB: fileNowSpaceAsKB,
        ),
      );
    });
  }

  Future<void> setFilesListAndPushFirebase(
    List<FirebaseFileModel> filesList,
  ) async {
    final newFilesList = filesList;
    if (ifSenderIDEqualUserID) {
      state.filesList = sendFileUtils.changeFilesDownloadStatusThePrevious(
        newFilesList,
        state.filesList,
      );
    }
    await updateFirebaseConnectionsCollection();
  }

  void setStatus(FirebaseSendFileRequestEnum status) {
    emit(state.copyWith(status: status));
  }

  FirebaseSendFileModel getModel() {
    return state;
  }

  List<dynamic> getFilesList() {
    return state.filesList;
  }

  FirebaseSendFileFirebase getSendFileFirebase() {
    return sendFileFirebase;
  }

  void setModel(FirebaseSendFileModel model) {
    emit(model);
  }

  void setFilesList(List<FirebaseFileModel> filesList) {
    emit(state.copyWith(filesList: filesList));
  }

  void setErrorMessage(String errorMessage) {
    emit(state.copyWith(errorMessage: errorMessage));
  }

  FirebaseSendFileRequestEnum getStatus() {
    return state.status;
  }

  String getConnectionCollectionFirebaseDocumentName() {
    return state.firebaseDocumentName;
  }
}
