import 'package:eng_dict/model/word.dart';
import 'package:eng_dict/model/word_form.dart';
import 'package:eng_dict/provider/word_field_data.dart';
import 'package:eng_dict/view/component/ipa_component.dart';
import 'package:eng_dict/view/utils/constants.dart';
import 'package:eng_dict/view/utils/custom_icon.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../provider/screen_data.dart';

class WordOfTheDayBox extends StatelessWidget {
  final WordForm wordForm;
  late Word word;
  WordOfTheDayBox({super.key, required this.wordForm});

  init() {
    word = wordForm.words![0];
  }

  @override
  Widget build(BuildContext context) {
    init();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Word of the day",
          style: Constant.kHeadingTextStyle,
        ),
        Container(
          padding: const EdgeInsets.symmetric(
              horizontal: Constant.kMarginLarge,
              vertical: Constant.kMarginSmall),
          margin: const EdgeInsets.only(top: Constant.kMarginExtraSmall),
          decoration: BoxDecoration(
              color: Constant.kGreyBackground,
              borderRadius: BorderRadius.circular(Constant.kBorderRadiusSmall)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  word.wordTitle != null
                      ? Text(
                          word.wordTitle!,
                          style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w600,
                              color: Constant.kPrimaryColor),
                        )
                      : const SizedBox(),
                  const SizedBox(
                    width: 5,
                  ),
                  wordForm.formTitle != null
                      ? Text(
                          wordForm.formTitle!,
                          style: const TextStyle(
                              fontStyle: FontStyle.italic,
                              color: Constant.kHeading2Color),
                        )
                      : const SizedBox(),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(
                    top: Constant.kMarginExtraSmall,
                    bottom: Constant.kMarginSmall),
                child: Wrap(
                  spacing: 20, // Space between children
                  runSpacing: 8.0,
                  children: [
                    if (wordForm.usIPASoundURL != null ||
                        wordForm.usIPA != null)
                      IPABox(
                        IPA: wordForm.usIPA != null ? wordForm.usIPA! : "",
                        accent: "US",
                        soundURL: wordForm.usIPASoundURL,
                      ),
                    IPABox(
                      IPA: wordForm.ukIPA != null ? wordForm.ukIPA! : "",
                      accent: "UK",
                      soundURL: wordForm.ukIPASoundURL,
                    ),
                  ],
                ),
              ),
              Text(word.definition,
                  style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w100,
                      color: Constant.kHeading2Color)),
              Padding(
                padding: const EdgeInsets.only(top: Constant.kMarginMedium),
                child: GestureDetector(
                  onTap: () {
                    Provider.of<WordFieldData>(context, listen: false)
                        .loadWordFromURL(
                            word.wordTitle!, wordForm.words![0].url);
                    Provider.of<ScreenData>(context, listen: false)
                        .changeIndex(1);
                  },
                  child: const Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text("view more",
                          style: TextStyle(
                              color: Constant.kLightGreyText, fontSize: 15)),
                      Padding(
                        padding: EdgeInsets.only(top: 2.0, left: 6),
                        child: Icon(
                          CustomIcon.arrow,
                          color: Constant.kLightGreyText,
                          size: 16,
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}
