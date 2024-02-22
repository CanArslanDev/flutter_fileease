import 'package:flutter/material.dart';
import 'package:flutter_fileease/core/firebase_core.dart';
import 'package:flutter_fileease/pages/portrait/home_page/home_page.dart'
    as PortraitHomePage;
import 'package:flutter_fileease/pages/landscape/home_page/home_page.dart'
    as LandscapeHomePage;
import 'package:flutter_fileease/services/navigation_service.dart';
import 'package:flutter_fileease/services/web_service.dart';
import 'package:flutter_fileease/themes/colors.dart';
import 'package:flutter_fileease/ui/text_styles.dart';
import 'package:flutter_fileease/web/pages/main_page/main_page_meet_widgets.dart';
import 'package:flutter_fileease/web/responsive/web_responsive_sizer.dart';
import 'package:flutter_fileease/web/widgets/animated_widget.dart';
import 'package:flutter_svg/svg.dart';

class WebMainPage extends StatelessWidget {
  const WebMainPage({super.key});
  @override
  Widget build(BuildContext context) {
    final isMobile = WebService.isMobileMode;
    print('width ${100.ww}');
    print('heigth ${50.wh}');
    print('sp ${50.wsp}');
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
                    width: 100.ww,
                    height: 40.wh,
                  ),
                  AnimatedAlignWidget(
                    index: 1,
                    child: Container(
                      width: 100.ww,
                      decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.all(Radius.elliptical(40.ww, 10.ww)),
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
                          width: 70.ww,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  mainTitle(isMobile: isMobile),
                  mainDesc(isMobile: isMobile),
                  mainButtons(isMobile: isMobile),
                  meetWidget(isMobile: isMobile),
                  timeWidget(isMobile: isMobile),
                  SizedBox(
                    height: 30.wh,
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
        margin: EdgeInsets.symmetric(
            horizontal: 1.ww, vertical: isMobile ? 2.ww : 0),
        width: isMobile ? 95.ww : 46.ww,
        height: isMobile ? 106.ww : 57.wh,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(isMobile ? 30 : 35),
          color: UIColors.darkGrey,
        ),
        child: Padding(
          padding: EdgeInsets.all(isMobile ? 6.ww : 3.ww),
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
                      fontSize: isMobile ? 19.wsp : 14.5.wsp,
                      color: UIColors.whiteColor,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 4.ww),
                    child: SizedBox(
                      width: isMobile ? 90.ww : 44.ww,
                      child: Text(
                        '''Delete hidden launch agents, manage startup and login items to make your Mac run like new.''',
                        style: TextStyles.body
                            .copyWith(color: UIColors.whiteColor)
                            .copyWith(
                              fontSize: isMobile ? 18.wsp : 17.wsp,
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
                    padding: EdgeInsets.only(top: 4.ww),
                    child: Text(
                      '1.5X',
                      style: TextStyles.boldText.copyWith(
                        fontSize: isMobile ? 23.wsp : 20.wsp,
                        color: const Color.fromARGB(255, 244, 0, 244),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 3.wh),
                    child: Text(
                      'Faster boot time',
                      style: TextStyles.body
                          .copyWith(color: UIColors.whiteColor)
                          .copyWith(
                            fontSize: isMobile ? 19.wsp : 14.5.wsp,
                            color: UIColors.whiteColor,
                          ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 3.5.wh),
                    child: Container(
                      height: 2.wh,
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
                    padding: EdgeInsets.only(top: 1.wh),
                    child: Text(
                      'FileEase File Transfer Speed',
                      style: TextStyles.body
                          .copyWith(color: UIColors.whiteColor)
                          .copyWith(
                            fontSize: isMobile ? 16.wsp : 13.wsp,
                            color: UIColors.greyColor,
                          ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 3.5.wh),
                    child: Container(
                      height: 2.wh,
                      width: 23.ww,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: UIColors.greyColor.withOpacity(0.8),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 1.wh),
                    child: Text(
                      'Other Apps File Transfer Speed',
                      style: TextStyles.body
                          .copyWith(color: UIColors.whiteColor)
                          .copyWith(
                            fontSize: isMobile ? 16.wsp : 13.wsp,
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
      padding: EdgeInsets.only(top: 5.wh),
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
      padding: EdgeInsets.only(top: 20.wh),
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
                    .copyWith(fontSize: 20.wsp, color: UIColors.whiteColor),
              ),
              Padding(
                padding: EdgeInsets.only(
                  left: isMobile ? 1.ww : 2.ww,
                  right: isMobile ? 1.ww : 2.ww,
                  top: 3.ww,
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
          padding: EdgeInsets.symmetric(horizontal: 1.ww),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                'assets/icons/check_icon.svg',
                height: isMobile ? 5.wh : 4.wh,
                colorFilter: const ColorFilter.mode(
                  UIColors.greenColor,
                  BlendMode.srcIn,
                ),
              ),
              Text(
                text,
                style: TextStyles.greyText.copyWith(
                  fontSize: isMobile ? 15.wsp : 12.wsp,
                ),
              ),
            ],
          ),
        );

    return Padding(
      padding: EdgeInsets.only(top: isMobile ? 6.ww : 3.2.ww),
      child: AnimatedAlignWidget(
        index: 3,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 2.ww),
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      minimumSize:
                          isMobile ? Size(28.ww, 10.wh) : Size(16.ww, 8.wh),
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
                          padding: EdgeInsets.only(left: 1.ww),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'GET IT ON',
                                style: TextStyles.body
                                    .copyWith(color: UIColors.whiteColor)
                                    .copyWith(
                                      height: 1,
                                      fontSize: isMobile ? 15.wsp : 12.wsp,
                                    ),
                              ),
                              Text(
                                'Play Store',
                                style: TextStyles.boldText.copyWith(
                                  fontSize: 15.wsp,
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
                  padding: EdgeInsets.only(left: isMobile ? 5.ww : 2.ww),
                  child: OutlinedButton(
                    onPressed: () async {
                      await goHomePage(isMobile: isMobile);
                    },
                    style: ButtonStyle(
                      minimumSize: MaterialStatePropertyAll(
                        isMobile ? Size(30.ww, 10.wh) : Size(16.ww, 8.wh),
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
                          height: isMobile ? 9.ww : 3.ww,
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 1.ww),
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
                                      fontSize: isMobile ? 15.wsp : 12.wsp,
                                    ),
                              ),
                              Text(
                                'Web',
                                style: TextStyles.boldText.copyWith(
                                  fontSize: isMobile ? 19.wsp : 15.wsp,
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
              padding: EdgeInsets.only(top: 4.wh),
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
        padding: EdgeInsets.only(top: 15.ww),
        child: Center(
          child: AnimatedAlignWidget(
            index: 1,
            child: Text(
              'FileEase File\nTransfer',
              textAlign: TextAlign.center,
              style: TextStyles.boldText.copyWith(
                color: UIColors.whiteColor,
                fontSize: isMobile ? 26.wsp : null,
              ),
            ),
          ),
        ),
      );

  Widget mainDesc({bool isMobile = false}) => Padding(
        padding: EdgeInsets.only(top: isMobile ? 7.ww : 1.ww),
        child: Center(
          child: AnimatedAlignWidget(
            index: 2,
            child: SizedBox(
              width: isMobile ? 90.ww : 60.ww,
              child: Text(
                '''FileEase is a multi-platform file transfer application designed to send files from any device as quickly as possible.''',
                textAlign: TextAlign.center,
                style: TextStyles.body
                    .copyWith(color: UIColors.whiteColor)
                    .copyWith(
                      color: UIColors.greyColor,
                      fontSize: isMobile ? 18.wsp : 15.wsp,
                    ),
              ),
            ),
          ),
        ),
      );

  AppBar appBar({bool isMobile = false}) => AppBar(
        backgroundColor: UIColors.webBackgroundColor,
        elevation: 0,
        toolbarHeight: 8.2.wh,
        leading: Padding(
          padding: EdgeInsets.only(
            left: isMobile ? 5.ww : 15.ww,
          ),
          child: SizedBox(
            child: Center(
              child: Text(
                'FileEase',
                style: TextStyles.boldText.copyWith(
                  fontSize: isMobile ? 19.wsp : 13.wsp,
                  color: UIColors.whiteColor,
                ),
              ),
            ),
          ),
        ),
        leadingWidth: 40.ww,
        actions: [
          Text(
            'Home',
            style: TextStyles.body.copyWith(color: UIColors.whiteColor),
          ),
          Padding(
            padding: EdgeInsets.only(left: 2.ww),
            child: OutlinedButton(
              onPressed: () async {
                await goHomePage(isMobile: isMobile);
              },
              style: ButtonStyle(
                minimumSize: MaterialStatePropertyAll(
                  isMobile ? Size(1.ww, 5.7.wh) : Size(10.ww, 5.7.wh),
                ),
                padding: isMobile
                    ? MaterialStateProperty.all(
                        EdgeInsets.symmetric(
                          horizontal: 3.ww,
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
            width: isMobile ? 4.ww : 13.ww,
          ),
        ],
      );

  Future<void> goHomePage({bool isMobile = false}) async {
    await FirebaseCore().initialize();
    await Navigator.of(
      NavigationService.navigatorKey.currentContext!,
    ).pushAndRemoveUntil(
      MaterialPageRoute<Object>(
        builder: (context) => isMobile
            ? const PortraitHomePage.HomePage()
            : const LandscapeHomePage.HomePage(),
      ),
      (Route<dynamic> route) => false,
    );
  }
}
