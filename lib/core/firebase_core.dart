import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_fileease/core/auth/auth_service.dart';
import 'package:flutter_fileease/core/base_core/core_network/core_network.dart';
import 'package:flutter_fileease/core/base_core/core_system.dart';
import 'package:flutter_fileease/core/bloc/firebase_core/firebase_core_bloc.dart';
import 'package:flutter_fileease/core/bloc/send_file/send_file_bloc.dart';
import 'package:flutter_fileease/core/bloc/status_enum.dart';
import 'package:flutter_fileease/core/user/requests/connected_user_model.dart';
import 'package:flutter_fileease/core/user/requests/connection_request_model.dart';
import 'package:flutter_fileease/core/user/user_bloc.dart';
import 'package:flutter_fileease/core/web/web_firebase_core.dart';
import 'package:flutter_fileease/services/navigation_service.dart';
import 'package:flutter_fileease/services/storage_service.dart';
import 'package:flutter_fileease/services/web_service.dart';
import 'package:ntp/ntp.dart';

class FirebaseCore {
  final _firebase = FirebaseFirestore.instance;
  Future<void> initialize() async {
    FirebaseCoreSystem().setStatus(FirebaseCoreStatus.loading);
    await FirebaseCoreNetwork().initialize();
    await updateUserID();
    await updateUser();
    FirebaseAuthService().startListenUser();
    FirebaseCoreSystem().setStatus(FirebaseCoreStatus.stable);
  }

  Future<void> updateUserID() async {
    final storageUserID = await StorageService().readStringStorage('userID');
    if (storageUserID == null) {
      await FirebaseAuthService().createUserID();
    } else {
      await FirebaseAuthService().createUserID(lastUserID: storageUserID);
    }
  }

  Future<void> updateUser() async {
    await FirebaseAuthService().createUser();
  }

  Future<Timestamp> getServerTimestamp({int? reduceDays}) async {
    var date = (WebService.isWeb)
        ? await WebFirebaseCore().getServerTimestamp()
        : await NTP.now();
    if (reduceDays != null) {
      date = date.subtract(Duration(days: reduceDays));
      return Timestamp.fromDate(date);
    } else {
      return Timestamp.fromDate(date);
    }
  }

  Future<bool> checkUserIDForIdsCollection(String dataName) async {
    final snapshot = await _firebase.collection('ids').doc(dataName).get();
    return snapshot.exists;
  }

  Future<void> updateDataIDCollection(String userID) async {
    final deviceToken = await FirebaseCoreSystem().getDeviceToken();
    final userPlatformDetails = await FirebaseCoreSystem().deviceDetailsAsMap();
    final expiration = await FirebaseCore().getServerTimestamp();
    final userData = <String, dynamic>{
      'token': deviceToken,
      'expiration': expiration,
      'userPlatformDetails': userPlatformDetails,
    };
    await _firebase.collection('ids').doc(userID).set(userData);
  }

  Future<void> setUserBlocDataUsersCollection(String id) async {
    final collectionuser = _firebase.collection('users').doc(id);
    final docSnapshotuser = await collectionuser.get();
    final doc = docSnapshotuser.data();
    final deviceToken = await FirebaseCoreSystem().getDeviceToken();
    final userBloc = BlocProvider.of<UserBloc>(
      NavigationService.navigatorKey.currentContext!,
    );
    final firebaseDefaultStorageKB = BlocProvider.of<FirebaseCoreBloc>(
      NavigationService.navigatorKey.currentContext!,
    ).getDefaultStorageKB;
    final userAvailableKB =
        double.parse(doc!['availableCloudStorageKB'].toString());
    try {
      if (firebaseDefaultStorageKB < userAvailableKB) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(deviceToken)
            .update({
          'availableCloudStorageKB': firebaseDefaultStorageKB,
        });
        doc['availableCloudStorageKB'] = firebaseDefaultStorageKB;
      }
      await FirebaseFirestore.instance
          .collection('users')
          .doc(deviceToken)
          .update({
        'connectedUser': {
          'userID': '',
          'token': '',
          'username': '',
        },
      });
      if (doc['connectionID'] != userBloc.getDeviceID()) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(deviceToken)
            .update({
          'connectionID': userBloc.getDeviceID(),
        });
      }
      doc['connectedUser'] = {
        'userID': '',
        'token': '',
        'username': '',
      };
      userBloc.setModel(
        doc,
      );
    } catch (e) {
      await FirebaseCore().updateDataUsersCollection(id);
    }
  }

  Future<void> updateDataUsersCollection(String userID) async {
    final deviceToken = await FirebaseCoreSystem().getDeviceToken();
    final userPlatformDetails = await FirebaseCoreSystem().deviceDetailsAsMap();
    final expiration = await FirebaseCore().getServerTimestamp();
    final connectionID = BlocProvider.of<UserBloc>(
      NavigationService.navigatorKey.currentContext!,
    ).getDeviceID();
    final userData = <String, dynamic>{
      'previousConnectionRequests': <Map<dynamic, dynamic>>{},
      'connectionRequests': <Map<dynamic, dynamic>>{},
      'latestConnections': <Map<dynamic, dynamic>>{},
      'connectedUser': {
        'userID': '',
        'token': '',
        'username': '',
      },
      'connectionID': connectionID,
      'username': 'User',
      'token': deviceToken,
      'expiration': expiration,
      'userPlatformDetails': userPlatformDetails,
      'availableCloudStorageKB': BlocProvider.of<FirebaseCoreBloc>(
        NavigationService.navigatorKey.currentContext!,
      ).getDefaulStorageMB(),
      'profilePhoto': BlocProvider.of<FirebaseCoreBloc>(
        NavigationService.navigatorKey.currentContext!,
      ).getProfilePhotos()[0].toMap(),
    };
    await _firebase.collection('users').doc(userID).set(userData);
  }

  Future<String> getConnectionDataForQRConnectionRequest() async {
    final userBloc = BlocProvider.of<UserBloc>(
      NavigationService.navigatorKey.currentContext!,
    );
    final deviceID = userBloc.getDeviceID();
    final token = userBloc.getToken();
    final timestamp = await FirebaseCore().getServerTimestamp();
    return '''{"connectionID":"$deviceID", "requestUserDeviceToken": "$token", "timestamp": "$timestamp"}''';
  }

  Future<void> acceptUserConnectionRequestFromQR(
    Map<String, dynamic> qrMap,
  ) async {
    await acceptUserConnectionRequest(
      UserConnectionRequestModel(
        connectionID: qrMap['connectionID']! as String,
        requestUserDeviceToken: qrMap['requestUserDeviceToken']! as String,
        timestamp: qrMap['timestamp']! as Timestamp,
      ),
    );
  }

  Future<void> acceptUserConnectionRequest(
    UserConnectionRequestModel connectionRequest,
  ) async {
    await FirebaseCoreSystem()
        .setUserRemoveConnectionRequestAndAddPreviousConnectionRequest(
      connectionRequest,
    );
    final user = BlocProvider.of<UserBloc>(
      NavigationService.navigatorKey.currentContext!,
    );
    final userModel = user.getModel();
    final connectedUserReceiver = ConnectedUserModel(
      token: userModel.token,
      userID: userModel.deviceID,
      username: userModel.username,
    );
    final connectionUser =
        await FirebaseCoreSystem().getUserFromUsersCollection(
      connectionRequest.requestUserDeviceToken,
    );
    final connectionRequestUsername = connectionUser!['username'] as String;
    final connectionRequestToken = connectionUser['token'] as String;
    final connectedUserSender = ConnectedUserModel(
      token: connectionRequest.requestUserDeviceToken,
      userID: connectionRequest.connectionID,
      username: connectionRequestUsername,
    );
    BlocProvider.of<FirebaseSendFileBloc>(
      NavigationService.navigatorKey.currentContext!,
    ).setConnection(
      userModel.deviceID,
      userModel.username,
      userModel.token,
      connectionRequest.connectionID,
      connectionRequestUsername,
      connectionRequestToken,
    );
    await BlocProvider.of<FirebaseSendFileBloc>(
      NavigationService.navigatorKey.currentContext!,
    ).setFirebaseConnectionsCollection();
    await user.updateFirebaseConnectedUser(connectedUserSender);
    await FirebaseFirestore.instance
        .collection('users')
        .doc(connectionRequest.requestUserDeviceToken)
        .update({
      'connectedUser': connectedUserReceiver.toMap(),
    });
    await BlocProvider.of<FirebaseSendFileBloc>(
      NavigationService.navigatorKey.currentContext!,
    ).listenConnection();
    await Navigator.pushNamed(
      NavigationService.navigatorKey.currentContext!,
      '/connection-page',
    );
  }

  Future<void> refuseUserConnectionRequest(
    UserConnectionRequestModel connectionRequest,
  ) async {
    await FirebaseCoreSystem()
        .setUserRemoveConnectionRequestAndAddPreviousConnectionRequest(
      connectionRequest,
      isAccepted: false,
    );
  }
}
