import 'package:flutter_fileease/services/web_service.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ResponsiveSizerService {
  static double setWidthForOverflow(double width) {
    double? newWidth;
    if (WebService.isWeb) {
      newWidth = width + 5.w;
    } else {
      newWidth = width;
    }
    return newWidth;
  }
}
