import 'package:flutter/material.dart';
import 'package:flutter_fileease/themes/colors.dart';
import 'package:flutter_fileease/ui/text_styles.dart';
import 'package:flutter_fileease/web/responsive/web_responsive_sizer.dart';
import 'package:flutter_svg/svg.dart';

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
                    height: 43.wh,
                    width: 45.ww,
                    widgetIndex: 3,
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 2.ww),
                    child: WebMainPageMeetWidgets(
                      height: 17.wh,
                      width: 45.ww,
                      widgetIndex: 4,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 2.ww),
                    child: WebMainPageMeetWidgets(
                      height: 17.wh,
                      width: 45.ww,
                      widgetIndex: 5,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 2.ww),
                    child: WebMainPageMeetWidgets(
                      height: 22.wh,
                      width: 45.ww,
                      widgetIndex: 7,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(
            width: 0.5.ww,
          ),
          Padding(
            padding: EdgeInsets.only(left: 2.ww),
            child: Column(
              children: [
                WebMainPageMeetWidgets(
                  height: 16.wh,
                  width: 45.ww,
                  widgetIndex: 1,
                ),
                Padding(
                  padding: EdgeInsets.only(top: 2.ww),
                  child: WebMainPageMeetWidgets(
                    height: 16.wh,
                    width: 45.ww,
                    widgetIndex: 2,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 2.ww),
                  child: WebMainPageMeetWidgets(
                    height: 45.wh,
                    width: 45.ww,
                    widgetIndex: 6,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 2.ww),
                  child: WebMainPageMeetWidgets(
                    height: 22.wh,
                    width: 45.ww,
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
                    height: 31.6.wh,
                    width: 22.ww,
                    widgetIndex: 1,
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 2.ww),
                    child: WebMainPageMeetWidgets(
                      height: 31.6.wh,
                      width: 22.ww,
                      widgetIndex: 2,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(left: 2.ww),
                child: Column(
                  children: [
                    WebMainPageMeetWidgets(
                      height: 44.wh,
                      width: 22.ww,
                      widgetIndex: 3,
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 2.ww),
                      child: WebMainPageMeetWidgets(
                        height: 20.wh,
                        width: 22.ww,
                        widgetIndex: 4,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(
            width: 2.ww,
          ),
          Row(
            children: [
              Column(
                children: [
                  WebMainPageMeetWidgets(
                    height: 20.wh,
                    width: 22.ww,
                    widgetIndex: 5,
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 2.ww),
                    child: WebMainPageMeetWidgets(
                      height: 44.wh,
                      width: 22.ww,
                      widgetIndex: 6,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(left: 2.ww),
                child: Column(
                  children: [
                    WebMainPageMeetWidgets(
                      height: 44.wh,
                      width: 22.ww,
                      widgetIndex: 7,
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 2.ww),
                      child: WebMainPageMeetWidgets(
                        height: 20.wh,
                        width: 22.ww,
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
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 1.ww),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                    child: Image.asset(
                  'assets/images/android.png',
                )),
                Expanded(
                    child: Padding(
                  padding: EdgeInsets.only(left: 4.ww),
                  child: Image.asset(
                    'assets/images/ios_17.png',
                    width: 12.wh,
                  ),
                ))
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 2.wh),
            child: Text(
              'Fully Compatible',
              style: TextStyles.body
                  .copyWith(color: UIColors.whiteColor)
                  .copyWith(fontSize: 16.wsp, color: UIColors.whiteColor),
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
                .copyWith(fontSize: 23.wsp, color: UIColors.whiteColor),
          ),
          Text(
            'Countries',
            style: TextStyles.body
                .copyWith(color: UIColors.whiteColor)
                .copyWith(fontSize: 18.wsp, color: UIColors.whiteColor),
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
        padding: EdgeInsets.all(3.ww),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Text(
                'Ultra\nSecurity',
                style: TextStyles.boldText.copyWith(
                  fontSize: 22.wsp,
                  color: const Color(0xFF207fff),
                  height: 0.9,
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: SvgPicture.asset(
                'assets/icons/security_icon.svg',
                width: 15.wh,
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
                .copyWith(fontSize: 21.wsp, color: UIColors.whiteColor),
          ),
          Text(
            'Daily File Sharing',
            style: TextStyles.body
                .copyWith(color: UIColors.whiteColor)
                .copyWith(fontSize: 18.wsp, color: const Color(0xFFffa16e)),
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
                .copyWith(fontSize: 19.wsp, color: UIColors.whiteColor),
          ),
          Text(
            'Daily Usage',
            style: TextStyles.body
                .copyWith(color: UIColors.whiteColor)
                .copyWith(fontSize: 16.wsp, color: const Color(0xFF6793e9)),
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
        padding: EdgeInsets.all(3.ww),
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
                      .copyWith(fontSize: 23.wsp, color: UIColors.whiteColor),
                ),
                SizedBox(
                  width: 60.ww,
                  child: Text(
                    'Media Recommended',
                    style: TextStyles.body
                        .copyWith(color: UIColors.whiteColor)
                        .copyWith(
                          height: 1,
                          fontSize: 16.wsp,
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
                          fontSize: 19.wsp,
                          color: Colors.grey,
                          height: 1,
                        ),
                  ),
                  Text(
                    'File Sharing',
                    style: TextStyles.boldText.copyWith(
                      fontSize: 19.wsp,
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
        padding: EdgeInsets.symmetric(vertical: 3.wh),
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
                    fontSize: 37.wsp,
                    color: const Color(0xFFfcdf60),
                  ),
                ),
                Text(
                  '/5',
                  style: TextStyles.body
                      .copyWith(color: UIColors.whiteColor)
                      .copyWith(
                        height: 1,
                        fontSize: 20.wsp,
                        color: UIColors.whiteColor,
                      ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(top: 3.ww),
              child: Text(
                '100+ REVIEWS',
                style: TextStyles.body
                    .copyWith(color: UIColors.whiteColor)
                    .copyWith(fontSize: 16.wsp, color: UIColors.whiteColor),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 0.8.ww),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (int i = 0; i < 5; i++)
                    Expanded(
                        child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 0.6),
                      child: SvgPicture.asset(
                        'assets/icons/star_icon.svg',
                        width: 5.ww,
                        colorFilter: const ColorFilter.mode(
                          Color(0xFFffcf31),
                          BlendMode.srcIn,
                        ),
                      ),
                    )),
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
                .copyWith(fontSize: 19.wsp, color: UIColors.whiteColor),
          ),
          Padding(
            padding: EdgeInsets.only(left: 1.ww),
            child: SvgPicture.asset(
              'assets/icons/download_icon.svg',
              width: 5.ww,
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
