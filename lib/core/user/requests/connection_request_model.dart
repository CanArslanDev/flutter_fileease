import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_fileease/core/base_core/core_system.dart';
import 'package:flutter_fileease/core/bloc/firebase_core/profile_photo_file_model.dart';

@immutable
class UserConnectionRequestModel {
  const UserConnectionRequestModel({
    required this.connectionID,
    required this.requestUserDeviceToken,
    required this.timestamp,
    this.username,
    this.profilePhoto,
    this.loading,
  });
  final String? username;
  final ProfilePhotoModel? profilePhoto;
  final String connectionID;
  final String requestUserDeviceToken;
  final Timestamp timestamp;
  final bool? loading;

  UserConnectionRequestModel copyWith({
    String? username,
    ProfilePhotoModel? profilePhoto,
    String? connectionID,
    String? requestUserDeviceToken,
    Timestamp? timestamp,
  }) {
    return UserConnectionRequestModel(
      username: username ?? this.username,
      profilePhoto: profilePhoto ?? this.profilePhoto,
      connectionID: connectionID ?? this.connectionID,
      requestUserDeviceToken:
          requestUserDeviceToken ?? this.requestUserDeviceToken,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'profilePhoto': profilePhoto?.toMap(),
      'connectionID': connectionID,
      'requestUserDeviceToken': requestUserDeviceToken,
      'timestamp': timestamp,
    };
  }

  static Future<UserConnectionRequestModel> fromMapAsync(
    Map<String, dynamic> map,
  ) async {
    final user = await FirebaseCoreSystem()
        .getUserFromUsersCollection(map['requestUserDeviceToken'] as String);
    final profilePhoto = ProfilePhotoModel.fromMap(
      user!['profilePhoto'] as Map<String, dynamic>,
    );
    final username = user['username'] as String;
    return UserConnectionRequestModel(
      username: username,
      profilePhoto: profilePhoto,
      connectionID: map['connectionID'] as String,
      requestUserDeviceToken: map['requestUserDeviceToken'] as String,
      timestamp: map['timestamp'] as Timestamp,
      loading: false,
    );
  }

  static UserConnectionRequestModel fromMap(
    Map<String, dynamic> map,
  ) {
    return UserConnectionRequestModel(
      username: '',
      profilePhoto: ProfilePhotoModel(
        downloadUrl: '',
        name: '',
      ),
      connectionID: map['connectionID'] as String,
      requestUserDeviceToken: map['requestUserDeviceToken'] as String,
      timestamp: map['timestamp'] as Timestamp,
      loading: true,
    );
  }

  @override
  bool operator ==(Object other) {
    if (other is UserConnectionRequestModel &&
        other.runtimeType == runtimeType) {
      if (other.connectionID == connectionID) {
        return true;
      }
    }
    return false;
  }

  @override
  int get hashCode => connectionID.hashCode;
}

Future<List<UserConnectionRequestModel>> userConnectionRequestModelListFromMap(
  List<dynamic> userConnectionRequestModelList,
) async {
  final userConnectionRequests = <UserConnectionRequestModel>[];
  for (final userConnectionRequestModelData in userConnectionRequestModelList) {
    userConnectionRequests.add(
      await UserConnectionRequestModel.fromMapAsync(
        userConnectionRequestModelData as Map<String, dynamic>,
      ),
    );
  }
  return userConnectionRequests;
}

Future<List<UserConnectionRequestModel>>
    userConnectionRequestModelListFromMapForUpdate(
  List<dynamic> userConnectionRequestModelList,
  List<UserConnectionRequestModel> blocConnectionRequests,
  void Function(List<UserConnectionRequestModel> defaultList) setDefaultList,
  void Function(List<UserConnectionRequestModel> updatedList) updateList,
) async {
  final defaultUserConnectionRequests = <UserConnectionRequestModel>[];
  for (final userConnectionRequestModelData in userConnectionRequestModelList) {
    final index = blocConnectionRequests.indexWhere(
      (element) =>
          element.connectionID ==
              (userConnectionRequestModelData
                  as Map<String, dynamic>)['connectionID'] as String &&
          element.timestamp ==
              userConnectionRequestModelData['timestamp'] as Timestamp,
    );
    if (index == -1) {
      defaultUserConnectionRequests.add(
        UserConnectionRequestModel.fromMap(
          userConnectionRequestModelData as Map<String, dynamic>,
        ),
      );
    } else {
      defaultUserConnectionRequests.add(
        blocConnectionRequests[index],
      );
    }
  }
  setDefaultList.call(defaultUserConnectionRequests);
  final userConnectionRequests = defaultUserConnectionRequests;
  for (final userConnectionRequestModelData in userConnectionRequests) {
    if (userConnectionRequestModelData.loading ?? true) {
      final index = userConnectionRequests.indexWhere(
        (element) =>
            element.connectionID ==
                userConnectionRequestModelData.connectionID &&
            element.timestamp == userConnectionRequestModelData.timestamp,
      );
      userConnectionRequests[index] =
          await UserConnectionRequestModel.fromMapAsync(
        userConnectionRequestModelData.toMap(),
      );
      updateList.call(userConnectionRequests);
    }
  }
  return userConnectionRequests;
}

List<Map<String, dynamic>> userConnectionRequestModelListToMap(
  List<UserConnectionRequestModel> userConnectionRequestModelList,
) {
  final userConnectionRequests = <Map<String, dynamic>>[];
  for (final userConnectionRequestModel in userConnectionRequestModelList) {
    userConnectionRequests.add(
      userConnectionRequestModel.toMap(),
    );
  }
  return userConnectionRequests;
}
