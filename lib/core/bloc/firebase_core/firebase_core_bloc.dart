import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_fileease/core/bloc/firebase_core/core_model.dart';
import 'package:flutter_fileease/core/bloc/firebase_core/profile_photo_file_model.dart';
import 'package:flutter_fileease/core/bloc/status_enum.dart';

class FirebaseCoreBloc extends Cubit<FirebaseCoreModel> {
  FirebaseCoreBloc()
      : super(
          FirebaseCoreModel(
            defaultCloudStorageKB: 0,
            profilePhotos: [],
            status: FirebaseCoreStatus.uninitialized,
          ),
        );

  void setModel(
    Map<String, dynamic>? modelMap,
  ) {
    emit(
      state.copyWith(
        defaultCloudStorageKB:
            double.parse(modelMap!['defaultCloudStorageKB'].toString()),
        profilePhotos: (modelMap['profilePhotos'] as List<dynamic>)
            .map(
              (e) => ProfilePhotoModel.fromMap(e as Map<String, dynamic>),
            )
            .toList(),
      ),
    );
  }

  List<ProfilePhotoModel> getProfilePhotos() => state.profilePhotos;

  void getModel() {
    state;
  }

  double get getDefaultStorageKB => state.defaultCloudStorageKB;

  void setStatus(FirebaseCoreStatus status) {
    emit(state.copyWith(status: status));
  }

  FirebaseCoreStatus getStatus() {
    return state.status;
  }

  double getDefaulStorageMB() {
    return state.defaultCloudStorageKB;
  }
}
