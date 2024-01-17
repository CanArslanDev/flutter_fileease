import 'package:flutter/material.dart';
import 'package:flutter_fileease/core/firebase_core.dart';
import 'package:flutter_fileease/pages/home_page/home_page.dart';
import 'package:flutter_fileease/services/navigation_service.dart';
import 'package:flutter_fileease/services/web_service.dart';
import 'package:flutter_fileease/themes/colors.dart';
import 'package:flutter_fileease/ui/text_styles.dart';
import 'package:flutter_fileease/web/pages/main_page/main_page_meet_widgets.dart';
import 'package:flutter_fileease/web/widgets/animated_widget.dart';
import 'package:flutter_svg/svg.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class WebMainPage extends StatelessWidget {
  const WebMainPage({super.key});
  @override
  Widget build(BuildContext context) {
    final isMobile = WebService.isMobileMode;
    return Scaffold(
      backgroundColor: UIColors.webBackgroundColor,
      appBar: appBar(isMobile: isMobile),
      body: ListView(
        children: [
          Stack(
            children: [
              Column(
                children: [
                  SizedBox(
                    width: 100.w,
                    height: 40.h,
                  ),
                  AnimatedAlignWidget(
                    index: 1,
                    child: Container(
                      width: 100.w,
                      decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.all(Radius.elliptical(40.w, 10.w)),
                      ),
                      child: ShaderMask(
                        shaderCallback: (rect) {
                          return LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              UIColors.webBackgroundColor,
                              UIColors.webBackgroundColor.withOpacity(0.5),
                              UIColors.webBackgroundColor.withOpacity(0.2),
                              UIColors.webBackgroundColor.withOpacity(0.1),
                              UIColors.webBackgroundColor.withOpacity(0.05),
                              UIColors.webBackgroundColor.withOpacity(0.025),
                            ],
                          ).createShader(
                            Rect.fromLTRB(0, 0, rect.width, rect.height),
                          );
                        },
                        blendMode: BlendMode.dstIn,
                        child: Image.asset(
                          'assets/images/background_phone.png',
                          fit: BoxFit.cover,
                          width: 70.w,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  mainTitle(isMobile: true),
                  mainDesc(isMobile: true),
                  mainButtons(isMobile: true),
                  meetWidget(isMobile: true),
                  timeWidget(isMobile: true),
                  SizedBox(
                    height: 30.h,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget timeWidget({bool isMobile = false}) {
    Widget timeCard() {
      return Container(
        margin:
            EdgeInsets.symmetric(horizontal: 1.w, vertical: isMobile ? 2.w : 0),
        width: isMobile ? 95.w : 46.w,
        height: isMobile ? 106.w : 57.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(isMobile ? 30 : 35),
          color: UIColors.darkGrey,
        ),
        child: Padding(
          padding: EdgeInsets.all(isMobile ? 6.w : 3.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Responding Time',
                    style: TextStyles.boldText.copyWith(
                      fontSize: isMobile ? 19.sp : 14.5.sp,
                      color: UIColors.whiteColor,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 4.w),
                    child: SizedBox(
                      width: isMobile ? 90.w : 44.w,
                      child: Text(
                        '''Delete hidden launch agents, manage startup and login items to make your Mac run like new.''',
                        style: TextStyles.body
                            .copyWith(color: UIColors.whiteColor)
                            .copyWith(
                              fontSize: isMobile ? 18.sp : 17.sp,
                              color: UIColors.whiteColor,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 4.w),
                    child: Text(
                      '1.5X',
                      style: TextStyles.boldText.copyWith(
                        fontSize: isMobile ? 23.sp : 20.sp,
                        color: const Color.fromARGB(255, 244, 0, 244),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 3.h),
                    child: Text(
                      'Faster boot time',
                      style: TextStyles.body
                          .copyWith(color: UIColors.whiteColor)
                          .copyWith(
                            fontSize: isMobile ? 19.sp : 14.5.sp,
                            color: UIColors.whiteColor,
                          ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 3.5.h),
                    child: Container(
                      height: 2.h,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xFFffc109),
                            Color(0xFFe54f34),
                            Color(0xFFc43665),
                            Color(0xFFa4258e),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 1.h),
                    child: Text(
                      'FileEase File Transfer Speed',
                      style: TextStyles.body
                          .copyWith(color: UIColors.whiteColor)
                          .copyWith(
                            fontSize: isMobile ? 16.sp : 13.sp,
                            color: UIColors.greyColor,
                          ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 3.5.h),
                    child: Container(
                      height: 2.h,
                      width: 23.w,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: UIColors.greyColor.withOpacity(0.8),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 1.h),
                    child: Text(
                      'Other Apps File Transfer Speed',
                      style: TextStyles.body
                          .copyWith(color: UIColors.whiteColor)
                          .copyWith(
                            fontSize: isMobile ? 16.sp : 13.sp,
                            color: UIColors.greyColor,
                          ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    }

    return Padding(
      padding: EdgeInsets.only(top: 5.h),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          timeCard(),
          timeCard(),
        ],
      ),
    );
  }

  Widget meetWidget({bool isMobile = false}) {
    return Padding(
      padding: EdgeInsets.only(top: 20.h),
      child: AnimatedAlignWidget(
        index: 4,
        child: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: UIColors.webBackgroundColor.withOpacity(0.9),
                blurRadius: 2000,
              ),
              BoxShadow(
                color: UIColors.blueColor.withOpacity(0.1),
                spreadRadius: -200,
                blurRadius: 100,
              ),
            ],
          ),
          child: Column(
            children: [
              Text(
                'Meet with FileEase',
                style: TextStyles.boldText
                    .copyWith(fontSize: 20.sp, color: UIColors.whiteColor),
              ),
              Padding(
                padding: EdgeInsets.only(
                  left: isMobile ? 1.w : 2.w,
                  right: isMobile ? 1.w : 2.w,
                  top: 3.w,
                ),
                child: WebMainPageMeetWidgets.getMeetWidgets(
                  isMobile: isMobile,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget mainButtons({bool isMobile = false}) {
    Widget rowCheckText(String text) => Padding(
          padding: EdgeInsets.symmetric(horizontal: 1.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                'assets/icons/check_icon.svg',
                height: isMobile ? 5.h : 4.h,
                colorFilter: const ColorFilter.mode(
                  UIColors.greenColor,
                  BlendMode.srcIn,
                ),
              ),
              Text(
                text,
                style: TextStyles.greyText.copyWith(
                  fontSize: isMobile ? 15.sp : 12.sp,
                ),
              ),
            ],
          ),
        );

    return Padding(
      padding: EdgeInsets.only(top: isMobile ? 6.w : 3.2.w),
      child: AnimatedAlignWidget(
        index: 3,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 2.w),
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      minimumSize:
                          isMobile ? Size(28.w, 10.h) : Size(16.w, 8.h),
                      backgroundColor: UIColors.darkBlue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: Row(
                      children: [
                        SvgPicture.asset(
                          'assets/icons/play_store_icon.svg',
                          colorFilter: const ColorFilter.mode(
                            UIColors.whiteColor,
                            BlendMode.srcIn,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 1.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'GET IT ON',
                                style: TextStyles.body
                                    .copyWith(color: UIColors.whiteColor)
                                    .copyWith(
                                      height: 1,
                                      fontSize: isMobile ? 15.sp : 12.sp,
                                    ),
                              ),
                              Text(
                                'Play Store',
                                style: TextStyles.boldText.copyWith(
                                  fontSize: 19.sp,
                                  height: 1,
                                  color: UIColors.whiteColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: isMobile ? 5.w : 2.w),
                  child: OutlinedButton(
                    onPressed: () async {
                      await FirebaseCore().initialize();
                      await Navigator.of(
                        NavigationService.navigatorKey.currentContext!,
                      ).pushAndRemoveUntil(
                        MaterialPageRoute<Object>(
                          builder: (context) => const HomePage(),
                        ),
                        (Route<dynamic> route) => false,
                      );
                    },
                    style: ButtonStyle(
                      minimumSize: MaterialStatePropertyAll(
                        isMobile ? Size(30.w, 10.h) : Size(16.w, 8.h),
                      ),
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      side: MaterialStateProperty.all(
                        const BorderSide(color: Colors.white30),
                      ),
                    ),
                    child: Row(
                      children: [
                        SvgPicture.asset(
                          'assets/icons/web_icon.svg',
                          colorFilter: const ColorFilter.mode(
                            UIColors.whiteColor,
                            BlendMode.srcIn,
                          ),
                          height: isMobile ? 9.w : 3.w,
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 1.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Try on',
                                style: TextStyles.body
                                    .copyWith(color: UIColors.whiteColor)
                                    .copyWith(
                                      height: 1,
                                      color: UIColors.whiteColor,
                                      fontSize: isMobile ? 15.sp : 12.sp,
                                    ),
                              ),
                              Text(
                                'Web',
                                style: TextStyles.boldText.copyWith(
                                  fontSize: isMobile ? 19.sp : 15.sp,
                                  height: 1,
                                  color: UIColors.whiteColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(top: 4.h),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  rowCheckText('Full Optimized in All Platforms'),
                  rowCheckText('1.5X Faster Other File Transfer Programs'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget mainTitle({bool isMobile = false}) => Padding(
        padding: EdgeInsets.only(top: 15.w),
        child: Center(
          child: AnimatedAlignWidget(
            index: 1,
            child: Text(
              'FileEase File\nTransfer',
              textAlign: TextAlign.center,
              style: TextStyles.boldText.copyWith(
                color: UIColors.whiteColor,
                fontSize: isMobile ? 26.sp : null,
              ),
            ),
          ),
        ),
      );

  Widget mainDesc({bool isMobile = false}) => Padding(
        padding: EdgeInsets.only(top: isMobile ? 7.w : 1.w),
        child: Center(
          child: AnimatedAlignWidget(
            index: 2,
            child: SizedBox(
              width: isMobile ? 90.w : 60.w,
              child: Text(
                '''FileEase is a multi-platform file transfer application designed to send files from any device as quickly as possible.''',
                textAlign: TextAlign.center,
                style: TextStyles.body
                    .copyWith(color: UIColors.whiteColor)
                    .copyWith(
                      color: UIColors.greyColor,
                      fontSize: isMobile ? 18.sp : 15.sp,
                    ),
              ),
            ),
          ),
        ),
      );

  AppBar appBar({bool isMobile = false}) => AppBar(
        backgroundColor: UIColors.webBackgroundColor,
        elevation: 0,
        toolbarHeight: 8.2.h,
        leading: Padding(
          padding: EdgeInsets.only(
            left: isMobile ? 5.w : 15.w,
          ),
          child: SizedBox(
            child: Center(
              child: Text(
                'FileEase',
                style: TextStyles.boldText.copyWith(
                  fontSize: isMobile ? 19.sp : 13.sp,
                  color: UIColors.whiteColor,
                ),
              ),
            ),
          ),
        ),
        leadingWidth: 40.w,
        actions: [
          Text(
            'Home',
            style: TextStyles.body.copyWith(color: UIColors.whiteColor),
          ),
          Padding(
            padding: EdgeInsets.only(left: 2.w),
            child: OutlinedButton(
              onPressed: () {},
              style: ButtonStyle(
                minimumSize: MaterialStatePropertyAll(
                  isMobile ? Size(1.w, 5.7.h) : Size(10.w, 5.7.h),
                ),
                padding: isMobile
                    ? MaterialStateProperty.all(
                        EdgeInsets.symmetric(
                          horizontal: 3.w,
                        ),
                      )
                    : null,
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                side: MaterialStateProperty.all(
                  const BorderSide(width: 0.5, color: Colors.white54),
                ),
              ),
              child: Text(
                'Try in Web',
                maxLines: 1,
                style: TextStyles.body
                    .copyWith(color: UIColors.whiteColor)
                    .copyWith(color: UIColors.whiteColor),
              ),
            ),
          ),
          SizedBox(
            width: isMobile ? 4.w : 13.w,
          ),
        ],
      );
}
