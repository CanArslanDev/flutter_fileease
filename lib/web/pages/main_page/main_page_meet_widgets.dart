import 'package:flutter/material.dart';
import 'package:flutter_fileease/themes/colors.dart';
import 'package:flutter_fileease/ui/text_styles.dart';
import 'package:flutter_svg/svg.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class WebMainPageMeetWidgets extends StatelessWidget {
  const WebMainPageMeetWidgets({
    required this.widgetIndex,
    required this.height,
    required this.width,
    super.key,
  });
  final int widgetIndex;
  final double height;
  final double width;
  @override
  Widget build(BuildContext context) {
    if (widgetIndex == 1) {
      return widget1(height, width);
    } else if (widgetIndex == 2) {
      return widget2(height, width);
    } else if (widgetIndex == 3) {
      return widget3(height, width);
    } else if (widgetIndex == 4) {
      return widget4(height, width);
    } else if (widgetIndex == 5) {
      return widget5(height, width);
    } else if (widgetIndex == 6) {
      return widget6(height, width);
    } else if (widgetIndex == 7) {
      return widget7(height, width);
    } else {
      return widget8(height, width);
    }
  }

  static Widget getMeetWidgets({bool isMobile = false}) {
    Widget portrait() {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Column(
                children: [
                  WebMainPageMeetWidgets(
                    height: 43.h,
                    width: 45.w,
                    widgetIndex: 3,
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 2.w),
                    child: WebMainPageMeetWidgets(
                      height: 17.h,
                      width: 45.w,
                      widgetIndex: 4,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 2.w),
                    child: WebMainPageMeetWidgets(
                      height: 17.h,
                      width: 45.w,
                      widgetIndex: 5,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 2.w),
                    child: WebMainPageMeetWidgets(
                      height: 22.h,
                      width: 45.w,
                      widgetIndex: 7,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(
            width: 0.5.w,
          ),
          Padding(
            padding: EdgeInsets.only(left: 2.w),
            child: Column(
              children: [
                WebMainPageMeetWidgets(
                  height: 16.h,
                  width: 45.w,
                  widgetIndex: 1,
                ),
                Padding(
                  padding: EdgeInsets.only(top: 2.w),
                  child: WebMainPageMeetWidgets(
                    height: 16.h,
                    width: 45.w,
                    widgetIndex: 2,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 2.w),
                  child: WebMainPageMeetWidgets(
                    height: 45.h,
                    width: 45.w,
                    widgetIndex: 6,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 2.w),
                  child: WebMainPageMeetWidgets(
                    height: 22.h,
                    width: 45.w,
                    widgetIndex: 8,
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    }

    Widget landscape() {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Column(
                children: [
                  WebMainPageMeetWidgets(
                    height: 31.6.h,
                    width: 22.w,
                    widgetIndex: 1,
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 2.w),
                    child: WebMainPageMeetWidgets(
                      height: 31.6.h,
                      width: 22.w,
                      widgetIndex: 2,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(left: 2.w),
                child: Column(
                  children: [
                    WebMainPageMeetWidgets(
                      height: 44.h,
                      width: 22.w,
                      widgetIndex: 3,
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 2.w),
                      child: WebMainPageMeetWidgets(
                        height: 20.h,
                        width: 22.w,
                        widgetIndex: 4,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(
            width: 2.w,
          ),
          Row(
            children: [
              Column(
                children: [
                  WebMainPageMeetWidgets(
                    height: 20.h,
                    width: 22.w,
                    widgetIndex: 5,
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 2.w),
                    child: WebMainPageMeetWidgets(
                      height: 44.h,
                      width: 22.w,
                      widgetIndex: 6,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(left: 2.w),
                child: Column(
                  children: [
                    WebMainPageMeetWidgets(
                      height: 44.h,
                      width: 22.w,
                      widgetIndex: 7,
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 2.w),
                      child: WebMainPageMeetWidgets(
                        height: 20.h,
                        width: 22.w,
                        widgetIndex: 8,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      );
    }

    return isMobile ? portrait() : landscape();
  }

  Widget widget1(double height, double width) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: const Color(0xFFA56038).withOpacity(0.2),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/android.png',
                width: 10.w,
              ),
              Padding(
                padding: EdgeInsets.only(left: 4.w),
                child: Image.asset(
                  'assets/images/ios_17.png',
                  width: 8.w,
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(top: 2.h),
            child: Text(
              'Fully Compatible',
              style: TextStyles.body
                  .copyWith(color: UIColors.whiteColor)
                  .copyWith(fontSize: 16.sp, color: UIColors.whiteColor),
            ),
          ),
        ],
      ),
    );
  }

  Widget widget2(double height, double width) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: const Color(0xFFA53865).withOpacity(0.2),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '180+',
            style: TextStyles.boldText
                .copyWith(fontSize: 23.sp, color: UIColors.whiteColor),
          ),
          Text(
            'Countries',
            style: TextStyles.body
                .copyWith(color: UIColors.whiteColor)
                .copyWith(fontSize: 18.sp, color: UIColors.whiteColor),
          ),
        ],
      ),
    );
  }

  Widget widget3(double height, double width) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: const Color(0xFF16265C).withOpacity(0.5),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: EdgeInsets.all(6.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Text(
                'Ultra\nSecurity',
                style: TextStyles.boldText.copyWith(
                  fontSize: 22.sp,
                  color: const Color(0xFF207fff),
                  height: 0.9,
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: SvgPicture.asset(
                'assets/icons/security_icon.svg',
                width: 15.w,
                colorFilter: const ColorFilter.mode(
                  UIColors.whiteColor,
                  BlendMode.srcIn,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget widget4(double height, double width) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: const Color(0xFF3F2011).withOpacity(0.5),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '1,000+',
            style: TextStyles.boldText
                .copyWith(fontSize: 21.sp, color: UIColors.whiteColor),
          ),
          Text(
            'Daily File Sharing',
            style: TextStyles.body
                .copyWith(color: UIColors.whiteColor)
                .copyWith(fontSize: 18.sp, color: const Color(0xFFffa16e)),
          ),
        ],
      ),
    );
  }

  Widget widget5(double height, double width) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: const Color(0xFF081F41).withOpacity(0.5),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '10,000+',
            style: TextStyles.boldText
                .copyWith(fontSize: 19.sp, color: UIColors.whiteColor),
          ),
          Text(
            'Daily Usage',
            style: TextStyles.body
                .copyWith(color: UIColors.whiteColor)
                .copyWith(fontSize: 16.sp, color: const Color(0xFF6793e9)),
          ),
        ],
      ),
    );
  }

  Widget widget6(double height, double width) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: const Color(0xFF112A51).withOpacity(0.5),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: EdgeInsets.all(3.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '360+',
                  style: TextStyles.boldText
                      .copyWith(fontSize: 23.sp, color: UIColors.whiteColor),
                ),
                SizedBox(
                  width: 60.w,
                  child: Text(
                    'Media Recommended',
                    style: TextStyles.body
                        .copyWith(color: UIColors.whiteColor)
                        .copyWith(
                          height: 1,
                          fontSize: 18.sp,
                          color: const Color(0xFF6793e9),
                        ),
                  ),
                ),
              ],
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Cult Of',
                    style: TextStyles.body
                        .copyWith(color: UIColors.whiteColor)
                        .copyWith(
                          fontSize: 19.sp,
                          color: Colors.grey,
                          height: 1,
                        ),
                  ),
                  Text(
                    'File Sharing',
                    style: TextStyles.boldText.copyWith(
                      fontSize: 19.sp,
                      color: Colors.grey,
                      height: 1,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget widget7(double height, double width) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: const Color(0xFF0B1956).withOpacity(0.5),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 3.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '4.8',
                  style: TextStyles.boldText.copyWith(
                    height: 0.75,
                    fontSize: 37.sp,
                    color: const Color(0xFFfcdf60),
                  ),
                ),
                Text(
                  '/5',
                  style: TextStyles.body
                      .copyWith(color: UIColors.whiteColor)
                      .copyWith(
                        height: 1,
                        fontSize: 20.sp,
                        color: UIColors.whiteColor,
                      ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(top: 3.w),
              child: Text(
                '100+ REVIEWS',
                style: TextStyles.body
                    .copyWith(color: UIColors.whiteColor)
                    .copyWith(fontSize: 16.sp, color: UIColors.whiteColor),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 0.8.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (int i = 0; i < 5; i++)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 0.6),
                      child: SvgPicture.asset(
                        'assets/icons/star_icon.svg',
                        width: 5.w,
                        colorFilter: const ColorFilter.mode(
                          Color(0xFFffcf31),
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget widget8(double height, double width) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: UIColors.blueColor,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Download',
            style: TextStyles.boldText
                .copyWith(fontSize: 19.sp, color: UIColors.whiteColor),
          ),
          Padding(
            padding: EdgeInsets.only(left: 1.w),
            child: SvgPicture.asset(
              'assets/icons/download_icon.svg',
              width: 5.w,
              colorFilter: const ColorFilter.mode(
                UIColors.whiteColor,
                BlendMode.srcIn,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
