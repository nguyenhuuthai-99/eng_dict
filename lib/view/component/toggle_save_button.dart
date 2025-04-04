import 'package:eng_dict/model/vocabulary.dart';
import 'package:eng_dict/model/word.dart';
import 'package:eng_dict/networking/database_helper.dart';
import 'package:eng_dict/provider/vocabulary_data.dart';
import 'package:eng_dict/view/utils/constants.dart';
import 'package:eng_dict/view/utils/custom_icon.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ToggleSaveButton extends StatefulWidget {
  Word? word;
  String? soundURL;

  ToggleSaveButton({
    this.word,
    this.soundURL,
    super.key,
  });

  @override
  State<ToggleSaveButton> createState() => _ToggleSaveButtonState();
}

class _ToggleSaveButtonState extends State<ToggleSaveButton> {
  bool isClicked = false;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        if (!isClicked) {
          if (widget.word == null) {
            return;
          }
          Word word = widget.word!;

          Vocabulary vocabulary = Vocabulary();
          vocabulary.URL = word.url;
          vocabulary.wordTitle = word.wordTitle ?? "";
          vocabulary.phraseTitle = word.phraseTitle ?? "";
          vocabulary.definition = word.definition;
          vocabulary.wordForm = word.wordForm ?? "";
          vocabulary.soundUrl = widget.soundURL;
          vocabulary.fluencyLevel = word.phraseTitle != null ? 0 : 1;

          Provider.of<VocabularyData>(context, listen: false)
              .insertVocabulary(vocabulary);
        }
        setState(() {
          isClicked = true;
        });
      },
      child: isClicked
          ? const Icon(
              CustomIcon.book_mark_filled,
              size: 24,
              color: Constant.kPrimaryColor,
            )
          : const Icon(
              CustomIcon.book_mark,
              size: 24,
              color: Colors.black38,
            ),
    );
  }
}
