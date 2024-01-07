import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class WebService {
  static bool get isWeb {
    if (kIsWeb) {
      return true;
    } else {
      return false;
    }
  }

  static bool get isMobileMode {
    if (WidgetsBinding
            .instance.platformDispatcher.views.first.physicalSize.height >
        WidgetsBinding
            .instance.platformDispatcher.views.first.physicalSize.width) {
      return true;
    } else if (kIsWeb &&
        (defaultTargetPlatform == TargetPlatform.iOS ||
            defaultTargetPlatform == TargetPlatform.android)) {
      return true;
    } else {
      return false;
    }
  }
}
