import 'package:flutter/material.dart';
import 'package:flutter_fileease/pages/latest_connections.dart';
import 'package:flutter_fileease/services/navigation_service.dart';
import 'package:flutter_fileease/ui/text_styles.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class HomePageDrawer extends StatelessWidget {
  const HomePageDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Padding(
        padding: EdgeInsets.only(top: 15.w),
        child: Column(
          children: [
            drawerButton(
              'Last Connections',
              Icons.cloud_download_outlined,
              () => Navigator.of(NavigationService.navigatorKey.currentContext!)
                  .push(
                MaterialPageRoute<Object>(
                  builder: (context) => const LatestConnections(),
                ),
              ),
            ),
            drawerButton('Settings', Icons.settings_outlined, () {}),
          ],
        ),
      ),
    );
  }

  Widget drawerButton(String name, IconData icon, void Function()? onPressed) =>
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.w),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
          onPressed: onPressed,
          child: SizedBox(
            height: 12.w,
            child: Opacity(
              opacity: 0.8,
              child: Row(
                children: [
                  Icon(
                    icon,
                    size: 30,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    child: Text(
                      '|',
                      style: TextStyles.body.copyWith(fontSize: 18.sp),
                    ),
                  ),
                  Text(
                    name,
                    style: TextStyles.body.copyWith(
                      fontSize: 18.sp,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
}
