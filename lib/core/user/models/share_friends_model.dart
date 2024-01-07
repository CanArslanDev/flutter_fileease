import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fileease/core/bloc/firebase_core/profile_photo_file_model.dart';

@immutable
class UserShareFriendsModel {
  const UserShareFriendsModel({
    required this.username,
    required this.profilePhoto,
    required this.timestamp,
  });

  final String username;
  final ProfilePhotoModel profilePhoto;
  final Timestamp timestamp;

  UserShareFriendsModel copyWith({
    String? username,
    ProfilePhotoModel? profilePhoto,
    Timestamp? timestamp,
  }) {
    return UserShareFriendsModel(
      username: username ?? this.username,
      profilePhoto: profilePhoto ?? this.profilePhoto,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  @override
  bool operator ==(Object other) {
    if (other is UserShareFriendsModel && other.runtimeType == runtimeType) {
      if (other.username == username) {
        return true;
      }
    }
    return false;
  }

  @override
  int get hashCode => username.hashCode;
}
