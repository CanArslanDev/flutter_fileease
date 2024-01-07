import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_fileease/core/base_core/core_system.dart';
import 'package:flutter_fileease/core/firebase_core.dart';
import 'package:flutter_fileease/core/user/user_bloc.dart';
import 'package:flutter_fileease/services/navigation_service.dart';
import 'package:flutter_fileease/services/storage_service.dart';

class FirebaseAuthService {
  Future<bool> createUser() async {
    final deviceToken = await FirebaseCoreSystem().getDeviceToken();
    if (await FirebaseCoreSystem().checkUserFromUsersCollection(deviceToken)) {
      await FirebaseCore().setUserBlocDataUsersCollection(deviceToken);
    } else {
      await FirebaseCore().updateDataUsersCollection(deviceToken);
      await FirebaseCore().setUserBlocDataUsersCollection(deviceToken);
    }
    return true;
  }

  void startListenUser() {
    BlocProvider.of<UserBloc>(
      NavigationService.navigatorKey.currentContext!,
    ).listenUserDataFromFirebase();
  }

  Future<bool> createUserID({String? lastUserID}) async {
    var lastUserIDVoid = lastUserID;
    var foundedUser = false;
    while (foundedUser != true) {
      String randomUserID;
      if (lastUserIDVoid != null) {
        randomUserID = lastUserIDVoid;
      } else {
        randomUserID = FirebaseCoreSystem().createRandomUserID();
      }
      final userExpiration = await FirebaseCoreSystem()
          .getUserExpirationFromIDCollection(randomUserID);
      final networkExpiration = await FirebaseCore().getServerTimestamp();
      final interval = FirebaseCoreSystem()
          .timestampDayCalculation(userExpiration, networkExpiration);
      if (lastUserIDVoid != null) {
        final userToken = await FirebaseCoreSystem()
            .getUserTokenFromUsersCollection(randomUserID);
        final deviceToken = await FirebaseCoreSystem().getDeviceToken();
        if (userToken == deviceToken) {
          await setUser(randomUserID);
          foundedUser = true;
        }
      } else {
        if (interval >= 30) {
          await setUser(randomUserID);
          foundedUser = true;
        }
      }
      if (lastUserIDVoid != null) {
        lastUserIDVoid = null;
      }
    }
    return true;
  }

  Future<void> setUser(String userID) async {
    await StorageService().writeStringStorage('userID', userID);

    BlocProvider.of<UserBloc>(
      NavigationService.navigatorKey.currentContext!,
    ).setID(userID);
    await FirebaseCore().updateDataIDCollection(userID);
  }
}
