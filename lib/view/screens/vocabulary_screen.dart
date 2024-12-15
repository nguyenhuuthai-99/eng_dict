import 'package:eng_dict/view/utils/constants.dart';
import 'package:eng_dict/view/utils/custom_icon.dart';
import 'package:flutter/material.dart';

class VocabularyScreen extends StatelessWidget {
  final String screenId = "VocabularyScreen";
  const VocabularyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Vocabulary"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(
                  CustomIcon.sort,
                  color: Constant.kHyperLinkTextColor,
                  size: 30,
                ),
                Expanded(
                  child: SizedBox(),
                ),
                Text(
                  "Practice",
                  style: TextStyle(
                      fontSize: 20,
                      decoration: TextDecoration.underline,
                      decorationColor: Constant.kHyperLinkTextColor,
                      decorationThickness: 2,
                      color: Constant.kHyperLinkTextColor),
                )
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.only(
                top: Constant.kMarginExtraSmall,
                left: Constant.kMarginExtraSmall,
                right: Constant.kMarginExtraSmall),
            margin: EdgeInsets.only(top: Constant.kMarginMedium),
            decoration: BoxDecoration(
                border:
                    Border(top: BorderSide(color: Constant.kGreyVocabBorder))),
            child: const Column(
              children: [
                Row(
                  children: [
                    Icon(
                      CustomIcon.dot,
                      color: Colors.red,
                    ),
                    Icon(
                      CustomIcon.new_icon,
                      color: Colors.blue,
                    ),
                    Expanded(child: SizedBox()),
                    Icon(
                      CustomIcon.more,
                      color: Constant.kButtonUnselectedColor,
                      size: 30,
                    )
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
