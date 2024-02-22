import 'package:flutter/material.dart';
import 'package:flutter_fileease/ui/text_styles.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ManageStoragePage extends StatelessWidget {
  const ManageStoragePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      body: SafeArea(
        child: ListView(
          children: [
            progressBarWidget,
            spacesWidget,
          ],
        ),
      ),
    );
  }

  Widget get spacesWidget => Padding(
        padding: EdgeInsets.only(top: 10.w, right: 20.w, left: 20.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                Text(
                  'Used Space',
                  style: TextStyles.greyBoldText,
                ),
                Padding(
                  padding: EdgeInsets.only(top: 3.w),
                  child: Text(
                    '4.5 GB',
                    style: TextStyles.boldText,
                  ),
                ),
              ],
            ),
            Column(
              children: [
                Text(
                  'Free Space',
                  style: TextStyles.greyBoldText,
                ),
                Padding(
                  padding: EdgeInsets.only(top: 3.w),
                  child: Text(
                    '500 MB',
                    style: TextStyles.boldText,
                  ),
                ),
              ],
            ),
          ],
        ),
      );

  Widget get progressBarWidget => Padding(
        padding: EdgeInsets.only(top: 9.w),
        child: CircularPercentIndicator(
          radius: 90,
          lineWidth: 25,
          animation: true,
          percent: 0.7,
          backgroundColor: Colors.transparent,
          curve: Curves.fastLinearToSlowEaseIn,
          center:
              Text('80%', style: TextStyles.boldText.copyWith(fontSize: 7.w)),
          circularStrokeCap: CircularStrokeCap.round,
          linearGradient: const LinearGradient(
            colors: [
              Color(0xFF5B76E6),
              Color(0xFF34C1FD),
            ],
          ),
        ),
      );
  AppBar get appBar => AppBar(
        title: const Text('Manage Storage'),
        // actions: [
        //   Padding(
        //     padding: EdgeInsets.only(right: 4.w),
        //     child: Icon(
        //       Icons.search,
        //       size: 9.w,
        //     ),
        //   ),
        // ],
      );
}
