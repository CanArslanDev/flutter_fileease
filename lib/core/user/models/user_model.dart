import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_fileease/core/bloc/firebase_core/profile_photo_file_model.dart';
import 'package:flutter_fileease/core/user/models/latest_connections_model.dart';
import 'package:flutter_fileease/core/user/models/share_friends_model.dart';
import 'package:flutter_fileease/core/user/requests/connected_user_model.dart';
import 'package:flutter_fileease/core/user/requests/connection_request_model.dart';
import 'package:flutter_fileease/core/user/requests/previous_connection_request_model.dart';

class UserModel {
  UserModel({
    required this.deviceID,
    required this.userPlatformDetails,
    required this.expiration,
    required this.availableCloudStorageKB,
    required this.token,
    required this.connectionRequests,
    required this.previousConnectionRequests,
    required this.latestConnections,
    required this.connectedUser,
    required this.username,
    required this.profilePhoto,
    required this.shareFriends,
  });
  String deviceID;
  Map<String, dynamic> userPlatformDetails;
  Timestamp expiration;
  double availableCloudStorageKB;
  String token;
  List<UserConnectionRequestModel> connectionRequests;
  List<UserPreviousConnectionRequestModel> previousConnectionRequests;
  List<UserLatestConnectionsModel> latestConnections;
  ConnectedUserModel connectedUser;
  String username;
  ProfilePhotoModel profilePhoto;
  List<UserShareFriendsModel> shareFriends;

  UserModel copyWith({
    String? deviceID,
    Map<String, dynamic>? userPlatformDetails,
    Timestamp? expiration,
    double? availableCloudStorageKB,
    String? token,
    List<UserConnectionRequestModel>? connectionRequests,
    List<UserPreviousConnectionRequestModel>? previousConnectionRequests,
    List<UserLatestConnectionsModel>? latestConnections,
    ConnectedUserModel? connectedUser,
    String? username,
    ProfilePhotoModel? profilePhoto,
    List<UserShareFriendsModel>? shareFriends,
  }) {
    return UserModel(
      deviceID: deviceID ?? this.deviceID,
      userPlatformDetails: userPlatformDetails ?? this.userPlatformDetails,
      expiration: expiration ?? this.expiration,
      availableCloudStorageKB:
          availableCloudStorageKB ?? this.availableCloudStorageKB,
      token: token ?? this.token,
      connectionRequests: connectionRequests ?? this.connectionRequests,
      previousConnectionRequests:
          previousConnectionRequests ?? this.previousConnectionRequests,
      latestConnections: latestConnections ?? this.latestConnections,
      connectedUser: connectedUser ?? this.connectedUser,
      username: username ?? this.username,
      profilePhoto: profilePhoto ?? this.profilePhoto,
      shareFriends: shareFriends ?? this.shareFriends,
    );
  }
}
