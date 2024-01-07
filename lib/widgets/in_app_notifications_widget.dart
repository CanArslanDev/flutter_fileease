import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_fileease/services/navigation_service.dart';
import 'package:flutter_fileease/ui/text_styles.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class InAppNotifications {
  static Widget get _widget => Card(
        elevation: 2,
        margin: EdgeInsets.symmetric(vertical: 9.7.w, horizontal: 2.5.w),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          padding: EdgeInsets.only(top: 3.6.w, left: 3.6.w, right: 3.6.w),
          height: 160,
          width: 600,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'User Name',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 5.w,
                        ),
                      ),
                      const Text('Want to send transfer'),
                    ],
                  ),
                  CircleAvatar(
                    backgroundColor: Colors.blue.shade500,
                    radius: 5.1.w,
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 25, left: 5, right: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.of(
                          NavigationService.navigatorKey.currentContext!,
                        ).pop();
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 8,
                        ),
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.close,
                          color: Colors.white,
                          size: 35,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Row(
                        children: [
                          const Icon(Icons.arrow_forward_outlined),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(
                            'Go to Send Page',
                            style: TextStyles.greyText,
                          ),
                        ],
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.of(
                          NavigationService.navigatorKey.currentContext!,
                        ).pop();
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.lightBlue.shade400,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 35,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Center(
                  child: Container(
                    width: 10.w,
                    height: 0.7.w,
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
  static void receiveTopBar() {
    var isDialogOpen = false;
    showGeneralDialog(
      barrierLabel: 'Label',
      barrierDismissible: true,
      barrierColor: Colors.transparent,
      transitionDuration: const Duration(milliseconds: 700),
      context: NavigationService.navigatorKey.currentContext!,
      pageBuilder: (context, anim1, anim2) {
        return GestureDetector(
          onVerticalDragUpdate: (dragUpdateDetails) {
            Navigator.of(context).pop(true);
          },
          child: Column(
            children: [const SizedBox(height: 20), _widget],
          ),
        );
      },
      transitionBuilder: (context, anim1, anim2, child) {
        return SlideTransition(
          position: anim1.drive(
            Tween(begin: const Offset(0, -2), end: Offset.zero).chain(
              CurveTween(curve: Curves.fastLinearToSlowEaseIn),
            ),
          ),
          child: child,
        );
      },
    ).then((value) {
      isDialogOpen = true;
    });

    Timer(const Duration(seconds: 5), () {
      if (!isDialogOpen) {
        Navigator.of(NavigationService.navigatorKey.currentContext!).pop();
      }
    });
  }
}
