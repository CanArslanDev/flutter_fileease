import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_fileease/core/bloc/firebase_core/profile_photo_file_model.dart';
import 'package:flutter_fileease/core/firebase_core.dart';
import 'package:flutter_fileease/core/user/models/user_model.dart';
import 'package:flutter_fileease/core/user/user_bloc.dart';
import 'package:flutter_fileease/services/navigation_service.dart';
import 'package:flutter_fileease/themes/colors.dart';
import 'package:flutter_fileease/ui/text_styles.dart';
import 'package:flutter_fileease/widgets/profile_photo_circle_avatar.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ShareQRPage extends StatelessWidget {
  const ShareQRPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      body: BlocBuilder<UserBloc, UserModel>(
        builder: (context, state) {
          return Column(
            children: [
              userAvatar(state.profilePhoto),
              userText(state.username),
              qrCode,
              const Spacer(),
              scanQRWidget,
            ],
          );
        },
      ),
    );
  }

  Widget get scanQRWidget => Padding(
        padding: EdgeInsets.only(bottom: 18.w),
        child: Column(
          children: [
            Text(
              'OR',
              style: TextStyles.greyBoldText.copyWith(
                fontSize: 18.sp,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 2.w),
              child: OutlinedButton(
                onPressed: () => Navigator.pushNamed(
                  NavigationService.navigatorKey.currentContext!,
                  '/qr-scanner-page',
                ),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(
                    color: UIColors.mainPurple,
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 7.w, vertical: 3.w),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(17),
                  ),
                ),
                child: Text(
                  'Scan QR Code',
                  style: TextStyles.boldText
                      .copyWith(color: UIColors.mainPurple, fontSize: 18.sp),
                ),
              ),
            ),
          ],
        ),
      );

  Widget get qrCode {
    // final encodedString = jsonEncode(
    //  await FirebaseCore().getConnectionDataForQRConnectionRequest(),
    // );
    return Padding(
      padding: EdgeInsets.only(top: 14.w),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        padding: EdgeInsets.all(5.w),
        child: FutureBuilder(
          future: FirebaseCore().getConnectionDataForQRConnectionRequest(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return CustomPaint(
                size: Size.square(50.w),
                painter: QrPainter(
                  data: snapshot.data.toString(),
                  version: QrVersions.auto,
                  dataModuleStyle: const QrDataModuleStyle(
                    dataModuleShape: QrDataModuleShape.circle,
                    color: Colors.black,
                  ),
                  embeddedImageStyle: const QrEmbeddedImageStyle(
                    size: Size.square(60),
                  ),
                ),
              );
            } else {
              return const Center(
                child: CircularProgressIndicator.adaptive(
                  backgroundColor: UIColors.mainPurple,
                ),
              );
            }
          },
        ),
      ),
    );
  }

  Widget userText(String username) => Padding(
        padding: EdgeInsets.only(top: 3.w),
        child: Column(
          children: [
            Text(
              username,
              style: TextStyles.boldText.copyWith(fontSize: 19.sp),
            ),
            Padding(
              padding: EdgeInsets.only(top: 4.w),
              child: SizedBox(
                width: 70.w,
                child: Opacity(
                  opacity: 0.7,
                  child: Text(
                    '''You can send a file by sending this QR Code to the other user''',
                    textAlign: TextAlign.center,
                    style: TextStyles.boldText.copyWith(
                      fontSize: 16.sp,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );

  Widget userAvatar(ProfilePhotoModel profilePhoto) => Padding(
        padding: EdgeInsets.only(top: 15.w),
        child: Center(
          child: ProfilePhotoCircleAvatar(
            radius: 9.w,
            profilePhoto: profilePhoto,
          ),
        ),
      );

  AppBar get appBar => AppBar(
        title: Text(
          'Share QR',
          style: TextStyles.boldText
              .copyWith(color: Colors.white, fontSize: 18.sp),
        ),
        backgroundColor: UIColors.mainPurple,
        leading: Padding(
          padding: EdgeInsets.only(left: 4.w),
          child: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            ),
            onPressed: () =>
                Navigator.pop(NavigationService.navigatorKey.currentContext!),
          ),
        ),
      );
}
