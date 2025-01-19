import 'package:eng_dict/model/vocabulary.dart';
import 'package:eng_dict/provider/screen_data.dart';
import 'package:eng_dict/provider/vocabulary_data.dart';
import 'package:eng_dict/provider/word_field_data.dart';
import 'package:eng_dict/view/dialog/alertDialog.dart';
import 'package:eng_dict/view/utils/constants.dart';
import 'package:eng_dict/view/utils/custom_icon.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class VocabularyBox extends StatelessWidget {
  Vocabulary vocabulary;
  Color dotColor = Constant.kRedDotColor;
  VocabularyBox({
    required this.vocabulary,
    super.key,
  });

  void pickDotColor() {
    if (vocabulary.fluencyLevel == 2) {
      dotColor = Colors.yellow;
    } else if (vocabulary.fluencyLevel == 3) {
      dotColor = Colors.green;
    }
  }

  @override
  Widget build(BuildContext context) {
    pickDotColor();
    return Container(
      padding: const EdgeInsets.only(
          top: Constant.kMarginSmall,
          bottom: Constant.kMarginSmall,
          left: Constant.kMarginExtraSmall,
          right: Constant.kMarginSmall),
      decoration: BoxDecoration(
          color: vocabulary.phraseTitle.isNotEmpty
              ? Constant.kGreyBackground
              : Colors.white,
          border: const Border(top: BorderSide(color: Constant.kGreyDivider))),
      child: Column(
        children: [
          Row(
            children: [
              if (vocabulary.fluencyLevel == 0)
                Icon(
                  CustomIcon.dot,
                  color: dotColor,
                ),
              if (vocabulary.phraseTitle.isNotEmpty)
                const Text(
                  " phrase   ",
                  style: TextStyle(
                      fontStyle: FontStyle.italic, color: Constant.kGreyText),
                ),
              if (Provider.of<VocabularyData>(context, listen: false)
                  .newVocabularyList
                  .contains(vocabulary.id))
                const Icon(
                  CustomIcon.new_icon,
                  color: Colors.blue,
                ),
              const Expanded(child: SizedBox()),
              GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => DeleteWordAlert(vocabulary.id),
                  );
                },
                child: const Icon(
                  Icons.close,
                  color: Constant.kButtonUnselectedColor,
                  size: 20,
                ),
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
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Constant.kPrimaryColor),
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
              Provider.of<WordFieldData>(context, listen: false)
                  .loadWordFromURL(vocabulary.URL);
              print(vocabulary.URL);
              Provider.of<ScreenData>(context, listen: false).changeIndex(1);
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
