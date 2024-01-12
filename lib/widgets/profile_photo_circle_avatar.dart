import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_fileease/core/bloc/device/device_bloc.dart';
import 'package:flutter_fileease/core/bloc/device/profile_photo_cache_model.dart';
import 'package:flutter_fileease/core/bloc/firebase_core/profile_photo_file_model.dart';
import 'package:flutter_fileease/services/file_service.dart';
import 'package:flutter_fileease/services/http_service.dart';
import 'package:flutter_fileease/services/navigation_service.dart';
import 'package:flutter_fileease/services/web_service.dart';
import 'package:transparent_image/transparent_image.dart';

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

    if (WebService.isWeb) {
      return profilePhoto.downloadUrl != ''
          ? FadeInImage.memoryNetwork(
              placeholder: kTransparentImage,
              image:
                  'https://cors-anywhere.herokuapp.com/${profilePhoto.downloadUrl}',
              width: radius * 2,
              fit: BoxFit.cover,
            )
          : SizedBox(
              width: radius * 2,
            );
      // return profilePhoto.downloadUrl != ''
      //     ? ClipRRect(
      //         borderRadius: BorderRadius.circular(1000),
      //         child: Image.network(
      //           'https://cors-anywhere.herokuapp.com/${profilePhoto.downloadUrl}', //For web cors because image.network images not working on web
      //           width: radius * 2,
      //           loadingBuilder: (context, child, loadingProgress) {
      //             final isLoading = ValueNotifier(true);
      //             if (loadingProgress != null) {
      //               isLoading.value = false;
      //             }

      //             return ValueListenableBuilder(
      //                 valueListenable: isLoading,
      //                 builder: (context, bool value, child) {
      //                   return AnimatedOpacity(
      //                     opacity: value ? 0 : 1,
      //                     duration: const Duration(seconds: 2),
      //                     child: child,
      //                   );
      //                 });
      //           },
      //         ),
      //       )
      //     : SizedBox(
      //         width: radius * 2,
      //       );
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
