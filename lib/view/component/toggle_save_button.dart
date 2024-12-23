import 'package:eng_dict/model/word.dart';
import 'package:eng_dict/view/utils/constants.dart';
import 'package:eng_dict/view/utils/custom_icon.dart';
import 'package:flutter/material.dart';

class ToggleSaveButton extends StatefulWidget {
  Word? word;

  ToggleSaveButton({
    this.word,
    super.key,
  });

  @override
  State<ToggleSaveButton> createState() => _ToggleSaveButtonState();
}

class _ToggleSaveButtonState extends State<ToggleSaveButton> {
  bool isClicked = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (!isClicked) {
          print(widget.word?.wordTitle ?? "");
          if (widget.word!.isPhrase) {
            print(widget.word?.phraseTitle ?? "");
          }
          print(widget.word?.definition);
          print(widget.word?.url ?? "");
        }
        setState(() {
          isClicked = true;
        });
      },
      child: isClicked
          ? const Icon(
              CustomIcon.book_mark_filled,
              color: Constant.kPrimaryColor,
            )
          : const Icon(
              CustomIcon.book_mark,
              color: Colors.black38,
            ),
    );
  }
}
