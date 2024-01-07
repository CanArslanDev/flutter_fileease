import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_fileease/bloc/cubit/theme_cubit.dart';
import 'package:flutter_fileease/core/bloc/device_info/device_info_bloc.dart';
import 'package:flutter_fileease/core/bloc/firebase_core/firebase_core_bloc.dart';
import 'package:flutter_fileease/core/bloc/send_file/send_file_bloc.dart';
import 'package:flutter_fileease/core/firebase_core.dart';
import 'package:flutter_fileease/core/user/user_bloc.dart';
import 'package:flutter_fileease/pages/connection_page.dart';
import 'package:flutter_fileease/pages/home_page/home_page.dart';
import 'package:flutter_fileease/pages/qr_pages/qr_scanner_page.dart';
import 'package:flutter_fileease/services/navigation_service.dart';
import 'package:flutter_fileease/services/web_service.dart';
import 'package:flutter_fileease/web/pages/home_page/landscape/landscape_home_page.dart';
import 'package:flutter_fileease/web/pages/home_page/portrait/portrait_home_page.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
        apiKey: "AIzaSyD3Zr7yMGM4FUwZp_5KtbC35w-712DLPZg",
        authDomain: "flutter-fileease.firebaseapp.com",
        projectId: "flutter-fileease",
        storageBucket: "flutter-fileease.appspot.com",
        messagingSenderId: "239466517804",
        appId: "1:239466517804:web:a58d6d36cbca8e8fd04889"),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return ResponsiveSizer(
      builder: (context, orientation, screenType) {
        return MultiBlocProvider(
          providers: [
            BlocProvider(create: (context) => ThemeCubit()),
            BlocProvider<UserBloc>(create: (context) => UserBloc()),
            BlocProvider<DeviceInfoBloc>(create: (context) => DeviceInfoBloc()),
            BlocProvider<FirebaseSendFileBloc>(
              create: (context) => FirebaseSendFileBloc(),
            ),
            BlocProvider<FirebaseCoreBloc>(
              create: (context) => FirebaseCoreBloc(),
            ),
          ],
          child: BlocBuilder<ThemeCubit, ThemeData>(
            builder: (context, state) {
              return MaterialApp(
                title: 'Fast Transfer',
                navigatorKey: NavigationService.navigatorKey,
                debugShowCheckedModeBanner: false,
                theme: state,
                routes: {
                  '/': (context) => initalizeHome,
                  '/connection-page': (context) => const ConnectionPage(),
                  '/qr-scanner-page': (context) => const QRScannerPage(),
                },
              );
            },
          ),
        );
      },
    );
  }

  Widget get initalizeHome {
    Timer(Duration.zero, () {
      unawaited(FirebaseCore().initialize());
    });
    if (WebService.isWeb) {
      if (WebService.isMobileMode) {
        return const WebPortraitHomePage();
      } else {
        return const WebLandscapeHomePage();
      }
    }
    return const HomePage();
  }
}
