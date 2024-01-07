import 'dart:async';

import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class AnimatedAlignWidget extends StatelessWidget {
  const AnimatedAlignWidget({required this.child, super.key, this.index});
  final Widget child;
  final int? index;
  @override
  Widget build(BuildContext context) {
    final isAnimated = ValueNotifier<bool>(false);
    final seconds = (index == null) ? 1500 : (index! * 200) + 1500;
    Timer(Duration(milliseconds: seconds), () {
      isAnimated.value = true;
    });
    return ValueListenableBuilder(
      valueListenable: isAnimated,
      builder: (context, bool value, childValue) {
        return AnimatedOpacity(
          duration: const Duration(seconds: 4),
          curve: Curves.fastLinearToSlowEaseIn,
          opacity: value ? 1 : 0,
          child: Column(
            children: [
              AnimatedContainer(
                duration: const Duration(seconds: 4),
                curve: Curves.fastLinearToSlowEaseIn,
                height: value ? 0 : 2.w,
                width: 0,
              ),
              child,
            ],
          ),
        );
      },
    );
  }
}
