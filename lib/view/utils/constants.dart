import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Constant {
  //App Colors
  static const Color kPrimaryColor = Color(0xff3658A3);
  static const Color kSecondaryColor = Color(0xff007AFF);

  //Dark Theme Color
  static const Color kPrimaryDarkColor = Color(0xff34C759);
  static const Color kSecondaryDarkColor = Color(0xff007AFF);
  static const Color kDarkBackgroundColor = Color(0xff007AFF);
  static const Color kDarkSurfaceColor = Color(0xff007AFF);
  static const Color kOnDarkBackgroundColor = Color(0xff007AFF);
  static const Color kOnDarkSurfaceColor = Color(0xff007AFF);

  //Word indicator colors
  static const Color kRedIndicatorColor = Color(0xffFF3B30);
  static const Color kGreenIndicatorColor = Color(0xff34C759);
  static const Color kYellowIndicatorColor = Color(0xffFFCC00);

  //Decorative colors
  static const Color kGreyBackground = Color(0xffF2F2F2);
  static const Color kGreyBorder = Color(0x1F767680);
  static const Color kGreyLine = Color(0xffE2E2E2);
  static const Color kGreyDivider = Color(0xffb1b1b1);
  static const Color kButtonUnselectedColor = Color(0xB81B1F26);
  static const Color kGreyText = Color(0xff888888);
  static const Color kHyperLinkTextColor = Color(0xff007AFF);
  static const Color kLightGreyText = Color(0xb3000000);
  static const Gradient kGradient = LinearGradient(
      transform: GradientRotation(-0.5),
      colors: [Color(0xffF47728), Color(0xffFBA820)]);
  static const Color kBlue = Color(0xff32ADE6);
  static const Color kOrange = Color(0xffFF8040);

  //Text Colors
  static const Color kHeading1Color = Color(0xff414141);
  static const Color kHeading2Color = Color(0xff494949);
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
  static TextStyle kHeadingTextStyle = GoogleFonts.openSans(
    color: kHeading1Color,
    fontSize: 20,
    fontWeight: FontWeight.w600,
  );
  static const TextStyle kHeading2TextStyle = TextStyle(
      color: kHeading2Color, fontSize: 16, fontWeight: FontWeight.bold);
  static const TextStyle kIPATextStyle = TextStyle(
      color: kHeading2Color, fontSize: 16, fontWeight: FontWeight.w100);
  static const TextStyle kUsageAndCodeTextStyle =
      TextStyle(fontWeight: FontWeight.w400, color: kSecondaryColor);
  static var kWordLevelTextStyle = GoogleFonts.inter(
      fontWeight: FontWeight.w700,
      // fontStyle: FontStyle.italic,
      fontSize: 18,
      color: Constant.kPrimaryColor);
  static TextStyle kAdditionalType = GoogleFonts.openSans(
      fontWeight: FontWeight.w700, fontSize: 16, color: kContentTextColor);
  static const kAdditionalTitle = TextStyle(
      fontWeight: FontWeight.w700, fontSize: 15, color: kPrimaryColor);
  static const kAdditionalJustification =
      TextStyle(fontSize: 15, color: kContentTextColor);
  static const kAdditionalUsage = TextStyle(
      fontSize: 15, fontStyle: FontStyle.italic, color: kContentTextColor);
  static const kCodeHeading = TextStyle(
      fontSize: 20, fontWeight: FontWeight.bold, color: kPrimaryColor);
  static const kCodeElement = TextStyle(fontSize: 16, color: Colors.black87);
  static const kCodeTable = TextStyle(
      fontSize: 30, color: kPrimaryColor, fontWeight: FontWeight.bold);
  static const kToolTipTextStyle =
      TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white);
  static const kPhraseSubHeadline =
      TextStyle(color: Constant.kGreyText, fontStyle: FontStyle.italic);
  static const kPhraseTitle =
      TextStyle(color: Color(0xb82a3343), fontWeight: FontWeight.bold);
  static var kSectionTitle = GoogleFonts.openSans(
      color: kHeading1Color, fontWeight: FontWeight.w700, fontSize: 20);
  static const kSectionSubTitle = TextStyle(
    height: 1.1,
    color: kHeading2Color,
    fontSize: 16,
    fontStyle: FontStyle.italic,
  );

  static const kDot = TextSpan(
      text: "• ",
      style: TextStyle(color: Constant.kPrimaryColor, fontSize: 18));
  static const kDotExample = TextSpan(
      text: "• ", style: TextStyle(color: Colors.black87, fontSize: 18));
  static const kDotCustom =
      TextSpan(text: "• ", style: TextStyle(fontSize: 18));

  static const kUpSymbol =
      TextSpan(text: "▲ ", style: TextStyle(color: kGreenIndicatorColor));
  static const kDownSymbol =
      TextSpan(text: "▼ ", style: TextStyle(color: kRedIndicatorColor));
  static const TextSpan kRemainSymbol = TextSpan(
      text: "▬  ",
      style:
          TextStyle(color: kYellowIndicatorColor, fontWeight: FontWeight.w900));

  //Border Radius
  static const Radius kRadiusSmall = Radius.circular(10);
}
