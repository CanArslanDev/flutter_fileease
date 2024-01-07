import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_fileease/core/bloc/firebase_core/profile_photo_file_model.dart';
import 'package:flutter_fileease/core/bloc/send_file/file_model.dart';
import 'package:flutter_fileease/core/bloc/send_file/leave_connection.dart';
import 'package:flutter_fileease/core/bloc/send_file/send_file_bloc.dart';
import 'package:flutter_fileease/core/bloc/send_file/send_file_model.dart';
import 'package:flutter_fileease/core/storage/firebase_storage.dart';
import 'package:flutter_fileease/core/user/user_bloc.dart';
import 'package:flutter_fileease/services/file_picker_service.dart';
import 'package:flutter_fileease/services/navigation_service.dart';
import 'package:flutter_fileease/themes/colors.dart';
import 'package:flutter_fileease/ui/text_styles.dart';
import 'package:flutter_fileease/widgets/file_widget.dart';
import 'package:flutter_fileease/widgets/profile_photo_circle_avatar.dart';
import 'package:flutter_svg/svg.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:simple_circular_progress_bar/simple_circular_progress_bar.dart';

class ConnectionPage extends StatelessWidget {
  const ConnectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    final progressBarValue = ValueNotifier<double>(70);
    final pageFilesList = <FileWidget>[];
    return Scaffold(
      appBar: appBar,
      body: SingleChildScrollView(
        child: BlocBuilder<FirebaseSendFileBloc, FirebaseSendFileModel>(
          builder: (context, state) {
            refreshpageFilesList(
              state.filesList,
              pageFilesList,
              (index, file) {
                pageFilesList[index] = file;
              },
              pageFilesList.add,
            );
            progressBarValue.value = downloadFilesPercentage(
              state.fileNowSpaceAsKB,
              state.fileTotalSpaceAsKB,
            );
            return Column(
              children: [
                sendingFileProgressBar(
                  progressBarValue,
                  state.receiverProfilePhoto!,
                ),
                if (ifEqualSenderIDAndUserID(state.senderID)) selectFileWidget,
                spacesWidget(state),
                fileDetails(pageFilesList.reversed.toList()),
              ],
            );
          },
        ),
      ),
    );
  }

  List<FileWidget> refreshpageFilesList(
    List<FirebaseFileModel> filesList,
    List<FileWidget> widgetFileList,
    void Function(int index, FileWidget file) updateFileWidget,
    void Function(FileWidget file) createFileWidget,
  ) {
    final pageFilesList = widgetFileList;
    for (final file in filesList) {
      final index = pageFilesList.indexWhere(
        (item) =>
            item.path == file.path &&
            item.name == file.name &&
            file.timestamp == item.timestamp,
      );
      if (index != -1) {
        updateFileWidget.call(
          index,
          FileWidget(
            name: file.name,
            size: file.size,
            path: file.path,
            timestamp: file.timestamp,
            uploadProgress: downloadFilesPercentage(
              double.parse(file.bytesTransferred),
              double.parse(file.totalBytes),
            ),
            downloadStatus: file.downloadStatus,
          ),
        );
      } else {
        createFileWidget.call(
          FileWidget(
            name: file.name,
            size: file.size,
            path: file.path,
            timestamp: file.timestamp,
            uploadProgress: downloadFilesPercentage(
              double.parse(file.bytesTransferred),
              double.parse(file.totalBytes),
            ),
            downloadStatus: file.downloadStatus,
          ),
        );
      }
    }
    return pageFilesList;
  }

  String totalFileSize(double fileSizeASKB) {
    if (fileSizeASKB.isNaN || fileSizeASKB.isInfinite || fileSizeASKB == 0) {
      return '0';
    }
    return (fileSizeASKB / 1024).toStringAsFixed(1);
  }

  double downloadFilesPercentage(double nowSpace, double totalSpace) {
    if (nowSpace.isNaN ||
        nowSpace.isInfinite ||
        nowSpace == 0.0 ||
        totalSpace.isNaN ||
        totalSpace.isInfinite ||
        totalSpace == 0.0 ||
        nowSpace > totalSpace) {
      return 0;
    }
    final percentage = nowSpace * 100 / totalSpace;
    return percentage;
  }

  bool ifEqualSenderIDAndUserID(String senderID) =>
      senderID ==
      BlocProvider.of<UserBloc>(
        NavigationService.navigatorKey.currentContext!,
      ).getDeviceID();

  Widget get selectFileWidget {
    const borderRadius = 17.0;
    return Padding(
      padding: EdgeInsets.only(top: 6.w, right: 11.w, left: 11.w),
      child: DottedBorder(
        color: UIColors.mainBlue,
        dashPattern: const [10, 10],
        strokeWidth: 1.5,
        borderType: BorderType.RRect,
        radius: const Radius.circular(borderRadius),
        customPath: (size) {
          return Path()
            ..moveTo(borderRadius, 0)
            ..lineTo(size.width - borderRadius, 0)
            ..arcToPoint(
              Offset(size.width, borderRadius),
              radius: const Radius.circular(borderRadius),
            )
            ..lineTo(size.width, size.height - borderRadius)
            ..arcToPoint(
              Offset(size.width - borderRadius, size.height),
              radius: const Radius.circular(borderRadius),
            )
            ..lineTo(borderRadius, size.height)
            ..arcToPoint(
              Offset(0, size.height - borderRadius),
              radius: const Radius.circular(borderRadius),
            )
            ..lineTo(0, borderRadius)
            ..arcToPoint(
              const Offset(borderRadius, 0),
              radius: const Radius.circular(borderRadius),
            );
        },
        child: ElevatedButton(
          onPressed: () async {
            final fileList = await FilePickerService().pickFiles();
            CoreFirebaseStorage().uploadFilesFromList(fileList);
          },
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius),
            ),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 3.5.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  'assets/icons/select_file_icon.svg',
                  height: 14.w,
                  colorFilter: const ColorFilter.mode(
                    UIColors.mainBlue,
                    BlendMode.srcIn,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5.w),
                  child: Container(
                    color: UIColors.mainBlue,
                    height: 15.w,
                    width: 2,
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Select a File',
                      style: TextStyles.w600Text.copyWith(
                        color: UIColors.mainBlue,
                        fontSize: 18.sp,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 1.w),
                      child: SizedBox(
                        width: 34.w,
                        child: Text(
                          'Select file to send to other user',
                          style: TextStyles.body.copyWith(
                            color: UIColors.mainBlue,
                            fontSize: 15.sp,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget fileDetails(List<FileWidget> fileList) => Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.only(top: 7.w, right: 5.w, left: 5.w),
              child: Text(
                'File Details',
                style: TextStyles.boldText.copyWith(fontSize: 17.sp),
              ),
            ),
          ),
          for (final file in fileList) file,
        ],
      );

  Widget spacesWidget(FirebaseSendFileModel state) => Padding(
        padding: EdgeInsets.only(top: 10.w, right: 10.w, left: 10.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                Text(
                  'Sending',
                  style: TextStyles.greyBoldText,
                ),
                Padding(
                  padding: EdgeInsets.only(top: 3.w),
                  child: Text(
                    '${state.filesCount} files',
                    style: TextStyles.boldText,
                  ),
                ),
              ],
            ),
            Column(
              children: [
                Text(
                  'Size',
                  style: TextStyles.greyBoldText,
                ),
                Padding(
                  padding: EdgeInsets.only(top: 3.w),
                  child: Text(
                    '${totalFileSize(state.fileTotalSpaceAsKB)} MB',
                    style: TextStyles.boldText,
                  ),
                ),
              ],
            ),
            Column(
              children: [
                Text(
                  'Speed',
                  style: TextStyles.greyBoldText,
                ),
                Padding(
                  padding: EdgeInsets.only(top: 3.w),
                  child: Text(
                    state.sendSpeed,
                    style: TextStyles.boldText,
                  ),
                ),
              ],
            ),
          ],
        ),
      );

  Widget sendingFileProgressBar(
    ValueNotifier<double> progressBarValue,
    ProfilePhotoModel userProfilePhoto,
  ) =>
      Stack(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 9.w),
            child: Center(
              child: SimpleCircularProgressBar(
                size: 65.w,
                valueNotifier: progressBarValue,
                progressStrokeWidth: 8,
                backStrokeWidth: 8,
                mergeMode: true,
                progressColors: const [UIColors.mainBlue, UIColors.mainPurple],
                backColor: UIColors.mainGreyTransparent,
              ),
            ),
          ),
          Positioned.fill(
            child: Align(
              alignment: Alignment.topCenter,
              child: Container(
                margin: EdgeInsets.only(top: 4.w),
                width: 10.w,
                height: 10.w,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: UIColors.mainPurple,
                ),
                child: Padding(
                  padding: EdgeInsets.only(left: 1.w, bottom: 1.w),
                  child: Transform.rotate(
                    angle: -0.8,
                    child: const Icon(
                      Icons.send_rounded,
                      size: 25,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: Padding(
              padding: EdgeInsets.only(top: 9.w),
              child: Center(
                child: Stack(
                  children: [
                    SvgPicture.asset(
                      'assets/svg/dash_circle.svg',
                      height: 45.w,
                      colorFilter: ColorFilter.mode(
                        UIColors.mainDarkGreyTransparent,
                        BlendMode.srcIn,
                      ),
                    ),
                    Positioned.fill(
                      child: Align(
                        alignment: Alignment.topCenter,
                        child: Column(
                          children: [
                            Text(
                              'Sending files to',
                              style: TextStyles.greyText.copyWith(
                                fontWeight: FontWeight.w600,
                                fontSize: 15.sp,
                                color: UIColors.mainGrey,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 1.w),
                              child: Text(
                                'User',
                                style: TextStyles.boldText.copyWith(
                                  fontSize: 18.sp,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Positioned.fill(
                      child: Center(
                        child: ProfilePhotoCircleAvatar(
                          radius: 7.w,
                          profilePhoto: userProfilePhoto,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      );

  AppBar get appBar => AppBar(
        title: const Text('Transfer Proccess'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded),
          onPressed: () async {
            await FirebaseSendFileLeaveConnection().leaveConnectionAlertDialog(
              NavigationService.navigatorKey.currentContext!,
            );
          },
        ),
      );
}
