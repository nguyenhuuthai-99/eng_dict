import 'package:eng_dict/view/utils/constants.dart';
import 'package:flutter/material.dart';

class HomeScreenSectionBox extends StatelessWidget {
  late String title;
  late String heading;
  late String subHeading;
  HomeScreenSectionBox(
      {super.key,
      required this.title,
      required this.heading,
      required this.subHeading});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Constant.kHeadingTextStyle,
        )
      ],
    );
  }
}
