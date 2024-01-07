import 'package:flutter/material.dart';

class NavigationService {
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  static String get getRouteName {
    String? currentPath;
    navigatorKey.currentState?.popUntil((route) {
      currentPath = route.settings.name;
      return true;
    });
    return currentPath ?? '';
  }
}
