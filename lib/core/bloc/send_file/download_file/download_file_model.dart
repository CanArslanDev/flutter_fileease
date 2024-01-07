import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_fileease/core/bloc/send_file/enums/download_status_enum.dart';

class FirebaseDownloadFileModel {
  FirebaseDownloadFileModel({
    required this.name,
    required this.path,
    required this.downloadPath,
    required this.fileCreatedTimestamp,
    required this.downloadStatus,
  });
  String name;
  String path;
  String downloadPath;
  Timestamp fileCreatedTimestamp;
  FirebaseFileModelDownloadStatus downloadStatus;

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'path': path,
      'downloadPath': downloadPath,
      'fileCreatedTimestamp': fileCreatedTimestamp,
      'downloadStatus': downloadStatus.index,
    };
  }

  static FirebaseDownloadFileModel fromMap(
    Map<dynamic, dynamic> map,
  ) {
    return FirebaseDownloadFileModel(
      name: map['name'] as String,
      path: map['path'] as String,
      downloadPath: map['downloadPath'] as String,
      fileCreatedTimestamp: map['fileCreatedTimestamp'] as Timestamp,
      downloadStatus:
          FirebaseFileModelDownloadStatus.values[map['downloadStatus'] as int],
    );
  }
}

List<Map<dynamic, dynamic>> firebaseDownloadFileModelListToMap(
  List<FirebaseDownloadFileModel> filesList,
) {
  final filesListMap = <Map<dynamic, dynamic>>[];
  for (final file in filesList) {
    filesListMap.add(file.toMap());
  }
  return filesListMap;
}

List<FirebaseDownloadFileModel> firebaseDownloadFileModelListFromMap(
  List<dynamic> filesListMap,
) {
  final filesList = <FirebaseDownloadFileModel>[];
  for (final file in filesListMap) {
    filesList
        .add(FirebaseDownloadFileModel.fromMap(file as Map<dynamic, dynamic>));
  }
  return filesList;
}
