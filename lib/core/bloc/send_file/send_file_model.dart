import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_fileease/core/bloc/firebase_core/profile_photo_file_model.dart';
import 'package:flutter_fileease/core/bloc/send_file/download_file/download_file_model.dart';
import 'package:flutter_fileease/core/bloc/send_file/enums/send_file_request_enum.dart';
import 'package:flutter_fileease/core/bloc/send_file/enums/send_file_uploading_enum.dart';
import 'package:flutter_fileease/core/bloc/send_file/file_model.dart';

class FirebaseSendFileModel {
  FirebaseSendFileModel({
    required this.receiverID,
    required this.receiverUsername,
    required this.receiverDeviceToken,
    required this.senderID,
    required this.senderUsename,
    required this.senderDeviceToken,
    required this.firebaseDocumentName,
    required this.filesCount,
    required this.sendSpeed,
    required this.filesList,
    required this.downloadFilesList,
    required this.status,
    required this.errorMessage,
    required this.uploadingStatus,
    required this.fileTotalSpaceAsKB,
    required this.fileNowSpaceAsKB,
    required this.timestamp,
    this.receiverProfilePhoto,
  });
  String receiverID;
  String receiverUsername;
  String receiverDeviceToken;
  String senderID;
  String senderUsename;
  String senderDeviceToken;
  String firebaseDocumentName;
  int filesCount;
  String sendSpeed;
  List<FirebaseFileModel> filesList;
  List<FirebaseDownloadFileModel> downloadFilesList;
  String errorMessage;
  FirebaseSendFileRequestEnum status;
  FirebaseSendFileUploadingEnum uploadingStatus;
  double fileTotalSpaceAsKB;
  double fileNowSpaceAsKB;
  Timestamp timestamp;
  ProfilePhotoModel? receiverProfilePhoto;

  FirebaseSendFileModel copyWith({
    String? receiverID,
    String? receiverUsername,
    String? receiverDeviceToken,
    String? senderID,
    String? senderUsename,
    String? senderDeviceToken,
    String? firebaseDocumentName,
    int? filesCount,
    String? sendSpeed,
    List<FirebaseFileModel>? filesList,
    List<FirebaseDownloadFileModel>? downloadFilesList,
    FirebaseSendFileRequestEnum? status,
    String? errorMessage,
    FirebaseSendFileUploadingEnum? uploadingStatus,
    double? fileTotalSpaceAsKB,
    double? fileNowSpaceAsKB,
    Timestamp? timestamp,
    ProfilePhotoModel? receiverProfilePhoto,
  }) {
    return FirebaseSendFileModel(
      receiverID: receiverID ?? this.receiverID,
      receiverUsername: receiverUsername ?? this.receiverUsername,
      receiverDeviceToken: receiverDeviceToken ?? this.receiverDeviceToken,
      senderID: senderID ?? this.senderID,
      senderUsename: senderUsename ?? this.senderUsename,
      senderDeviceToken: senderDeviceToken ?? this.senderDeviceToken,
      firebaseDocumentName: firebaseDocumentName ?? this.firebaseDocumentName,
      filesCount: filesCount ?? this.filesCount,
      sendSpeed: sendSpeed ?? this.sendSpeed,
      filesList: filesList ?? this.filesList,
      downloadFilesList: downloadFilesList ?? this.downloadFilesList,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      uploadingStatus: uploadingStatus ?? this.uploadingStatus,
      fileTotalSpaceAsKB: fileTotalSpaceAsKB ?? this.fileTotalSpaceAsKB,
      fileNowSpaceAsKB: fileNowSpaceAsKB ?? this.fileNowSpaceAsKB,
      timestamp: timestamp ?? this.timestamp,
      receiverProfilePhoto: receiverProfilePhoto ?? this.receiverProfilePhoto,
    );
  }

  static FirebaseSendFileModel fromMap(
    Map<dynamic, dynamic> model,
  ) {
    return FirebaseSendFileModel(
      receiverID: model['receiverID'] as String,
      receiverUsername: model['receiverUsername'] as String,
      receiverDeviceToken: model['receiverDeviceToken'] as String,
      senderID: model['senderID'] as String,
      senderUsename: model['senderUsename'] as String,
      senderDeviceToken: model['senderDeviceToken'] as String,
      firebaseDocumentName: model['firebaseDocumentName'] as String,
      filesCount: model['filesCount'] as int,
      sendSpeed: model['sendSpeed'] as String,
      filesList: firebaseFileModelListFromMap(
        model['filesList'] as List<dynamic>,
      ),
      downloadFilesList: firebaseDownloadFileModelListFromMap(
        model['downloadFilesList'] as List<dynamic>,
      ),
      status: FirebaseSendFileRequestEnum.values[model['status'] as int],
      errorMessage: model['errorMessage'] as String,
      uploadingStatus:
          FirebaseSendFileUploadingEnum.values[model['uploadingStatus'] as int],
      fileTotalSpaceAsKB: double.parse(model['fileTotalSpaceAsKB'].toString()),
      fileNowSpaceAsKB: double.parse(model['fileNowSpaceAsKB'].toString()),
      timestamp: model['timestamp'] as Timestamp,
    );
  }
}
