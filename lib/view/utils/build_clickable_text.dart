import 'package:eng_dict/model/searched_word.dart';
import 'package:eng_dict/networking/database_helper.dart';
import 'package:eng_dict/view/screens/bottom_sheet_dictionary.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../provider/action_counter.dart';

class BuildClickableText {
  static List<TextSpan> buildClickableTextSpan(
      {required String text, required BuildContext context}) {
    List<int> textCodes = text.codeUnits;
    List<TextSpan> words = [];
    String curString = '';
    for (int char in textCodes) {
      if ((char >= 97 && char <= 122) ||
          (char >= 65 && char <= 90) ||
          char == 39) {
        curString += String.fromCharCode(char);
      } else {
        if (curString.isNotEmpty) {
          words.add(buildClickableWord(curString, context));
          curString = '';
        }
        words.add(buildCharacter(String.fromCharCode(char)));
      }
    }
    if (curString.isNotEmpty) words.add(buildClickableWord(curString, context));
    return words;
  }

  static TextSpan buildClickableWord(String word, BuildContext context) {
    return TextSpan(
        text: word,
        recognizer: TapGestureRecognizer()
          ..onTap = () {
            try {
              Provider.of<ActionCounter>(context, listen: false)
                  .incrementCounter();
            } catch (e) {
              debugPrint(e.toString());
            }
            Provider.of<DatabaseHelper>(context, listen: false)
                .insertSearchedWord(SearchedWord(
              wordTitle: word,
              url: "/search/direct/?datasetsearch=english&q=$word",
            ));
            showDictionaryBottomSheet(context: context, word: word);
          });
  }

  static TextSpan buildCharacter(String char) {
    return TextSpan(text: char);
  }
}
