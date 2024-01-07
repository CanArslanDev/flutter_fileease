import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_fileease/core/bloc/device/device_bloc.dart';
import 'package:flutter_fileease/services/navigation_service.dart';

class StorageService {
  final deviceBloc = BlocProvider.of<DeviceBloc>(
    NavigationService.navigatorKey.currentContext!,
  );

  Future<void> writeStringStorage(String id, String key) async {
    await deviceBloc.initializeStorage();
    await deviceBloc.getStorage!.setString(id, key);
  }

  Future<String?> readStringStorage(String id) async {
    await deviceBloc.initializeStorage();
    return deviceBloc.getStorage!.getString(id);
  }
}
