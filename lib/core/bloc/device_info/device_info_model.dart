import 'package:flutter_fileease/core/bloc/device_info/profile_photo_cache_model.dart';

class DeviceInfoModel {
  DeviceInfoModel({
    required this.cacheProfilePhotos,
  });
  List<ProfilePhotoCacheModel> cacheProfilePhotos = [];

  DeviceInfoModel copyWith({
    List<ProfilePhotoCacheModel>? cacheProfilePhotos,
  }) {
    return DeviceInfoModel(
      cacheProfilePhotos: cacheProfilePhotos ?? this.cacheProfilePhotos,
    );
  }
}
