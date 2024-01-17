import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_fileease/core/user/models/user_model.dart';
import 'package:flutter_fileease/core/user/user_bloc.dart';
import 'package:flutter_fileease/pages/latest_connections.dart';
import 'package:flutter_fileease/services/navigation_service.dart';
import 'package:flutter_fileease/themes/colors.dart';
import 'package:flutter_fileease/ui/text_styles.dart';
import 'package:flutter_fileease/widgets/profile_photo_circle_avatar.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class HomePageDrawer extends StatelessWidget {
  const HomePageDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 75.w,
      child: Padding(
        padding: EdgeInsets.only(top: 15.w),
        child: Column(
          children: [
            profileBanner,
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

  Widget get profileBanner {
    return BlocBuilder<UserBloc, UserModel>(
      builder: (context, state) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.w),
          child: Padding(
            padding: EdgeInsets.only(left: 2.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    ProfilePhotoCircleAvatar(
                      radius: 4.5.w,
                      profilePhoto: state.profilePhoto,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 2.w),
                      child: Text(
                        state.username,
                        style: TextStyles.boldText.copyWith(fontSize: 19.sp),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(top: 1.h),
                  child: Card(
                    color: UIColors.lightGrey,
                    child: SizedBox(
                      height: 3,
                      width: 50.w,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget drawerButton(String name, IconData icon, void Function()? onPressed) =>
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.w),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: UIColors.lightGrey,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
          onPressed: onPressed,
          child: SizedBox(
            height: 12.w,
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
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
}
