import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fileease/core/bloc/send_file/enums/download_status_enum.dart';
import 'package:flutter_fileease/themes/colors.dart';
import 'package:flutter_fileease/ui/text_styles.dart';
import 'package:flutter_svg/svg.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:simple_circular_progress_bar/simple_circular_progress_bar.dart';

class FileWidget extends StatefulWidget {
  const FileWidget({
    required this.name,
    required this.size,
    required this.path,
    required this.uploadProgress,
    required this.timestamp,
    required this.downloadStatus,
    super.key,
  });

  final String name;
  final String size;
  final String path;
  final double uploadProgress;
  final Timestamp timestamp;
  final FirebaseFileModelDownloadStatus downloadStatus;
  @override
  State<FileWidget> createState() => _FileWidgetState();
}

class _FileWidgetState extends State<FileWidget> {
  ValueNotifier<double> progressBarValue = ValueNotifier<double>(0);
  ValueNotifier<bool> updateAnimation = ValueNotifier<bool>(true);
  Widget firstWidget = const SizedBox();
  Widget secondWidget = const SizedBox();
  @override
  Widget build(BuildContext context) {
    progressBarValue.value = widget.uploadProgress;
    updateAnimation.value = !updateAnimation.value;
    if (updateAnimation.value == false) {
      firstWidget = getFirstWidget();
    } else {
      secondWidget = getFirstWidget();
    }
    return Card(
      margin: EdgeInsets.only(top: 3.w, right: 5.w, left: 5.w),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding:
            EdgeInsets.only(left: 5.w, right: 5.w, top: 4.6.w, bottom: 4.6.w),
        child: Row(
          children: [
            SvgPicture.asset(
              'assets/icons/image_icon.svg',
              height: 8.w,
            ),
            Padding(
              padding: EdgeInsets.only(left: 5.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 55.w,
                    child: Text(
                      widget.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyles.boldText.copyWith(fontSize: 16.sp),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 1.w),
                    child: SizedBox(
                      width: 55.w,
                      child: Text(
                        widget.size,
                        maxLines: 1,
                        style: TextStyles.greyText.copyWith(fontSize: 14.8.sp),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            Stack(
              children: [
                SizedBox(
                  height: 7.w,
                  width: 7.w,
                ),
                Positioned.fill(
                  child: SimpleCircularProgressBar(
                    size: 6.w,
                    valueNotifier: progressBarValue,
                    progressStrokeWidth: 2,
                    backStrokeWidth: 2,
                    mergeMode: true,
                    progressColors: const [
                      UIColors.mainPurple,
                      UIColors.mainPurple,
                    ],
                    backColor: UIColors.mainGreyTransparent,
                  ),
                ),
                Positioned.fill(
                  child: Center(
                    child: ValueListenableBuilder(
                      valueListenable: updateAnimation,
                      builder: (context, bool value, child) {
                        return AnimatedCrossFade(
                          firstChild: firstWidget,
                          secondChild: secondWidget,
                          crossFadeState: value
                              ? CrossFadeState.showSecond
                              : CrossFadeState.showFirst,
                          alignment: Alignment.center,
                          duration: const Duration(milliseconds: 700),
                        );
                      },
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

  Widget getFirstWidget() {
    if (widget.uploadProgress < 100) {
      return uploadIcon;
    } else if (widget.downloadStatus ==
        FirebaseFileModelDownloadStatus.notDownloaded) {
      return waitingIcon;
    } else if (widget.downloadStatus ==
        FirebaseFileModelDownloadStatus.downloading) {
      return downloadIcon;
    } else if (widget.downloadStatus ==
        FirebaseFileModelDownloadStatus.downloaded) {
      return checkIcon;
    } else {
      return uploadIcon;
    }
  }

  Widget get waitingIcon => Container(
        width: 6.5.w,
        height: 6.5.w,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: UIColors.mainGrey, width: 2),
        ),
        child: Center(
          child: Icon(
            Icons.more_horiz_outlined,
            color: UIColors.mainGrey,
            size: 4.w,
          ),
        ),
      );

  Widget get uploadIcon => SizedBox(
        width: 6.5.w,
        height: 6.5.w,
        child: Center(
          child: Icon(
            Icons.cloud_download_outlined,
            color: Colors.blue,
            size: 4.w,
          ),
        ),
      );

  Widget get errorIcon => Container(
        width: 6.5.w,
        height: 6.5.w,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.red, width: 2),
        ),
        child: Center(
          child: Icon(
            Icons.close,
            color: Colors.red,
            size: 4.w,
          ),
        ),
      );

  Widget get downloadIcon => Container(
        width: 6.5.w,
        height: 6.5.w,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.blue, width: 2),
        ),
        child: Center(
          child: Icon(
            Icons.download,
            color: Colors.blue,
            size: 4.w,
          ),
        ),
      );

  Widget get checkIcon => Container(
        width: 6.5.w,
        height: 6.5.w,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.green, width: 2),
        ),
        child: Center(
          child: Icon(
            Icons.check,
            color: Colors.green,
            size: 4.w,
          ),
        ),
      );
}
