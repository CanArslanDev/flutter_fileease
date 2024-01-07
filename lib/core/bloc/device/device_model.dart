import 'package:flutter_fileease/core/bloc/device/profile_photo_cache_model.dart';

class DeviceModel {
  DeviceModel({
    required this.cacheProfilePhotos,
  });
  List<ProfilePhotoCacheModel> cacheProfilePhotos = [];

  DeviceModel copyWith({
    List<ProfilePhotoCacheModel>? cacheProfilePhotos,
  }) {
    return DeviceModel(
      cacheProfilePhotos: cacheProfilePhotos ?? this.cacheProfilePhotos,
    );
  }
}
