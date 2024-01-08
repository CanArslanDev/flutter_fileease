import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_fileease/core/bloc/firebase_core/core_model.dart';
import 'package:flutter_fileease/core/bloc/firebase_core/firebase_core_bloc.dart';
import 'package:flutter_fileease/core/bloc/firebase_core/profile_photo_file_model.dart';
import 'package:flutter_fileease/core/bloc/send_file/send_file_bloc.dart';
import 'package:flutter_fileease/core/bloc/send_file/send_file_model.dart';
import 'package:flutter_fileease/core/bloc/status_enum.dart';
import 'package:flutter_fileease/core/user/models/latest_connections_model.dart';
import 'package:flutter_fileease/core/user/models/share_friends_model.dart';
import 'package:flutter_fileease/core/user/models/user_model.dart';
import 'package:flutter_fileease/core/user/user_bloc.dart';
import 'package:flutter_fileease/pages/home_page/home_page_drawer.dart';
import 'package:flutter_fileease/pages/latest_connections.dart';
import 'package:flutter_fileease/pages/manage_storage_page.dart';
import 'package:flutter_fileease/pages/qr_pages/share_qr_page.dart';
import 'package:flutter_fileease/pages/receive_requests_page.dart';
import 'package:flutter_fileease/services/convert_value_service.dart';
import 'package:flutter_fileease/services/navigation_service.dart';
import 'package:flutter_fileease/services/responsive_sizer_service.dart';
import 'package:flutter_fileease/themes/colors.dart';
import 'package:flutter_fileease/ui/animated_text.dart';
import 'package:flutter_fileease/ui/text_styles.dart';
import 'package:flutter_fileease/utils/multi_3_bloc_builder.dart';
import 'package:flutter_fileease/widgets/profile_photo_circle_avatar.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final textFieldController = TextEditingController();
    final key = GlobalKey<ScaffoldState>();
    final sendFileWidget = ValueNotifier<int>(0);
    return Scaffold(
      key: key,
      drawer: const HomePageDrawer(),
      appBar: appBar(() => key.currentState!.openDrawer()),
      body: Multi3BlocBuilder<UserBloc, UserModel, FirebaseCoreBloc,
          FirebaseCoreModel, FirebaseSendFileBloc, FirebaseSendFileModel>(
        builder: (coreContext, userState, coreState, sendState) {
          return Stack(
            children: [
              SizedBox(
                height: 100.h,
                width: 100.w,
                child: ShaderMask(
                  shaderCallback: (rect) {
                    return LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: gradientColors,
                    ).createShader(
                      Rect.fromLTRB(0, 0, rect.width, rect.height),
                    );
                  },
                  blendMode: BlendMode.dstIn,
                  child: ListView(
                    children: [
                      initializingWidget(coreState),
                      cloudStorageWidget(userState, coreState),
                      sendReceiveWidget(() {
                        if (sendFileWidget.value != 2) {
                          if (sendFileWidget.value == 0) {
                            sendFileWidget.value = 1;
                          } else {
                            sendFileWidget.value = 0;
                          }
                        }
                      }),
                      sendWidget(
                        (value) {
                          sendFileWidget.value = value;
                        },
                        sendFileWidget,
                        sendState,
                        textFieldController,
                      ),
                      shareWidget,
                      shareFriendsWidget(userState),
                      latestActiviesWidget(userState),
                    ],
                  ),
                ),
              ),
              Positioned.fill(
                child: scanToConnectWidget,
              ),
            ],
          );
        },
      ),
    );
  }

  Widget initializingWidget(FirebaseCoreModel coreState) {
    return Column(
      children: [
        AnimatedContainer(
          duration: const Duration(seconds: 2),
          curve: Curves.fastLinearToSlowEaseIn,
          height:
              coreState.status == FirebaseCoreStatus.uninitialized ? 7.w : 0,
          width: 100.w,
          color: Colors.blue.withOpacity(0.2),
          child: Center(
            child: Text(
              'Loading App... Please Wait',
              style: TextStyles.w600Text
                  .copyWith(fontSize: 16.sp, color: UIColors.mainPurple),
            ),
          ),
        ),
      ],
    );
  }

  Widget get scanToConnectWidget => Padding(
        padding: EdgeInsets.only(bottom: 5.w),
        child: Align(
          alignment: Alignment.bottomCenter,
          child: ElevatedButton(
            onPressed: () => Navigator.pushNamed(
              NavigationService.navigatorKey.currentContext!,
              '/qr-scanner-page',
            ),
            style: ElevatedButton.styleFrom(
              minimumSize: Size(48.w, 14.w),
              maximumSize:
                  Size(ResponsiveSizerService.setWidthForOverflow(53.w), 50.w),
              backgroundColor: UIColors.mainPurple,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(FontAwesomeIcons.qrcode),
                Padding(
                  padding: EdgeInsets.only(left: 3.w),
                  child: Text(
                    'Scan to Connect',
                    style: TextStyles.boldText.copyWith(fontSize: 3.7.w),
                  ),
                ),
              ],
            ),
          ),
        ),
      );

  List<Color> get gradientColors => [
        for (int i = 0; i < 9; i++) Colors.black,
        Colors.transparent,
      ];

  Widget latestActiviesWidget(UserModel userState) {
    Widget latestActivitiesCard(UserLatestConnectionsModel user) {
      return Card(
        margin: EdgeInsets.only(top: 1.2.w, bottom: 1.2.w),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 3.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 3.w),
                    child: ProfilePhotoCircleAvatar(
                      profilePhoto: user.receiverProfilePhoto ??
                          ProfilePhotoModel(name: '', downloadUrl: ''),
                      radius: 4.6.w,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 3.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 55.w,
                          child: Text(
                            (user.senderID == userState.deviceID)
                                ? 'Send to ${user.receiverUsername}'
                                : 'You received from ${user.receiverUsername}',
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: TextStyles.boldText.copyWith(fontSize: 4.w),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 1.8.w),
                          child: Text(
                            'Archive - ${user.filesCount} files',
                            style: TextStyles.body.copyWith(fontSize: 3.3.w),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(right: 4.w),
                child: GestureDetector(
                  onTap: () => Navigator.of(
                    NavigationService.navigatorKey.currentContext!,
                  ).push(
                    MaterialPageRoute<Object>(
                      builder: (context) => const LatestConnections(),
                    ),
                  ),
                  child: SvgPicture.asset(
                    'assets/icons/send_icon.svg',
                    height: 9.w,
                    colorFilter: const ColorFilter.mode(
                      UIColors.mainPurple,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Padding(
      padding: EdgeInsets.only(left: 5.w, top: 8.w, right: 5.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: 2.5.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Latest Activities',
                  style: TextStyles.boldText,
                ),
                GestureDetector(
                  onTap: () => Navigator.of(
                    NavigationService.navigatorKey.currentContext!,
                  ).push(
                    MaterialPageRoute<Object>(
                      builder: (context) => const LatestConnections(),
                    ),
                  ),
                  child: Text(
                    'See All',
                    style: TextStyles.boldBlueText.copyWith(fontSize: 4.w),
                  ),
                ),
              ],
            ),
          ),
          if (userState.latestConnections.isEmpty)
            Padding(
              padding: EdgeInsets.only(top: 3.w),
              child: Center(
                child: Text(
                  'You have no activity before',
                  style: TextStyles.boldText
                      .copyWith(fontSize: 4.5.w, color: UIColors.mainGrey),
                ),
              ),
            ),
          for (final latestCard in (userState.latestConnections.length > 3)
              ? userState.latestConnections.sublist(0, 3).reversed
              : userState.latestConnections.reversed)
            latestActivitiesCard(latestCard),
        ],
      ),
    );
  }

  Widget sendWidget(
    void Function(int) changeWidgetStatus,
    ValueListenable<int> sendFileWidget,
    FirebaseSendFileModel sendState,
    TextEditingController textFieldController,
  ) {
    Widget buttons() {
      return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 2.w),
            child: ElevatedButton(
              onPressed: () =>
                  Navigator.of(NavigationService.navigatorKey.currentContext!)
                      .push(
                MaterialPageRoute<Object>(
                  builder: (context) => const ShareQRPage(),
                ),
              ),
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                minimumSize: Size(30.w, 8.5.w),
                side: BorderSide(
                  width: 0.5,
                  color: UIColors.mainBlackThemeBackground.withOpacity(0.3),
                ),
              ),
              child: Row(
                children: [
                  SvgPicture.asset(
                    'assets/icons/qr_icon.svg',
                    height: 5.w,
                    colorFilter: const ColorFilter.mode(
                      UIColors.mainPurple,
                      BlendMode.srcIn,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 2.w),
                    child: Text(
                      'Share QR',
                      style: GoogleFonts.inter(
                        fontSize: 4.5.w,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 2.w, left: 2.w),
            child: ElevatedButton(
              onPressed: () async {
                final connectionRequest =
                    await BlocProvider.of<FirebaseSendFileBloc>(
                  NavigationService.navigatorKey.currentContext!,
                ).sendConnectRequest(textFieldController.text);
                if (connectionRequest) {
                  changeWidgetStatus.call(2);
                  Timer(const Duration(milliseconds: 3500), () {
                    changeWidgetStatus.call(0);
                  });
                }
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 2.w),
                backgroundColor: UIColors.mainPurple,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                minimumSize: Size(30.w, 8.5.w),
              ),
              child: Text(
                'Send Request',
                style: GoogleFonts.inter(
                  fontSize: 4.5.w,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      );
    }

    return ValueListenableBuilder(
      valueListenable: sendFileWidget,
      builder: (context, int value, child) => Padding(
        padding: EdgeInsets.symmetric(vertical: 3.7.w),
        child: Card(
          margin: EdgeInsets.symmetric(horizontal: 5.w),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: AnimatedSize(
            duration: const Duration(seconds: 3),
            curve: Curves.fastLinearToSlowEaseIn,
            child: SizedBox(
              height: value == 1 || value == 2
                  ? (sendState.errorMessage != '')
                      ? null
                      : 40.w
                  : 0.w,
              child: Stack(
                children: [
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 3.w, vertical: 2.w),
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Send a File',
                            style:
                                TextStyles.w600Text.copyWith(fontSize: 5.5.w),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 2.w),
                          child: TextField(
                            controller: textFieldController,
                            keyboardType: TextInputType.number,
                            cursorHeight: 20,
                            decoration: InputDecoration(
                              hintText: 'Enter User ID',
                              hintStyle:
                                  TextStyles.greyText.copyWith(fontSize: 3.7.w),
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 10,
                                horizontal: 10,
                              ),
                            ),
                          ),
                        ),
                        if (sendState.errorMessage != '')
                          Padding(
                            padding: EdgeInsets.only(top: 2.w),
                            child: Text(
                              sendState.errorMessage,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyles.boldText.copyWith(
                                fontSize: 15.sp,
                                color: UIColors.mainRed,
                              ),
                            ),
                          ),
                        buttons(),
                      ],
                    ),
                  ),
                  Positioned.fill(
                    child: AnimatedOpacity(
                      opacity: value == 2 ? 1 : 0,
                      duration: const Duration(seconds: 2),
                      curve: Curves.fastLinearToSlowEaseIn,
                      child: IgnorePointer(
                        ignoring: value == 2 || true,
                        child: Card(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                'assets/icons/two_check_icon.svg',
                                height: 8.w,
                                colorFilter: const ColorFilter.mode(
                                  UIColors.mainPurple,
                                  BlendMode.srcIn,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 5.w),
                                child: Container(
                                  height: 15.w,
                                  width: 2,
                                  color: UIColors.mainPurple,
                                ),
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Request Sended',
                                    style: TextStyles.boldText.copyWith(
                                      fontSize: 4.5.w,
                                      color: UIColors.mainPurple,
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(top: 2.w),
                                    child: SizedBox(
                                      width: 40.w,
                                      child: Text(
                                        '''When to other party accepts the requests''',
                                        textAlign: TextAlign.start,
                                        style: TextStyles.boldText.copyWith(
                                          fontSize: 3.5.w,
                                          color: UIColors.mainPurple,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget shareFriendsWidget(UserModel userState) {
    Widget userCard(UserShareFriendsModel user) {
      return Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              ProfilePhotoCircleAvatar(
                radius: 4.w,
                profilePhoto: userState.profilePhoto,
              ),
              Padding(
                padding: EdgeInsets.only(left: 1.w),
                child: Text(
                  user.username,
                  style: TextStyles.boldText.copyWith(fontSize: 3.7.w),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 5.w, top: 5.w),
          child: Text(
            'Share with Friends',
            style: TextStyles.boldText,
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 3.w, left: 3.5.w),
          child: SizedBox(
            height: 14.w,
            child: ListView(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              children: [
                for (final user in userState.shareFriends.reversed)
                  userCard(user),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget get shareWidget => Padding(
        padding: EdgeInsets.only(left: 5.w, right: 5.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ElevatedButton(
              onPressed: () =>
                  Navigator.of(NavigationService.navigatorKey.currentContext!)
                      .push(
                MaterialPageRoute<Object>(
                  builder: (context) => const ShareQRPage(),
                ),
              ),
              child: Row(
                children: [
                  const Icon(FontAwesomeIcons.qrcode),
                  Padding(
                    padding: EdgeInsets.only(left: 3.w),
                    child: Text(
                      'Share QR',
                      style: TextStyles.boldText.copyWith(fontSize: 3.7.w),
                    ),
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () {},
              child: Row(
                children: [
                  const Icon(FontAwesomeIcons.earthAmericas),
                  Padding(
                    padding: EdgeInsets.only(left: 3.w),
                    child: Text(
                      'Web Share',
                      style: TextStyles.boldText.copyWith(fontSize: 3.7.w),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );

  Widget sendReceiveWidget(void Function() pressedSend) => Padding(
        padding: EdgeInsets.only(left: 5.w, right: 5.w, top: 10.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              height: 32.w,
              width: 42.w,
              decoration: BoxDecoration(
                color: UIColors.mainPurple,
                borderRadius: BorderRadius.circular(25),
              ),
              child: Stack(
                children: [
                  Positioned(
                    left: -6.w,
                    top: -6.w,
                    child: SvgPicture.asset(
                      'assets/icons/send_icon.svg',
                      height: 30.w,
                      colorFilter: ColorFilter.mode(
                        Colors.white.withOpacity(0.1),
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                  Positioned.fill(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        SvgPicture.asset(
                          'assets/icons/send_icon.svg',
                          height: 12.w,
                          colorFilter: const ColorFilter.mode(
                            Colors.white,
                            BlendMode.srcIn,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 3.w, bottom: 4.w),
                          child: ElevatedButton(
                            onPressed: () => pressedSend.call(),
                            style: ElevatedButton.styleFrom(
                              minimumSize: Size(35.w, 11.w),
                            ),
                            child: Text(
                              'Send',
                              style: GoogleFonts.inter(
                                fontSize: 4.w,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: 32.w,
              width: 42.w,
              decoration: BoxDecoration(
                color: const Color(0xFF34C1FD),
                borderRadius: BorderRadius.circular(25),
              ),
              child: Stack(
                children: [
                  Positioned(
                    left: -1.w,
                    top: -1.w,
                    child: SvgPicture.asset(
                      'assets/icons/receive_icon.svg',
                      height: 22.w,
                      clipBehavior: Clip.antiAlias,
                      colorFilter: ColorFilter.mode(
                        Colors.white.withOpacity(0.1),
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                  Positioned.fill(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        SvgPicture.asset(
                          'assets/icons/receive_icon.svg',
                          height: 10.w,
                          colorFilter: const ColorFilter.mode(
                            Colors.white,
                            BlendMode.srcIn,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 3.w, bottom: 4.w),
                          child: ElevatedButton(
                            onPressed: () => Navigator.of(
                              NavigationService.navigatorKey.currentContext!,
                            ).push(
                              MaterialPageRoute<Object>(
                                builder: (context) =>
                                    const ReceiveRequestsPage(),
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              minimumSize: Size(35.w, 11.w),
                            ),
                            child: Text(
                              'Receive',
                              style: GoogleFonts.inter(
                                fontSize: 4.w,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );

  Widget cloudStorageWidget(UserModel userState, FirebaseCoreModel coreState) {
    final availableStorage = ConvertValueService().getFileSizeFromKB(
      int.parse(userState.availableCloudStorageKB.round().toString()),
      0,
    );
    final defaultStorage = ConvertValueService().getFileSizeFromKB(
      int.parse(coreState.defaultCloudStorageKB.round().toString()),
      0,
    );
    final storagePercentage = (userState.availableCloudStorageKB * 100) /
        coreState.defaultCloudStorageKB;
    return GestureDetector(
      onTap: () =>
          Navigator.of(NavigationService.navigatorKey.currentContext!).push(
        MaterialPageRoute<Object>(
          builder: (context) => const ManageStoragePage(),
        ),
      ),
      child: Card(
        margin: EdgeInsets.only(
          top: 5.w,
          left: 5.w,
          right: 5.w,
        ),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 5.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularPercentIndicator(
                radius: 43,
                lineWidth: 11.3,
                animation: true,
                percent: storagePercentage / 100,
                backgroundColor: Colors.transparent,
                curve: Curves.fastLinearToSlowEaseIn,
                center: Text(
                  '''${(storagePercentage.toString() == 'NaN') ? 0 : storagePercentage.toStringAsFixed(0)}%''',
                  style: TextStyles.boldText,
                ),
                circularStrokeCap: CircularStrokeCap.round,
                linearGradient: const LinearGradient(
                  colors: [
                    Color(0xFF5B76E6),
                    Color(0xFF34C1FD),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 5.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 47.w,
                      child: Text(
                        (userState.availableCloudStorageKB == 0 ||
                                coreState.defaultCloudStorageKB == 0)
                            ? 'Loading...'
                            : '$availableStorage of $defaultStorage used',
                        style: TextStyles.greyText,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 2.w),
                      child: AnimatedText(
                        text:
                            '''ID: ${ConvertValueService.addSpaceFor6CaracterID(userState.deviceID)}''',
                        notAnimatedText: 'ID: ',
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xFF9000FF),
                            Color(0xFFDA52FF),
                            Color(0xFF9000FF),
                          ],
                        ),
                        style: TextStyles.boldText.copyWith(fontSize: 20.sp),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 3.w),
                      child: Text(
                        'View Details',
                        style: TextStyles.boldBlueText,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  AppBar appBar(void Function() openDrawer) => AppBar(
        title: const Text('Home'),
        leading: IconButton(
          icon: Icon(
            Icons.menu,
            size: 7.w,
          ),
          onPressed: () {
            openDrawer.call();
            // InAppNotifications.receiveTopBar();
            // if (BlocProvider.of<ThemeCubit>(
            //       NavigationService.navigatorKey.currentContext!,
            //     ).isLightMode() ==
            //     true) {
            //   BlocProvider.of<ThemeCubit>(
            //     NavigationService.navigatorKey.currentContext!,
            //   ).switchTheme(Themes.darkTheme);
            // } else {
            //   BlocProvider.of<ThemeCubit>(
            //     NavigationService.navigatorKey.currentContext!,
            //   ).switchTheme(Themes.lightTheme);
            // }
          },
        ),
      );
}
