import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_fileease/core/base_core/core_system.dart';
import 'package:flutter_fileease/core/bloc/firebase_core/profile_photo_file_model.dart';
import 'package:flutter_fileease/core/bloc/send_file/file_model.dart';
import 'package:flutter_fileease/core/user/user_bloc.dart';
import 'package:flutter_fileease/services/navigation_service.dart';

class UserLatestConnectionsModel {
  UserLatestConnectionsModel({
    required this.receiverID,
    required this.receiverDeviceToken,
    required this.senderID,
    required this.senderDeviceToken,
    required this.filesCount,
    required this.filesList,
    required this.fileTotalSpaceAsKB,
    required this.timestamp,
    this.receiverUsername,
    this.receiverProfilePhoto,
    this.senderUsename,
    this.senderProfilePhoto,
    this.loading,
  });
  String receiverID;
  String receiverDeviceToken;
  String senderID;
  String senderDeviceToken;
  int filesCount;
  List<FirebaseFileModel> filesList;
  double fileTotalSpaceAsKB;
  Timestamp timestamp;
  String? receiverUsername;
  ProfilePhotoModel? receiverProfilePhoto;
  String? senderUsename;
  ProfilePhotoModel? senderProfilePhoto;
  bool? loading;

  Map<String, dynamic> toMap() {
    return {
      'receiverID': receiverID,
      'receiverDeviceToken': receiverDeviceToken,
      'receiverUsername': receiverUsername,
      'receiverProfilePhoto': receiverProfilePhoto?.toMap(),
      'senderID': senderID,
      'senderDeviceToken': senderDeviceToken,
      'senderUsename': senderUsename,
      'senderProfilePhoto': senderProfilePhoto?.toMap(),
      'filesCount': filesCount,
      'filesList': firebaseFileModelListToMap(filesList),
      'fileTotalSpaceAsKB': fileTotalSpaceAsKB,
      'timestamp': timestamp,
    };
  }

  static UserLatestConnectionsModel fromMap(
    Map<dynamic, dynamic> map,
  ) {
    return UserLatestConnectionsModel(
      receiverDeviceToken: map['receiverDeviceToken'] as String,
      receiverID: map['receiverID'] as String,
      receiverUsername: '',
      receiverProfilePhoto: ProfilePhotoModel(downloadUrl: '', name: ''),
      senderDeviceToken: map['senderDeviceToken'] as String,
      senderID: map['senderID'] as String,
      senderUsename: '',
      senderProfilePhoto: ProfilePhotoModel(downloadUrl: '', name: ''),
      filesCount: map['filesCount'] as int,
      filesList:
          firebaseFileModelListFromMap(map['filesList'] as List<dynamic>),
      fileTotalSpaceAsKB: map['fileTotalSpaceAsKB'] as double,
      timestamp: map['timestamp'] as Timestamp,
      loading: true,
    );
  }

  static Future<UserLatestConnectionsModel> fromMapAsync(
    Map<dynamic, dynamic> map,
  ) async {
    final userBloc = BlocProvider.of<UserBloc>(
      NavigationService.navigatorKey.currentContext!,
    );
    String? receiverUsername;
    String? senderUsername;
    ProfilePhotoModel? receiverProfilePhoto;
    ProfilePhotoModel? senderProfilePhoto;
    if (userBloc.getDeviceID() == map['receiverDeviceToken']) {
      receiverUsername = userBloc.getUsername();
      receiverProfilePhoto = userBloc.getProfilePhoto();
    } else {
      final user = await FirebaseCoreSystem()
          .getUserFromUsersCollection(map['receiverDeviceToken'] as String);
      receiverUsername = user!['username'] as String;
      receiverProfilePhoto = ProfilePhotoModel.fromMap(
        user['profilePhoto'] as Map<String, dynamic>,
      );
    }

    if (userBloc.getDeviceID() == map['senderDeviceToken']) {
      senderUsername = userBloc.getUsername();
      senderProfilePhoto = userBloc.getProfilePhoto();
    } else {
      final user = await FirebaseCoreSystem()
          .getUserFromUsersCollection(map['senderDeviceToken'] as String);
      senderUsername = user!['username'] as String;
      senderProfilePhoto = ProfilePhotoModel.fromMap(
        user['profilePhoto'] as Map<String, dynamic>,
      );
    }
    return UserLatestConnectionsModel(
      receiverID: map['receiverID'] as String,
      receiverDeviceToken: map['receiverDeviceToken'] as String,
      receiverUsername: receiverUsername,
      receiverProfilePhoto: receiverProfilePhoto,
      senderID: map['senderID'] as String,
      senderDeviceToken: map['senderDeviceToken'] as String,
      senderUsename: senderUsername,
      senderProfilePhoto: senderProfilePhoto,
      filesCount: map['filesCount'] as int,
      filesList:
          firebaseFileModelListFromMap(map['filesList'] as List<dynamic>),
      fileTotalSpaceAsKB: map['fileTotalSpaceAsKB'] as double,
      timestamp: map['timestamp'] as Timestamp,
      loading: false,
    );
  }
}

List<UserLatestConnectionsModel> convertLatestConnectionsListFromMap(
  List<dynamic> latestConnectionsList,
) {
  final latestConnections = <UserLatestConnectionsModel>[];
  for (final latestConnectionsData in latestConnectionsList) {
    latestConnections.add(
      UserLatestConnectionsModel.fromMap(
        latestConnectionsData as Map<dynamic, dynamic>,
      ),
    );
  }
  return latestConnections;
}

Future<List<UserLatestConnectionsModel>>
    userLatestConnectionsModelListFromMapForUpdate(
  List<dynamic> userConnectionRequestModelList,
  List<UserLatestConnectionsModel> blocConnectionRequests,
  void Function(List<UserLatestConnectionsModel>? defaultList) setDefaultList,
  void Function(List<UserLatestConnectionsModel> updatedList) updateList, {
  void Function()? updateFinishEvent,
}) async {
  final defaultUserConnectionRequests = <UserLatestConnectionsModel>[];
  for (final userConnectionRequestModelData in userConnectionRequestModelList) {
    final index = blocConnectionRequests.indexWhere(
      (element) =>
          element.senderID ==
              (userConnectionRequestModelData
                  as Map<String, dynamic>)['senderID'] as String &&
          element.receiverID ==
              userConnectionRequestModelData['receiverID'] as String &&
          element.timestamp ==
              userConnectionRequestModelData['timestamp'] as Timestamp,
    );
    if (index == -1) {
      defaultUserConnectionRequests.add(
        UserLatestConnectionsModel.fromMap(
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
            element.senderID == userConnectionRequestModelData.senderID &&
            element.receiverID == userConnectionRequestModelData.receiverID &&
            element.timestamp == userConnectionRequestModelData.timestamp,
      );
      userConnectionRequests[index] =
          await UserLatestConnectionsModel.fromMapAsync(
        userConnectionRequestModelData.toMap(),
      );
      updateList.call(userConnectionRequests);
    }
  }
  if (updateFinishEvent != null) updateFinishEvent.call();
  return userConnectionRequests;
}
