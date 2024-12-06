import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_fileease/core/bloc/firebase_core/firebase_core_bloc.dart';
import 'package:flutter_fileease/core/bloc/status_enum.dart';
import 'package:flutter_fileease/core/firebase_core.dart';
import 'package:flutter_fileease/core/user/requests/connection_request_model.dart';
import 'package:flutter_fileease/core/user/requests/previous_connection_request_model.dart';
import 'package:flutter_fileease/core/user/user_bloc.dart';
import 'package:flutter_fileease/core/web/web_firebase_core.dart';
import 'package:flutter_fileease/services/navigation_service.dart';
import 'package:flutter_fileease/services/web_service.dart';
import 'package:flutter_udid/flutter_udid.dart';

class FirebaseCoreSystem {
  String createRandomUserID() {
    final random = Random();
    const min = 100000;
    const max = 999999;
    final value = min + random.nextInt((max + 1) - min);
    return value.toString();
  }

  int timestampDayCalculation(Timestamp timestamp1, Timestamp timestamp2) {
    final date1 = timestamp1.toDate();
    final date2 = timestamp2.toDate();
    final difference = date2.difference(date1);
    final daysBetween = difference.inDays;
    return daysBetween;
  }

  Future<Timestamp> getUserExpirationFromIDCollection(String id) async {
    try {
      final collectionuser =
          FirebaseFirestore.instance.collection('ids').doc(id);
      final docSnapshotuser = await collectionuser.get();
      final doc = docSnapshotuser.data();
      if (doc!['expiration'] != null) {
        return doc['expiration'] as Timestamp;
      } else {
        return FirebaseCore().getServerTimestamp(reduceDays: 365);
      }
    } catch (e) {
      return FirebaseCore().getServerTimestamp(reduceDays: 365);
    }
  }

  Future<String> getUserUsernameFromUsersCollection(String id) async {
    final collectionuser =
        FirebaseFirestore.instance.collection('users').doc(id);
    final docSnapshotuser = await collectionuser.get();
    final doc = docSnapshotuser.data();
    return doc!['username'] as String;
  }

  Future<Map<String, dynamic>?> getUserFromUsersCollection(
    String id,
  ) async {
    final collectionuser =
        FirebaseFirestore.instance.collection('users').doc(id);
    final docSnapshotuser = await collectionuser.get();
    final doc = docSnapshotuser.data();
    return doc;
  }

  Future<bool> checkUserFromUsersCollection(String id) async {
    try {
      final collectionuser =
          FirebaseFirestore.instance.collection('users').doc(id);
      final docSnapshotuser = await collectionuser.get();
      final doc = docSnapshotuser.data();
      if (doc!['token'] != null &&
          doc['expiration'] != null &&
          doc['connectionID'] != null &&
          doc['connectionRequests'] != null &&
          doc['previousConnectionRequests'] != null &&
          doc['availableCloudStorageKB'] != null &&
          doc['latestConnections'] != null &&
          doc['connectedUser'] != null &&
          doc['username'] != null &&
          doc['profilePhoto'] != null) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<String> getUserTokenFromUsersCollection(String id) async {
    final collectionuser = FirebaseFirestore.instance.collection('ids').doc(id);
    final docSnapshotuser = await collectionuser.get();
    final doc = docSnapshotuser.data();
    try {
      if (doc!['token'] != null) {
        return doc['token'] as String;
      } else {
        return '';
      }
    } catch (e) {
      return '';
    }
  }

  Future<Map<String, String>> deviceDetailsAsMap() async {
    if (WebService.isWeb) {
      return {
        'id': '',
        'name': 'web',
        'version': '',
        'brand': '',
        'model': '',
      };
    }
    final deviceInfoPlugin = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      final build = await deviceInfoPlugin.androidInfo;
      final buildVersion = {
        'baseOS': build.version.baseOS,
        'sdkInt': build.version.sdkInt,
        'release': build.version.release,
        'codename': build.version.codename,
        'incremental': build.version.incremental,
        'previewSdkInt': build.version.previewSdkInt,
        'securityPatch': build.version.securityPatch,
      };
      return {
        'id': build.id,
        'name': build.device,
        'version': buildVersion.toString(),
        'brand': build.brand,
        'model': build.model,
      };
    } else if (Platform.isIOS) {
      final build = await deviceInfoPlugin.iosInfo;
      return {
        'id': build.identifierForVendor ?? '',
        'name': build.name,
        'version': build.systemVersion,
        'brand': build.systemName,
        'model': build.model,
      };
    } else {
      return {};
    }
  }

  Future<String> getDeviceToken() async {
    if (WebService.isWeb) {
      return WebFirebaseCore().getToken();
    } else {
      return FlutterUdid.consistentUdid;
    }
  }

  void setStatus(FirebaseCoreStatus status) {
    BlocProvider.of<FirebaseCoreBloc>(
      NavigationService.navigatorKey.currentContext!,
    ).setStatus(status);
  }

  String getCoreStatusAsString(FirebaseCoreStatus status) {
    if (status == FirebaseCoreStatus.stable) {
      return 'stable';
    } else if (status == FirebaseCoreStatus.loading) {
      return 'loading';
    } else {
      return 'error';
    }
  }

  Future<void> setUserRemoveConnectionRequestAndAddPreviousConnectionRequest(
    UserConnectionRequestModel connectionModel, {
    bool isAccepted = true,
  }) async {
    final userBloc = BlocProvider.of<UserBloc>(
      NavigationService.navigatorKey.currentContext!,
    );
    final connectionRequestList = userBloc.getConnectionRequests()
      ..remove(connectionModel);
    final previousConnectionRequestList = [
      ...userBloc.getPreviousConnectionRequests(),
      UserPreviousConnectionRequestModel(
        connectionID: connectionModel.connectionID,
        requestUserDeviceToken: connectionModel.requestUserDeviceToken,
        timestamp: connectionModel.timestamp,
        isAccepted: isAccepted,
      ),
    ];
    final blocPreviousConnectionRequestList = [
      ...userBloc.getPreviousConnectionRequests(),
      UserPreviousConnectionRequestModel(
        username: connectionModel.username,
        profilePhoto: connectionModel.profilePhoto,
        connectionID: connectionModel.connectionID,
        requestUserDeviceToken: connectionModel.requestUserDeviceToken,
        timestamp: connectionModel.timestamp,
        isAccepted: isAccepted,
      ),
    ];

    await BlocProvider.of<UserBloc>(
      NavigationService.navigatorKey.currentContext!,
    ).setFirebaseAndBlocConnectionAndPreviousConnectionRequests(
      connectionRequestList,
      previousConnectionRequestList,
      blocPreviousConnectionRequestList: blocPreviousConnectionRequestList,
    );
  }
}
