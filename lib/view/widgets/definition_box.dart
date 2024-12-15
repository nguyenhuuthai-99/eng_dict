import 'dart:ffi';

import 'package:eng_dict/model/word.dart';
import 'package:eng_dict/view/utils/constants.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class DefinitionBox extends StatelessWidget {
  Word word;
  DefinitionBox({
    required this.word,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    if (word.isPhrase) {
      return buildPhraseBox();
    }
    return buildWordBox();
  }

  Widget buildWordBox() {
    return Padding(
      padding: const EdgeInsets.symmetric(
          vertical: Constant.kMarginMedium, horizontal: Constant.kMarginMedium),
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.only(right: Constant.kMarginSmall),
            child: Row(
              children: [
                Expanded(
                    child: Text(
                  "B1",
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                      color: Constant.kPrimaryColor,
                      fontFamily: "Inter"),
                )),
                Icon(
                  Icons.bookmark_outline,
                  size: 30,
                  color: Colors.redAccent,
                )
              ],
            ),
          ),
          buildDefinitionText(
              "The word or words that a person, thing, or place is known by:"),
          Padding(
            padding: const EdgeInsets.only(
                left: Constant.kMarginMedium, top: Constant.kMarginExtraSmall),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildExample(
                    "•  Please write your full (= complete) name and address on the form."),
                buildExample(
                    "•  Please write your full (= complete) name and address on the form."),
                buildExample(
                    "•  Please write your full (= complete) name and address on the form."),
                buildExample(
                    "•  Please write your full (= complete) name and address on the form."),
                buildExample(
                    "•  Please write your full (= complete) name and address on the form."),
                buildExample(
                    "•  Please write your full (= complete) name/and/address on the form."),
                buildExample(
                    "•  Please write your full (= complete) name and address on the form."),
                buildExample(
                    "•  Please write your full (= complete) name and address on the form."),
              ],
            ),
          ),
          SizedBox(
            height: 1,
            width: double.infinity,
            child: Container(
              color: Constant.kGreyLine,
            ),
          )
        ],
      ),
    );
  }

  Widget buildPhraseBox() {
    return Column(
      children: [
        Row(
          children: [
            Text(
              "phrase with ",
              style: TextStyle(color: Constant.kGreyText),
            ),
            Text(
              "Name",
              style: TextStyle(color: Colors.black),
            )
          ],
        ),
        Container(
          color: Constant.kGreyBackground,
          child: Column(
            children: [
              buildDefinitionText(
                  "The word or words that a person, thing, or place is known by:"),
              Padding(
                padding: const EdgeInsets.only(
                    left: Constant.kMarginMedium,
                    top: Constant.kMarginExtraSmall),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildExample(
                        "•  Please write your full (= complete) name and address on the form."),
                    buildExample(
                        "•  Please write your full (= complete) name and address on the form."),
                    buildExample(
                        "•  Please write your full (= complete) name and address on the form."),
                    buildExample(
                        "•  Please write your full (= complete) name and address on the form."),
                    buildExample(
                        "•  Please write your full (= complete) name and address on the form."),
                    buildExample(
                        "•  Please write your full (= complete) name/and/address on the form."),
                    buildExample(
                        "•  Please write your full (= complete) name and address on the form."),
                    buildExample(
                        "•  Please write your full (= complete) name and address on the form."),
                  ],
                ),
              ),
              const Divider(
                color: Constant.kGreyLine,
                height: 30,
                thickness: 0.8,
              )
            ],
          ),
        ),
      ],
    );
  }

  RichText buildDefinitionText(String text) {
    return RichText(
        text: TextSpan(
            style: const TextStyle(
                fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black),
            children: buildClickableTextSpan(text: text)));
  }

  RichText buildExample(String text) {
    return RichText(
        text: TextSpan(
            style: const TextStyle(
                fontSize: 15,
                letterSpacing: 0.1,
                height: 1.5,
                color: Colors.black87),
            children: buildClickableTextSpan(text: text)));
  }

  List<TextSpan> buildClickableTextSpan({required String text}) {
    List<int> textCodes = text.codeUnits;
    List<TextSpan> words = [];
    String curString = '';
    for (int char in textCodes) {
      if ((char >= 97 && char <= 122) || (char >= 65 && char <= 90)) {
        curString += String.fromCharCode(char);
      } else {
        if (curString.isNotEmpty) {
          words.add(buildClickableWord(curString));
          curString = '';
        }
        words.add(buildCharacter(String.fromCharCode(char)));
      }
    }
    return words;
  }

  TextSpan buildCharacter(String char) {
    return TextSpan(text: char);
  }

  TextSpan buildClickableWord(String word) {
    return TextSpan(
        text: word,
        recognizer: TapGestureRecognizer()
          ..onTap = () {
            print(word);
          });
  }
}
