import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_fileease/core/bloc/send_file/file_model.dart';
import 'package:flutter_fileease/core/user/models/latest_connections_model.dart';
import 'package:flutter_fileease/core/user/models/user_model.dart';
import 'package:flutter_fileease/core/user/user_bloc.dart';
import 'package:flutter_fileease/services/file_service.dart';
import 'package:flutter_fileease/themes/colors.dart';
import 'package:flutter_fileease/ui/text_styles.dart';
import 'package:flutter_fileease/widgets/profile_photo_circle_avatar.dart';
import 'package:flutter_svg/svg.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:share_plus/share_plus.dart';

class LatestConnections extends StatelessWidget {
  const LatestConnections({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      body: BlocBuilder<UserBloc, UserModel>(
        builder: (context, state) {
          return ListView(
            children: [
              for (final connection in state.latestConnections)
                connectionWidget(connection),
            ],
          );
        },
      ),
    );
  }

  Widget connectionWidget(UserLatestConnectionsModel connection) => Padding(
        padding: EdgeInsets.only(top: 4.w),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(left: 8.w),
              child: Row(
                children: [
                  SvgPicture.asset(
                    'assets/icons/border_arrow_icon.svg',
                    height: 6.w,
                    colorFilter: const ColorFilter.mode(
                      UIColors.mainPurple,
                      BlendMode.srcIn,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 3.w),
                    child: ProfilePhotoCircleAvatar(
                      radius: 4.6.w,
                      profilePhoto: connection.senderProfilePhoto!,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 3.w),
                    child: Text(
                      connection.senderUsename ?? 'User',
                      style: TextStyles.boldText.copyWith(fontSize: 18.sp),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 4.w),
                    child: Opacity(
                      opacity: 0.8,
                      child: SvgPicture.asset(
                        'assets/icons/send_arrow_icon.svg',
                        height: 6.w,
                        colorFilter: const ColorFilter.mode(
                          Colors.grey,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 3.w),
                    child: ProfilePhotoCircleAvatar(
                      radius: 4.6.w,
                      profilePhoto: connection.receiverProfilePhoto!,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 3.w),
                    child: Text(
                      connection.receiverUsername ?? 'User',
                      style: TextStyles.boldText.copyWith(fontSize: 18.sp),
                    ),
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.only(left: 8.w, top: 2.5.w, bottom: 2.w),
                child: Text(
                  'Receive',
                  style:
                      TextStyles.w600Text.copyWith(color: UIColors.mainPurple),
                ),
              ),
            ),
            for (final file in connection.filesList) fileWidget(file),
          ],
        ),
      );

  Widget fileWidget(FirebaseFileModel file) => Card(
        margin: EdgeInsets.symmetric(horizontal: 8.w, vertical: 1.w),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 3.5.w),
          child: Row(
            children: [
              Padding(
                padding: EdgeInsets.only(left: 3.w),
                child: SvgPicture.asset(
                  'assets/icons/image_icon.svg',
                  height: 8.w,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 3.w),
                child: Container(
                  height: 9.w,
                  width: 2,
                  color: UIColors.mainGrey,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    file.name,
                    style: TextStyles.w600Text.copyWith(fontSize: 16.6.sp),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 1.w),
                    child: Text(
                      file.size,
                      style: TextStyles.w600Text.copyWith(fontSize: 14.sp),
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Padding(
                padding: EdgeInsets.only(right: 3.w),
                child: IconButton(
                  constraints: const BoxConstraints(),
                  onPressed: () async {
                    final shareFile =
                        await FileService().getDownloadedFile(file.name);
                    final convertedXFile = XFile(shareFile!.path);
                    await Share.shareXFiles([
                      convertedXFile,
                    ]);
                  },
                  icon: const Icon(
                    Icons.share,
                    color: UIColors.mainBlue,
                    size: 30,
                  ),
                ),
              ),
            ],
          ),
        ),
      );

  AppBar get appBar => AppBar(
        title: const Text('Latest Connections'),
      );
}
