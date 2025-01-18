import 'package:flutter/material.dart';

class Constant {
  //App Colors
  static const Color kPrimaryColor = Color(0xff3658A3);
  static const Color kSecondaryColor = Color(0xff007AFF);
  static const Color kAccentColor = Color(0xffFF3B30);

  //Decorative Colors
  static const Color kRedDotColor = Color(0xffFF3B30);
  static const Color kGreenDotColor = Color(0xff34C759);
  static const Color kYellowDotColor = Color(0xffFFCC00);
  static const Color kGreyBackground = Color(0xffF2F2F2);
  static const Color kGreyBorder = Color(0x1F767680);
  static const Color kGreyLine = Color(0xffE2E2E2);
  static const Color kGreyDivider = Color(0xffb1b1b1);
  static const Color kButtonUnselectedColor = Color(0xB81B1F26);
  static const Color kGreyText = Color(0xff888888);
  static const Color kHyperLinkTextColor = Color(0xff007AFF);
  static const Color kLightGreyText = Color(0x6b000000);
  static const Gradient kGradient = LinearGradient(
      transform: GradientRotation(-0.5),
      colors: [Color(0xffF47728), Color(0xffFBA820)]);

  //Text Colors
  static const Color kHeading1Color = Color(0xcc000000);
  static const Color kHeading2Color = Color(0xb81b1f26);
  static const Color kContentTextColor = Color(0xB8000000);

  //App dimensions
  static const int kIconSize = 35;
  static const int kSearchBarHeight = 50;
  static const double kMarginExtraSmall = 4;
  static const double kMarginSmall = 8;
  static const double kMarginMedium = 12;
  static const double kMarginLarge = 16;
  static const double kMarginExtraLarge = 28;

  //Border Radius
  static const double kBorderRadiusExtraSmall = 4;
  static const double kBorderRadiusSmall = 8;
  static const double kBorderRadiusMedium = 12;
  static const double kBorderRadiusLarge = 16;
  static const double kBorderRadiusExtraLarge = 28;

  //Text Style
  static const TextStyle kBottomNavigationBarTextStyleSelected = TextStyle(
      color: kPrimaryColor, fontSize: 14, fontWeight: FontWeight.w700);
  static const TextStyle kBottomNavigationBarTextStyle = TextStyle(
      color: kButtonUnselectedColor, fontSize: 14, fontWeight: FontWeight.w700);
  static const TextStyle kSearchBarTextStyle = TextStyle(
      color: kGreyText,
      fontSize: 15,
      fontStyle: FontStyle.italic,
      fontFamily: "Inter");
  static const TextStyle kHeadingTextStyle = TextStyle(
      color: kHeading1Color,
      fontSize: 20,
      fontWeight: FontWeight.bold,
      fontFamily: "Inter");
  static const TextStyle kHeading2TextStyle = TextStyle(
      color: kHeading2Color, fontSize: 16, fontWeight: FontWeight.bold);
  static const TextStyle kIPATextStyle = TextStyle(
      color: kHeading2Color, fontSize: 16, fontWeight: FontWeight.w100);
  static const TextStyle kUsageAndCodeTextStyle =
      TextStyle(fontWeight: FontWeight.w100, color: kSecondaryColor);

  //Border Radius
  static const Radius kRadiusSmall = Radius.circular(10);
}
