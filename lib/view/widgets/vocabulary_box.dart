import 'package:eng_dict/model/vocabulary.dart';
import 'package:eng_dict/provider/vocabulary_data.dart';
import 'package:eng_dict/view/utils/constants.dart';
import 'package:eng_dict/view/utils/custom_icon.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class VocabularyBox extends StatelessWidget {
  Vocabulary vocabulary;
  VocabularyBox({
    required this.vocabulary,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
          top: Constant.kMarginExtraSmall,
          left: Constant.kMarginExtraSmall,
          right: Constant.kMarginSmall),
      margin: const EdgeInsets.only(top: Constant.kMarginMedium),
      decoration: BoxDecoration(
          color: vocabulary.phraseTitle.isNotEmpty
              ? Constant.kGreyBackground
              : Colors.white,
          border:
              const Border(top: BorderSide(color: Constant.kGreyVocabBorder))),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(
                CustomIcon.dot,
                color: Colors.red,
              ),
              const Icon(
                CustomIcon.new_icon,
                color: Colors.blue,
              ),
              if (vocabulary.phraseTitle.isNotEmpty)
                const Text(
                  "     phrase",
                  style: TextStyle(
                      fontStyle: FontStyle.italic, color: Constant.kGreyText),
                ),
              const Expanded(child: SizedBox()),
              const Icon(
                CustomIcon.more,
                color: Constant.kButtonUnselectedColor,
                size: 30,
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(
                left: Constant.kMarginLarge, right: Constant.kMarginSmall),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (vocabulary.wordTitle.isNotEmpty)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        vocabulary.wordTitle,
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w600),
                      ),
                      Text(
                        " ${vocabulary.wordForm}",
                        style: const TextStyle(
                            color: Constant.kGreyText,
                            fontStyle: FontStyle.italic),
                      )
                    ],
                  ),
                if (vocabulary.phraseTitle.isNotEmpty)
                  Text(
                    vocabulary.phraseTitle,
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                Text(
                  vocabulary.wordDefinition,
                  style:
                      const TextStyle(color: Color(0xb81b1f26), fontSize: 16),
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
