import 'package:eng_dict/model/vocabulary.dart';
import 'package:eng_dict/provider/vocabulary_data.dart';
import 'package:eng_dict/view/utils/constants.dart';
import 'package:eng_dict/view/utils/custom_icon.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class VocabularyBox extends StatelessWidget {
  late List<Vocabulary> vocabularyList;
  VocabularyBox({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    vocabularyList = Provider.of<VocabularyData>(context).vocabularyList;

    return Container(
      padding: const EdgeInsets.only(
          top: Constant.kMarginExtraSmall,
          left: Constant.kMarginExtraSmall,
          right: Constant.kMarginSmall),
      margin: const EdgeInsets.only(top: Constant.kMarginMedium),
      decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: Constant.kGreyVocabBorder))),
      child: Column(
        children: [
          const Row(
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
          ),
          const Padding(
            padding: EdgeInsets.only(
                left: Constant.kMarginLarge, right: Constant.kMarginSmall),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      "Sophisticate",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                    ),
                    Text(
                      " noun",
                      style: TextStyle(
                          color: Constant.kGreyText,
                          fontStyle: FontStyle.italic),
                    )
                  ],
                ),
                Text(
                  "The word or words that a person, thing or place is known by:",
                  style: TextStyle(color: Color(0xb81b1f26), fontSize: 16),
                )
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              print("view more");
            },
            child: const Row(
              children: [
                Expanded(child: SizedBox()),
                Text(
                  "view more",
                  style: TextStyle(
                      fontSize: 15,
                      color: Constant.kGreyText,
                      fontWeight: FontWeight.w100),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 5, left: 2),
                  child: Icon(
                    CustomIcon.arrow,
                    color: Constant.kGreyText,
                    size: 13,
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
