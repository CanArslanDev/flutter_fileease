import 'package:flutter_fileease/core/bloc/firebase_core/profile_photo_file_model.dart';
import 'package:flutter_fileease/core/bloc/status_enum.dart';

class FirebaseCoreModel {
  FirebaseCoreModel({
    required this.defaultCloudStorageKB,
    required this.profilePhotos,
    required this.status,
  });
  double defaultCloudStorageKB;
  List<ProfilePhotoModel> profilePhotos;
  FirebaseCoreStatus status = FirebaseCoreStatus.stable;

  FirebaseCoreModel copyWith({
    double? defaultCloudStorageKB,
    List<ProfilePhotoModel>? profilePhotos,
    FirebaseCoreStatus? status,
  }) {
    return FirebaseCoreModel(
      defaultCloudStorageKB:
          defaultCloudStorageKB ?? this.defaultCloudStorageKB,
      profilePhotos: profilePhotos ?? this.profilePhotos,
      status: status ?? this.status,
    );
  }
}
