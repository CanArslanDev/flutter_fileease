import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_fileease/core/bloc/firebase_core/profile_photo_file_model.dart';
import 'package:flutter_fileease/core/bloc/send_file/send_file_bloc.dart';
import 'package:flutter_fileease/core/user/models/latest_connections_model.dart';
import 'package:flutter_fileease/core/user/models/share_friends_model.dart';
import 'package:flutter_fileease/core/user/models/user_model.dart';
import 'package:flutter_fileease/core/user/requests/connected_user_model.dart';
import 'package:flutter_fileease/core/user/requests/connection_request_model.dart';
import 'package:flutter_fileease/core/user/requests/previous_connection_request_model.dart';
import 'package:flutter_fileease/services/navigation_service.dart';

class UserBloc extends Cubit<UserModel> {
  UserBloc()
      : super(
          UserModel(
            deviceID: '',
            userPlatformDetails: {},
            expiration: Timestamp.now(),
            availableCloudStorageKB: 0,
            token: '',
            connectionRequests: [],
            previousConnectionRequests: [],
            latestConnections: [],
            connectedUser:
                ConnectedUserModel(token: '', userID: '', username: ''),
            username: '',
            profilePhoto: ProfilePhotoModel(
              name: '',
              downloadUrl: '',
            ),
            shareFriends: [],
          ),
        );

  void setID(String deviceID) {
    emit(state.copyWith(deviceID: deviceID));
  }

  void setModel(
    Map<String, dynamic>? modelMap,
  ) {
    try {
      final latestConnections = <Map<dynamic, dynamic>>[];
      for (final latestConnectionsData
          in modelMap!['latestConnections'] as List<dynamic>) {
        latestConnections.add(latestConnectionsData as Map<dynamic, dynamic>);
      }
      emit(
        state.copyWith(
          deviceID: (modelMap['deviceID'] != null)
              ? modelMap['deviceID'] as String
              : null,
          expiration: modelMap['expiration'] as Timestamp,
          userPlatformDetails:
              modelMap['userPlatformDetails'] as Map<String, dynamic>,
          availableCloudStorageKB:
              double.parse(modelMap['availableCloudStorageKB'].toString()),
          token: modelMap['token'] as String,
          latestConnections:
              convertLatestConnectionsListFromMap(latestConnections),
          connectedUser: ConnectedUserModel.fromMap(
            modelMap['connectedUser'] as Map<String, dynamic>,
          ),
          username: modelMap['username'] as String,
          profilePhoto: ProfilePhotoModel.fromMap(
            modelMap['profilePhoto'] as Map<String, dynamic>,
          ),
        ),
      );
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void listUnionLatestConnectionsInState(
    UserLatestConnectionsModel latestConnectionsModel,
  ) {
    final newLatestConnections = state.latestConnections;
    final index = state.latestConnections.indexWhere(
      (item) =>
          item.senderID == latestConnectionsModel.senderID &&
          item.receiverID == latestConnectionsModel.receiverID &&
          item.timestamp == latestConnectionsModel.timestamp,
    );
    if (index != -1) {
      newLatestConnections[index] = latestConnectionsModel;
    } else {
      newLatestConnections.add(latestConnectionsModel);
    }
    emit(state.copyWith(latestConnections: newLatestConnections));
  }

  Future<void> sendFirebaseLatestConnectionsList() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(state.token)
        .update({
      'latestConnections':
          convertLatestConnectionsListToMap(state.latestConnections),
    });
  }

  List<Map<dynamic, dynamic>> convertLatestConnectionsListToMap(
    List<UserLatestConnectionsModel> latestConnectionsList,
  ) {
    final latestConnections = <Map<dynamic, dynamic>>[];
    for (final latestConnectionsData in latestConnectionsList) {
      latestConnections.add(latestConnectionsData.toMap());
    }
    return latestConnections;
  }

  Future<void> setLatestConnectionsListAndSendFirebase(
    UserLatestConnectionsModel latestConnectionsModel,
  ) async {
    state.latestConnections.add(latestConnectionsModel);
    final DocumentReference reference =
        FirebaseFirestore.instance.collection('users').doc(state.token);
    await reference.update({
      'latestConnections':
          convertLatestConnectionsListToMap(state.latestConnections),
    });
  }

  void listenUserDataFromFirebase() {
    final DocumentReference reference =
        FirebaseFirestore.instance.collection('users').doc(state.token);
    reference.snapshots().listen((querySnapshot) async {
      final userFirebaseData = querySnapshot.data()! as Map<dynamic, dynamic>;
      final connectedUser =
          userFirebaseData['connectedUser'] as Map<dynamic, dynamic>;

      if (connectedUser['token'] != '' &&
          connectedUser['userID'] != '' &&
          connectedUser['username'] != '' &&
          !BlocProvider.of<FirebaseSendFileBloc>(
            NavigationService.navigatorKey.currentContext!,
          ).ifConnectionExist()) {
        BlocProvider.of<FirebaseSendFileBloc>(
          NavigationService.navigatorKey.currentContext!,
        ).setConnection(
          connectedUser['userID'] as String,
          connectedUser['username'] as String,
          connectedUser['token'] as String,
          state.deviceID,
          state.username,
          state.token,
        );
        await BlocProvider.of<FirebaseSendFileBloc>(
          NavigationService.navigatorKey.currentContext!,
        ).listenConnection();
        await Navigator.pushNamed(
          NavigationService.navigatorKey.currentContext!,
          '/connection-page',
        );
      }
      unawaited(
        setUserConnectionsLists(
          connectedUser as Map<String, dynamic>,
          userFirebaseData['latestConnections'] as List<dynamic>,
          userFirebaseData['connectionRequests'] as List<dynamic>,
          userFirebaseData['previousConnectionRequests'] as List<dynamic>,
        ),
      );
    });
  }

  Future<void> setUserConnectionsLists(
    Map<String, dynamic> connectedUser,
    List<dynamic> latestConnections,
    List<dynamic> connectionRequests,
    List<dynamic> previousConnectionRequest,
  ) async {
    if (NavigationService.getRouteName == '/connection-page') {
      return;
    }
    unawaited(
      userConnectionRequestModelListFromMapForUpdate(
          connectionRequests, state.connectionRequests, (defaultList) {
        emit(state.copyWith(connectionRequests: defaultList));
      }, (updatedList) {
        emit(state.copyWith(connectionRequests: updatedList));
      }),
    );

    unawaited(
      userPreviousConnectionRequestModelListFromMapForUpdate(
          previousConnectionRequest, state.previousConnectionRequests,
          (defaultList) {
        emit(state.copyWith(previousConnectionRequests: defaultList));
      }, (updatedList) {
        emit(state.copyWith(previousConnectionRequests: updatedList));
      }),
    );

    unawaited(
      userLatestConnectionsModelListFromMapForUpdate(
        latestConnections,
        state.latestConnections,
        (defaultList) {
          emit(state.copyWith(latestConnections: defaultList));
        },
        (updatedList) {
          emit(state.copyWith(latestConnections: updatedList));
        },
        updateFinishEvent: _setShareFriendsFromLatestConnections,
      ),
    );
  }

  void _setShareFriendsFromLatestConnections() {
    final shareFriends = <UserShareFriendsModel>[];
    for (final latestConnection in state.latestConnections) {
      if (latestConnection.senderID == state.deviceID) {
        final shareFriendsModel = UserShareFriendsModel(
          username: latestConnection.receiverUsername!,
          profilePhoto: latestConnection.receiverProfilePhoto!,
          timestamp: latestConnection.timestamp,
        );
        if (!shareFriends.contains(shareFriendsModel)) {
          shareFriends.add(
            shareFriendsModel,
          );
        }
      } else {
        final shareFriendsModel = UserShareFriendsModel(
          username: latestConnection.senderUsename!,
          profilePhoto: latestConnection.senderProfilePhoto!,
          timestamp: latestConnection.timestamp,
        );
        if (!shareFriends.contains(shareFriendsModel)) {
          shareFriends.add(
            shareFriendsModel,
          );
        }
      }
    }
    emit(state.copyWith(shareFriends: shareFriends));
  }

  Future<void> setFirebaseAndBlocConnectionAndPreviousConnectionRequests(
    List<UserConnectionRequestModel> connectionRequestList,
    List<UserPreviousConnectionRequestModel> previousConnectionRequestList, {
    List<UserConnectionRequestModel>? blocConnectionRequestList,
    List<UserPreviousConnectionRequestModel>? blocPreviousConnectionRequestList,
  }) async {
    emit(
      state.copyWith(
        connectionRequests: (blocConnectionRequestList != null)
            ? blocConnectionRequestList
            : connectionRequestList,
        previousConnectionRequests: (blocPreviousConnectionRequestList != null)
            ? blocPreviousConnectionRequestList
            : previousConnectionRequestList,
      ),
    );
    await FirebaseFirestore.instance
        .collection('users')
        .doc(state.token)
        .update({
      'connectionRequests':
          userConnectionRequestModelListToMap(connectionRequestList),
      'previousConnectionRequests': userPreviousConnectionRequestModelListToMap(
        previousConnectionRequestList,
      ),
    });
  }

  Future<void> updateFirebaseConnectedUser(
    ConnectedUserModel connectedUser,
  ) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(state.token)
        .update({
      'connectedUser': connectedUser.toMap(),
    });
  }

  Future<void> decreaseUserCloudStorageAndSendFirebase(
    double fileSizeKB,
  ) async {
    final newAvailableCloudStorageKB = state.availableCloudStorageKB -
        double.parse(fileSizeKB.toStringAsFixed(0));

    emit(
      state.copyWith(
        availableCloudStorageKB: newAvailableCloudStorageKB,
      ),
    );
    final DocumentReference reference =
        FirebaseFirestore.instance.collection('users').doc(state.token);
    await reference.update({
      'availableCloudStorageKB': state.availableCloudStorageKB,
    });
  }

  UserModel getModel() {
    return state;
  }

  List<UserConnectionRequestModel> getConnectionRequests() {
    return state.connectionRequests;
  }

  List<UserPreviousConnectionRequestModel> getPreviousConnectionRequests() {
    return state.previousConnectionRequests;
  }

  String getDeviceID() {
    return state.deviceID;
  }

  ProfilePhotoModel getProfilePhoto() {
    return state.profilePhoto;
  }

  String getUsername() {
    return state.username;
  }

  String getToken() {
    return state.token;
  }
}
