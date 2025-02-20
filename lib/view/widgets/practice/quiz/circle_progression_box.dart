import 'package:eng_dict/view/utils/constants.dart';
import 'package:flutter/material.dart';

import '../../../component/animated_progression_indicator.dart';

class CircleProgressionIndicatorBox extends StatelessWidget {
  final int progression;
  final int total;
  final Color indicatorColor;
  final String title;

  const CircleProgressionIndicatorBox({
    required this.title,
    required this.indicatorColor,
    required this.progression,
    required this.total,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedCircularProgress(
          progression: progression,
          total: total,
          progressionIndicatorColor: indicatorColor,
        ),
        const SizedBox(
          height: Constant.kMarginExtraLarge,
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: EdgeInsets.only(right: Constant.kMarginMedium),
              color: indicatorColor,
              width: 20,
              height: 20,
            ),
            Text(
              title,
              style: Constant.kHeadingTextStyle,
            )
          ],
        )
      ],
    );
  }
}
