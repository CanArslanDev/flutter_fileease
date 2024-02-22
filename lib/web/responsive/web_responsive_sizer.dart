import 'package:responsive_sizer/responsive_sizer.dart';

extension WebResponsiveSize on num {
  static double deviceWidth = (100.w > 1470) ? 1470 : 100.w;
  static double deviceHeigth = (100.h > 755) ? 755 : 100.h;
  static double deviceSp = (100.w > 1470)
      ? 100.w / (1470)
      : (100.h > 755)
          ? 100.h / (755)
          : 1;
  double get ww => this * deviceWidth / 100;
  double get wh => this * deviceHeigth / 100;
  double get wsp => sp / deviceSp;
}
