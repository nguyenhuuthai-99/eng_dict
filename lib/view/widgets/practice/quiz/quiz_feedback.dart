import 'package:eng_dict/model/vocabulary.dart';
import 'package:eng_dict/view/utils/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class IncorrectFeedback extends StatelessWidget {
  IncorrectFeedback({
    required this.onNextPressed,
    this.incorrectWords,
    super.key,
  });

  List<Vocabulary>? incorrectWords;

  Function() onNextPressed;

  String buildIncorrectWordText() {
    String result = 'You need to work more on:';
    for (var word in incorrectWords!) {
      result += ' ${word.wordTitle},';
    }
    return result.substring(0, result.length - 1);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Constant.kRedBackground,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(Constant.kMarginSmall),
              topRight: Radius.circular(Constant.kMarginSmall))),
      padding: EdgeInsets.only(
          left: Constant.kMarginLarge,
          right: Constant.kMarginLarge,
          top: Constant.kMarginLarge),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                const Icon(
                  CupertinoIcons.xmark_circle_fill,
                  color: Constant.kRedIndicatorColor,
                ),
                const SizedBox(
                  width: Constant.kMarginMedium,
                ),
                Text(
                  "Incorrect",
                  style: Constant.kPracticeFeedbackTitle
                      .apply(color: Constant.kRedIndicatorColor),
                )
              ],
            ),
            SizedBox(
              height: Constant.kMarginMedium,
            ),
            if (incorrectWords != null)
              Padding(
                padding: const EdgeInsets.only(bottom: Constant.kMarginMedium),
                child: Text(
                  buildIncorrectWordText(),
                  style: TextStyle(color: Constant.kRedIndicatorColor),
                ),
              ),
            TextButton(
                style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        vertical: Constant.kMarginMedium),
                    shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(Constant.kMarginSmall)),
                    backgroundColor: Constant.kRedIndicatorColor),
                onPressed: onNextPressed,
                child: const Text(
                  "Next",
                  style: TextStyle(color: Colors.white),
                ))
          ],
        ),
      ),
    );
  }
}

class CorrectFeedback extends StatelessWidget {
  CorrectFeedback({
    required this.onNextPressed,
    super.key,
  });

  Function() onNextPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          color: Constant.kGreenBackground,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(Constant.kMarginSmall),
              topRight: Radius.circular(Constant.kMarginSmall))),
      padding: const EdgeInsets.only(
          left: Constant.kMarginLarge,
          right: Constant.kMarginLarge,
          top: Constant.kMarginLarge),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                const Icon(
                  CupertinoIcons.check_mark_circled_solid,
                  color: Constant.kGreenIndicatorColor,
                ),
                const SizedBox(
                  width: Constant.kMarginMedium,
                ),
                Text(
                  "Good Job",
                  style: Constant.kPracticeFeedbackTitle
                      .apply(color: Constant.kGreenIndicatorColor),
                )
              ],
            ),
            const SizedBox(
              height: Constant.kMarginMedium,
            ),
            TextButton(
                style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        vertical: Constant.kMarginMedium),
                    shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(Constant.kMarginSmall)),
                    backgroundColor: Constant.kGreenIndicatorColor),
                onPressed: onNextPressed,
                child: const Text(
                  "Next",
                  style: TextStyle(color: Colors.white),
                ))
          ],
        ),
      ),
    );
  }
}
