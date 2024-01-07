import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_fileease/core/base_core/core_system.dart';
import 'package:flutter_fileease/core/bloc/firebase_core/profile_photo_file_model.dart';

@immutable
class UserPreviousConnectionRequestModel {
  const UserPreviousConnectionRequestModel({
    required this.connectionID,
    required this.requestUserDeviceToken,
    required this.timestamp,
    required this.isAccepted,
    this.username,
    this.profilePhoto,
    this.loading,
  });

  final String? username;
  final ProfilePhotoModel? profilePhoto;
  final String connectionID;
  final String requestUserDeviceToken;
  final Timestamp timestamp;
  final bool isAccepted;
  final bool? loading;

  UserPreviousConnectionRequestModel copyWith({
    String? username,
    ProfilePhotoModel? profilePhoto,
    String? connectionID,
    String? requestUserDeviceToken,
    bool? isAccepted,
    Timestamp? timestamp,
  }) {
    return UserPreviousConnectionRequestModel(
      username: username ?? this.username,
      profilePhoto: profilePhoto ?? this.profilePhoto,
      connectionID: connectionID ?? this.connectionID,
      requestUserDeviceToken:
          requestUserDeviceToken ?? this.requestUserDeviceToken,
      isAccepted: isAccepted ?? this.isAccepted,
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
      'isAccepted': isAccepted,
    };
  }

  static UserPreviousConnectionRequestModel fromMap(
    Map<String, dynamic> map,
  ) {
    return UserPreviousConnectionRequestModel(
      username: '',
      profilePhoto: ProfilePhotoModel(name: '', downloadUrl: ''),
      connectionID: map['connectionID'] as String,
      requestUserDeviceToken: map['requestUserDeviceToken'] as String,
      timestamp: map['timestamp'] as Timestamp,
      isAccepted: map['isAccepted'] as bool,
    );
  }

  static Future<UserPreviousConnectionRequestModel> fromMapAsync(
    Map<String, dynamic> map,
  ) async {
    final user = await FirebaseCoreSystem()
        .getUserFromUsersCollection(map['requestUserDeviceToken'] as String);
    final profilePhoto = ProfilePhotoModel.fromMap(
      user!['profilePhoto'] as Map<String, dynamic>,
    );
    final username = user['username'] as String;
    return UserPreviousConnectionRequestModel(
      username: username,
      profilePhoto: profilePhoto,
      connectionID: map['connectionID'] as String,
      requestUserDeviceToken: map['requestUserDeviceToken'] as String,
      timestamp: map['timestamp'] as Timestamp,
      isAccepted: map['isAccepted'] as bool,
    );
  }

  @override
  bool operator ==(Object other) {
    if (other is UserPreviousConnectionRequestModel &&
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

Future<List<UserPreviousConnectionRequestModel>>
    userPreviousConnectionRequestModelListFromMap(
  List<dynamic> userConnectionRequestModelList,
) async {
  final userConnectionRequests = <UserPreviousConnectionRequestModel>[];
  for (final userConnectionRequestModelData in userConnectionRequestModelList) {
    userConnectionRequests.add(
      UserPreviousConnectionRequestModel.fromMap(
        userConnectionRequestModelData as Map<String, dynamic>,
      ),
    );
  }
  return userConnectionRequests;
}

Future<List<UserPreviousConnectionRequestModel>>
    userPreviousConnectionRequestModelListFromMapForUpdate(
  List<dynamic> userConnectionRequestModelList,
  List<UserPreviousConnectionRequestModel> blocConnectionRequests,
  void Function(List<UserPreviousConnectionRequestModel> defaultList)
      setDefaultList,
  void Function(List<UserPreviousConnectionRequestModel> updatedList)
      updateList,
) async {
  final defaultUserConnectionRequests = <UserPreviousConnectionRequestModel>[];
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
        UserPreviousConnectionRequestModel.fromMap(
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
          await UserPreviousConnectionRequestModel.fromMapAsync(
        userConnectionRequestModelData.toMap(),
      );
      updateList.call(userConnectionRequests);
    }
  }
  return userConnectionRequests;
}

List<Map<String, dynamic>> userPreviousConnectionRequestModelListToMap(
  List<UserPreviousConnectionRequestModel> userConnectionRequestModelList,
) {
  final userConnectionRequests = <Map<String, dynamic>>[];
  for (final userConnectionRequestModel in userConnectionRequestModelList) {
    userConnectionRequests.add(
      userConnectionRequestModel.toMap(),
    );
  }
  return userConnectionRequests;
}
