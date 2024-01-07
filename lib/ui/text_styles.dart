import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class TextStyles {
  static TextStyle boldText = GoogleFonts.inter(
    fontSize: 4.4.w,
    fontWeight: FontWeight.bold,
  );
  static TextStyle w600Text = GoogleFonts.inter(
    fontSize: 4.4.w,
    fontWeight: FontWeight.w600,
  );

  static TextStyle greyText = GoogleFonts.inter(
    fontSize: 4.w,
    fontWeight: FontWeight.w500,
    color: const Color(0xFF9F9F9F),
  );

  static TextStyle greyBoldText = GoogleFonts.inter(
    fontSize: 4.w,
    fontWeight: FontWeight.bold,
    color: const Color(0xFF9F9F9F),
  );

  static TextStyle boldBlueText = GoogleFonts.inter(
    fontSize: 3.6.w,
    fontWeight: FontWeight.bold,
    color: const Color(0xFF7288EA),
  );
  static TextStyle body = GoogleFonts.inter(
    fontSize: 14,
  );
}
