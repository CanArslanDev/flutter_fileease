import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_fileease/themes/themes.dart';

class ThemeCubit extends Cubit<ThemeData> {
  ThemeCubit()
      : super(
          SchedulerBinding.instance.platformDispatcher.platformBrightness ==
                  Brightness.light
              ? Themes.lightTheme
              : Themes.darkTheme,
        );
  bool lightMode = true;
  bool isDarkMode() {
    return !lightMode;
  }

  bool isLightMode() {
    return lightMode;
  }

  void switchTheme(ThemeData theme) {
    if (theme == Themes.lightTheme) {
      lightMode = true;
      emit(Themes.lightTheme);
    } else {
      lightMode = false;
      emit(Themes.darkTheme);
    }
  }

  ThemeData getActiveTheme() {
    return state;
  }
}
