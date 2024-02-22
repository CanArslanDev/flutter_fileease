import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_fileease/core/firebase_core.dart';
import 'package:flutter_fileease/core/user/models/user_model.dart';
import 'package:flutter_fileease/core/user/requests/connection_request_model.dart';
import 'package:flutter_fileease/core/user/requests/previous_connection_request_model.dart';
import 'package:flutter_fileease/core/user/user_bloc.dart';
import 'package:flutter_fileease/themes/colors.dart';
import 'package:flutter_fileease/ui/text_styles.dart';
import 'package:flutter_fileease/widgets/profile_photo_circle_avatar.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ReceiveRequestsPage extends StatelessWidget {
  const ReceiveRequestsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      body: BlocBuilder<UserBloc, UserModel>(
        builder: (context, state) => ListView(
          children: [
            connectionRequests(state.connectionRequests),
            previousRequests(state.previousConnectionRequests),
          ],
        ),
      ),
    );
  }

  Widget previousRequestUser(UserPreviousConnectionRequestModel user) => Card(
        margin: EdgeInsets.only(top: 3.w, right: 6.w, left: 6.w),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Padding(
          padding: EdgeInsets.all(2.5.w),
          child: Row(
            children: [
              Padding(
                padding: EdgeInsets.only(left: 1.w),
                child: ProfilePhotoCircleAvatar(
                  profilePhoto: user.profilePhoto!,
                  radius: 4.6.w,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 2.w),
                child: Text(
                  (user.username == null) ? '' : user.username!,
                  style: TextStyles.boldText.copyWith(fontSize: 18.sp),
                ),
              ),
              const Spacer(),
              Text(
                user.isAccepted ? 'Accepted' : 'Refused',
                style: TextStyles.body.copyWith(
                  fontSize: 16.sp,
                  color: user.isAccepted ? UIColors.mainBlue : UIColors.mainRed,
                ),
              ),
            ],
          ),
        ),
      );

  Widget availableRequestUser(UserConnectionRequestModel user) => Card(
        margin: EdgeInsets.only(top: 3.w, right: 6.w, left: 6.w),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Padding(
          padding: EdgeInsets.all(2.5.w),
          child: Row(
            children: [
              Padding(
                padding: EdgeInsets.only(left: 1.w),
                child: ProfilePhotoCircleAvatar(
                  profilePhoto: user.profilePhoto!,
                  radius: 4.6.w,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 2.w),
                child: Text(
                  user.username!,
                  style: TextStyles.boldText.copyWith(fontSize: 18.sp),
                ),
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: () =>
                    FirebaseCore().refuseUserConnectionRequest(user),
                style: ElevatedButton.styleFrom(
                  backgroundColor: UIColors.mainRed,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: EdgeInsets.zero,
                  minimumSize: Size(8.w, 8.w),
                ),
                child: Padding(
                  padding: EdgeInsets.all(1.w),
                  child: Icon(
                    Icons.close,
                    color: Colors.white,
                    size: 6.w,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () =>
                    FirebaseCore().acceptUserConnectionRequest(user),
                style: ElevatedButton.styleFrom(
                  backgroundColor: UIColors.mainBlue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: EdgeInsets.zero,
                  minimumSize: Size(8.w, 8.w),
                ),
                child: Padding(
                  padding: EdgeInsets.all(1.w),
                  child: Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 6.w,
                  ),
                ),
              ),
            ],
          ),
        ),
      );

  Widget connectionRequests(
    List<UserConnectionRequestModel> connectionRequests,
  ) =>
      Padding(
        padding: EdgeInsets.only(top: 3.w),
        child: Container(
          constraints: BoxConstraints(
            minHeight: 50.w,
          ),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.only(left: 6.w),
                  child: Text(
                    'Connection Requests',
                    style: TextStyles.greyBoldText
                        .copyWith(fontSize: 18.sp, color: Colors.grey.shade600),
                  ),
                ),
              ),
              for (final UserConnectionRequestModel user in connectionRequests)
                availableRequestUser(user),
            ],
          ),
        ),
      );
  Widget previousRequests(
    List<UserPreviousConnectionRequestModel> connectionRequests,
  ) =>
      Padding(
        padding: EdgeInsets.only(top: 3.w),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.only(left: 6.w),
                child: Text(
                  'Latests Requests',
                  style: TextStyles.greyBoldText
                      .copyWith(fontSize: 18.sp, color: Colors.grey.shade600),
                ),
              ),
            ),
            for (final UserPreviousConnectionRequestModel user
                in connectionRequests)
              previousRequestUser(user),
          ],
        ),
      );

  AppBar get appBar => AppBar(
        title: const Text(
          'Receive',
        ),
      );
}
