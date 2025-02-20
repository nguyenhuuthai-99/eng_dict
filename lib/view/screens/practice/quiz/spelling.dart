import 'package:eng_dict/view/component/count_down_timer.dart';
import 'package:eng_dict/view/utils/constants.dart';
import 'package:eng_dict/view/utils/custom_icon.dart';
import 'package:eng_dict/view/utils/play_sound.dart';
import 'package:eng_dict/view/widgets/practice/quiz/quiz_feedback.dart';
import 'package:flutter/material.dart';

import '../../../../model/vocabulary.dart';

class SpellingLessonScreen extends StatefulWidget {
  SpellingLessonScreen(
      {super.key,
      required this.word,
      required this.onSubmit,
      required this.onNextPressed,
      required this.timeLimit});
  int timeLimit;
  Vocabulary word;
  Function(bool isCorrect, Vocabulary vocabulary) onSubmit;
  Function() onNextPressed;

  @override
  State<SpellingLessonScreen> createState() => _SpellCheckScreenState();
}

class _SpellCheckScreenState extends State<SpellingLessonScreen> {
  int _attempt = 3;
  late String _input;
  bool _canSubmit = false;
  bool? _isCorrect;

  TextEditingController _textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    PlaySound.playSoundFromURL(widget.word.soundUrl!);
  }

  void checkAnswer() {
    if (_input == widget.word.wordTitle.toUpperCase()) {
      PlaySound.playAssetSound("assets/sounds/right.mp3");
      widget.onSubmit(true, widget.word);
      _isCorrect = true;
    } else {
      _attempt--;
      PlaySound.playAssetSound("assets/sounds/wrong.mp3");
      _textEditingController.clear();
      if (_attempt <= 0) {
        widget.onSubmit(false, widget.word);
        _isCorrect = false;
      }
    }
    setState(() {});
    // FocusManager.instance.primaryFocus?.unfocus();
  }

  void onTimesUp() {
    _attempt = 0;
    checkAnswer();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: Constant.kMarginLarge),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: Constant.kMarginExtraLarge),
                      child: TimerWidget(
                          startTime: widget.timeLimit, onTimesUp: onTimesUp),
                    ),
                    SizedBox(
                      height: Constant.kMarginExtraLarge,
                    ),
                    GestureDetector(
                      onTap: () {
                        PlaySound.playSoundFromURL(widget.word.soundUrl!);
                      },
                      child: const CircleAvatar(
                        radius: 40,
                        backgroundColor: Constant.kGreyBackground,
                        child: Icon(
                          CustomIcon.speaker,
                          color: Constant.kPrimaryColor,
                          size: 80,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 32,
                    ),
                    Text(
                      widget.word.definition,
                      style: Constant.kHeading2TextStyle,
                    )
                  ],
                ),
                const Expanded(child: SizedBox()),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      "   Attempt: $_attempt",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: Constant.kMarginMedium),
                      child: TextField(
                        controller: _textEditingController,
                        autocorrect: false,
                        enableSuggestions: false,
                        autofocus: true,
                        decoration: const InputDecoration(
                            focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.grey, width: 2)),
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey))),
                        textCapitalization: TextCapitalization.characters,
                        maxLines: 1,
                        style: TextStyle(fontWeight: FontWeight.bold),
                        onSubmitted: (value) => checkAnswer(),
                        onChanged: (value) {
                          _input = value;
                          setState(() {
                            if (value.isNotEmpty) {
                              _canSubmit = true;
                            } else {
                              _canSubmit = false;
                            }
                          });
                        },
                      ),
                    ),
                    TextButton(
                        style: TextButton.styleFrom(
                            backgroundColor:
                                !_canSubmit ? Colors.black12 : Constant.kBlue,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    Constant.kMarginSmall))),
                        onPressed: !_canSubmit ? null : checkAnswer,
                        child: const Text(
                          "Submit",
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        )),
                  ],
                ),
              ],
            ),
          ),
          if (_isCorrect != null)
            Align(
              alignment: Alignment.bottomCenter,
              child: _isCorrect!
                  ? CorrectFeedback(onNextPressed: widget.onNextPressed)
                  : IncorrectFeedback(onNextPressed: widget.onNextPressed),
            )
        ],
      ),
    );
  }
}
