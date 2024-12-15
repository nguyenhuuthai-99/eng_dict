import 'dart:ffi';

import 'package:eng_dict/model/word.dart';
import 'package:eng_dict/view/utils/constants.dart';
import 'package:eng_dict/view/utils/custom_icon.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DefinitionBox extends StatelessWidget {
  Word word;
  DefinitionBox({
    required this.word,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    if (word.isPhrase) {
      return buildPhraseBox(context);
    }
    return buildWordBox();
  }

  Widget buildWordBox() {
    return Padding(
      padding: const EdgeInsets.only(
          top: Constant.kMarginMedium,
          left: Constant.kMarginMedium,
          right: Constant.kMarginMedium,
          bottom: Constant.kMarginSmall),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                  child: Text(
                "B1",
                style: GoogleFonts.inter(
                    fontWeight: FontWeight.w700,
                    fontStyle: FontStyle.italic,
                    fontSize: 20,
                    color: Constant.kPrimaryColor),
                // style: TextStyle(
                //   fontSize: 20,
                //   fontWeight: FontWeight.bold,
                //   fontStyle: FontStyle.italic,
                //   color: Constant.kPrimaryColor,
                // ),
              )),
              const Icon(
                CustomIcon.book_mark,
                color: Colors.redAccent,
              )
            ],
          ),
          buildDefinitionText(
              "The word or words that a person, thing, or place is known by:"),
          Padding(
            padding: const EdgeInsets.only(
                left: Constant.kMarginMedium,
                top: Constant.kMarginExtraSmall,
                bottom: Constant.kMarginSmall),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildExample(
                    "Please write your full (= complete) name and address on the form."),
                buildExample(
                    "Please write your full (= complete) name and address on the form."),
                buildExample(
                    "Please write your full (= complete) name and address on the form."),
                buildExample(
                    "Please write your full (= complete) name and address on the form."),
                buildExample(
                    "Please write your full (= complete) name and address on the form."),
                buildExample(
                    "Please write your full (= complete) name/and/address on the form."),
                buildExample(
                    "Please write your full (= complete) name and address on the form."),
                buildExample(
                    "Please write your full (= complete) name and address on the form."),
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

  Widget buildPhraseBox(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: Constant.kMarginLarge),
          child: Row(
            children: [
              Text(
                "phrase with ",
                style: TextStyle(
                    color: Constant.kGreyText, fontStyle: FontStyle.italic),
              ),
              Text(
                "Name",
                style: TextStyle(
                    color: Color(0xb82a3343), fontWeight: FontWeight.bold),
              )
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(
              horizontal: Constant.kMarginMedium,
              vertical: Constant.kMarginMedium),
          color: Constant.kGreyBackground,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                      child: buildPhraseTitle("Go by the name off something")),
                  Icon(
                    CustomIcon.book_mark,
                    color: Constant.kAccentColor,
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: Constant.kMarginMedium),
                child: Container(
                  height: 1,
                  color: Constant.kGreyLine,
                ),
              ),
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
                        "Please write your full (= complete) name and address on the form."),
                    buildExample(
                        "Please write your full (= complete) name and address on the form."),
                    buildExample(
                        "Please write your full (= complete) name and address on the form."),
                    buildExample(
                        "Please write your full (= complete) name and address on the form."),
                    buildExample(
                        "Please write your full (= complete) name and address on the form."),
                    buildExample(
                        "Please write your full (= complete) name/and/address on the form."),
                    buildExample(
                        "Please write your full (= complete) name and address on the form."),
                    buildExample(
                        "Please write your full (= complete) name and address on the form."),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  RichText buildPhraseTitle(String title) {
    return RichText(
        text: TextSpan(
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Constant.kPrimaryColor),
            children: buildClickableTextSpan(text: title)));
  }

  RichText buildDefinitionText(String text) {
    return RichText(
        text: TextSpan(
            style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: Constant.kHeading1Color),
            children: buildClickableTextSpan(text: text)));
  }

  RichText buildExample(String text) {
    List<TextSpan> children = buildClickableTextSpan(text: text);
    children.insert(
        0, const TextSpan(style: TextStyle(fontSize: 18), text: "• "));
    return RichText(
        text: TextSpan(
            style: const TextStyle(
                fontSize: 15,
                letterSpacing: 0.1,
                height: 1.5,
                color: Colors.black87),
            children: children));
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
    if (curString.isNotEmpty) words.add(buildClickableWord(curString));
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
