import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_fileease/core/bloc/device/device_model.dart';
import 'package:flutter_fileease/core/bloc/device/profile_photo_cache_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DeviceBloc extends Cubit<DeviceModel> {
  DeviceBloc() : super(DeviceModel(cacheProfilePhotos: []));

  SharedPreferences? deviceStorage;

  Future<void> initializeStorage() async {
    deviceStorage ??= await SharedPreferences.getInstance();
  }

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

  SharedPreferences? get getStorage {
    return deviceStorage;
  }
}
