import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_fileease/core/bloc/send_file/download_file/download_file_model.dart';
import 'package:flutter_fileease/core/bloc/send_file/enums/send_file_request_enum.dart';
import 'package:flutter_fileease/core/bloc/send_file/enums/send_file_uploading_enum.dart';
import 'package:flutter_fileease/core/bloc/send_file/file_model.dart';
import 'package:flutter_fileease/core/bloc/send_file/send_file_model.dart';
import 'package:flutter_fileease/core/firebase_core.dart';

class FirebaseSendFileFirebase {
  late StreamSubscription<DocumentSnapshot<Object?>> listenConnectionStream;
  Future<void> setFirebaseConnectionsCollection(
    FirebaseSendFileModel state,
  ) async {
    await FirebaseFirestore.instance
        .collection('connections')
        .doc(state.firebaseDocumentName)
        .set({
      'receiverID': state.receiverID,
      'receiverUsername': state.receiverUsername,
      'receiverDeviceToken': state.receiverDeviceToken,
      'senderID': state.senderID,
      'senderUsename': state.senderUsename,
      'senderDeviceToken': state.senderDeviceToken,
      'filesCount': 0,
      'sendSpeed': '0MB/s',
      'filesList': <Map<dynamic, dynamic>>{},
      'downloadFilesList': <Map<dynamic, dynamic>>{},
      'status': FirebaseSendFileRequestEnum.stable.index,
      'errorMessage': '',
      'uploadingStatus': FirebaseSendFileUploadingEnum.stable.index,
      'fileTotalSpaceAsKB': 0.0,
      'fileNowSpaceAsKB': 0.0,
      'timestamp': await FirebaseCore().getServerTimestamp(),
    });
  }

  Future<void> updateFirebaseConnectionsCollection(
    FirebaseSendFileModel state, {
    bool? leaveConnection,
  }) async {
    final updateMap = {
      'receiverID': state.receiverID,
      'receiverUsername': state.receiverUsername,
      'senderID': state.senderID,
      'senderUsename': state.senderUsename,
      'filesCount': state.filesList.length,
      'sendSpeed': state.sendSpeed,
      'filesList': firebaseFileModelListToMap(state.filesList),
      'downloadFilesList': firebaseDownloadFileModelListToMap(
        state.downloadFilesList,
      ),
      'status': FirebaseSendFileRequestEnum.stable.index,
      'errorMessage': '',
      'uploadingStatus': FirebaseSendFileUploadingEnum.stable.index,
      'fileTotalSpaceAsKB': state.fileTotalSpaceAsKB,
      'fileNowSpaceAsKB': state.fileNowSpaceAsKB,
      'timestamp': state.timestamp,
    };

    if (leaveConnection != null) {
      updateMap.addAll({
        'exitedConnection': true,
      });
    }
    await FirebaseFirestore.instance
        .collection('connections')
        .doc(state.firebaseDocumentName)
        .update(updateMap);
  }

  Future<void> updateFirebaseDownloadFilesList(
    FirebaseSendFileModel state,
  ) async {
    await FirebaseFirestore.instance
        .collection('connections')
        .doc(state.firebaseDocumentName)
        .update({
      'downloadFilesList': firebaseDownloadFileModelListToMap(
        state.downloadFilesList,
      ),
    });
  }

  Future<void> updateFirebaseFilesList(
    FirebaseSendFileModel state,
  ) async {
    await FirebaseFirestore.instance
        .collection('connections')
        .doc(state.firebaseDocumentName)
        .update({
      'filesList': firebaseFileModelListToMap(state.filesList),
    });
  }

  Future<void> updateUserConnectionRequest(
    String userToken,
    List<dynamic> userConnectionList,
  ) async {
    await FirebaseFirestore.instance.collection('users').doc(userToken).update({
      'connectionRequests': userConnectionList,
    });
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getUserFromUserCollection(
    String userToken,
  ) async {
    final user = await FirebaseFirestore.instance
        .collection('users')
        .doc(userToken)
        .get();
    return user;
  }

  Future<void> updateDownloadFilesListAndFilesListInFirebase(
    FirebaseSendFileModel state,
  ) async {
    await FirebaseFirestore.instance
        .collection('connections')
        .doc(state.firebaseDocumentName)
        .update({
      'downloadFilesList': firebaseDownloadFileModelListToMap(
        state.downloadFilesList,
      ),
      'filesList': firebaseFileModelListToMap(state.filesList),
    });
  }

  Future<void> listenConnection(
    String firebaseDocumentName,
    void Function(DocumentSnapshot<Object?> querySnapshot) onChanged,
  ) async {
    final DocumentReference reference = FirebaseFirestore.instance
        .collection('connections')
        .doc(firebaseDocumentName);
    listenConnectionStream = reference.snapshots().listen(
          (querySnapshot) async => onChanged.call(querySnapshot),
        );
  }

  Future<void> disposeListenConnection() async {
    await listenConnectionStream.cancel();
  }
}
