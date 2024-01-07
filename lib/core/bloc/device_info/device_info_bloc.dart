import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_fileease/core/bloc/device_info/device_info_model.dart';
import 'package:flutter_fileease/core/bloc/device_info/profile_photo_cache_model.dart';

class DeviceInfoBloc extends Cubit<DeviceInfoModel> {
  DeviceInfoBloc() : super(DeviceInfoModel(cacheProfilePhotos: []));

  void addIfNotExistProfilePhotoToCacheProfilePhotos(
    ProfilePhotoCacheModel profilePhoto,
  ) {
    final tempProfilePhotosList = state.cacheProfilePhotos;
    if (tempProfilePhotosList.contains(profilePhoto)) return;
    tempProfilePhotosList.add(profilePhoto);
    emit(state.copyWith(cacheProfilePhotos: tempProfilePhotosList));
  }

  ProfilePhotoCacheModel getProfilePhotoFromCacheProfilePhotos(
    ProfilePhotoCacheModel profilePhoto,
  ) {
    final tempProfilePhotosList = state.cacheProfilePhotos;
    final index = tempProfilePhotosList.indexOf(profilePhoto);
    return tempProfilePhotosList[index];
  }

  bool ifExistProfilePhotoToCacheProfilePhotos(
    ProfilePhotoCacheModel profilePhoto,
  ) {
    final tempProfilePhotosList = state.cacheProfilePhotos;
    if (tempProfilePhotosList.contains(profilePhoto)) return true;
    return false;
  }
}
