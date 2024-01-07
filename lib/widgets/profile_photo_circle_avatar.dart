import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_fileease/core/bloc/device/device_bloc.dart';
import 'package:flutter_fileease/core/bloc/device/profile_photo_cache_model.dart';
import 'package:flutter_fileease/core/bloc/firebase_core/profile_photo_file_model.dart';
import 'package:flutter_fileease/services/file_service.dart';
import 'package:flutter_fileease/services/http_service.dart';
import 'package:flutter_fileease/services/navigation_service.dart';

class ProfilePhotoCircleAvatar extends StatelessWidget {
  const ProfilePhotoCircleAvatar({
    required this.radius,
    required this.profilePhoto,
    super.key,
  });
  final double radius;
  final ProfilePhotoModel profilePhoto;
  @override
  Widget build(BuildContext context) {
    final fileService = FileService();
    final httpService = HttpService();

    Future<Uint8List> getProfilePhoto() async {
      final dirPath = await fileService.getAndControlProfilePhotoPath();
      final checkExist = await fileService
          .checkExistProfilePhoto(profilePhoto.name, dirPath: dirPath);
      final deviceInfoBloc = BlocProvider.of<DeviceBloc>(
        NavigationService.navigatorKey.currentContext!,
      );

      if (deviceInfoBloc.ifExistProfilePhotoToCacheProfilePhotos(
        ProfilePhotoCacheModel(
          name: profilePhoto.name,
          photo: Uint8List(Uint8List.bytesPerElement),
        ),
      )) {
        ///Get From Cache
        return deviceInfoBloc
            .getProfilePhotoFromCacheProfilePhotos(
              ProfilePhotoCacheModel(
                name: profilePhoto.name,
                photo: Uint8List(Uint8List.bytesPerElement),
              ),
            )
            .photo;
      }
      if (checkExist) {
        ///Adding cache
        final fileProfilePhoto = await fileService
            .getProfilePhoto(profilePhoto.name, dirPath: dirPath);
        deviceInfoBloc.addIfNotExistProfilePhotoToCacheProfilePhotos(
          ProfilePhotoCacheModel(
            name: profilePhoto.name,
            photo: fileProfilePhoto.readAsBytesSync(),
          ),
        );
        return fileProfilePhoto.readAsBytesSync();
      } else {
        ///Downloading and adding cache
        final fileProfilePhoto = await httpService.downloadProfilePhotoFile(
          profilePhoto.downloadUrl,
          profilePhoto.name,
        );
        deviceInfoBloc.addIfNotExistProfilePhotoToCacheProfilePhotos(
          ProfilePhotoCacheModel(
            name: profilePhoto.name,
            photo: fileProfilePhoto.readAsBytesSync(),
          ),
        );

        return fileProfilePhoto.readAsBytesSync();
      }
    }

    if (profilePhoto.downloadUrl != '') {
      return FutureBuilder(
        future: getProfilePhoto(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return CircleAvatar(
              radius: radius,
              backgroundImage: MemoryImage(snapshot.data!),
            );
          } else {
            return CircleAvatar(
              radius: radius,
            );
          }
        },
      );
    } else {
      return CircleAvatar(
        radius: radius,
      );
    }
  }
}
