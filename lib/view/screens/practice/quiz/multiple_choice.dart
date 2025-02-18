import 'package:eng_dict/model/vocabulary.dart';
import 'package:eng_dict/view/component/count_down_timer.dart';
import 'package:eng_dict/view/utils/constants.dart';
import 'package:eng_dict/view/utils/play_sound.dart';
import 'package:eng_dict/view/widgets/practice/quiz/quiz_feedback.dart';
import 'package:flutter/material.dart';

class MultipleChoiceScreen extends StatefulWidget {
  MultipleChoiceScreen({
    required this.timeLimit,
    required this.words,
    required this.testingWord,
    required this.onSubmit,
    required this.onNextPressed,
    super.key,
  });
  int timeLimit;
  List<Vocabulary> words;
  Vocabulary testingWord;
  Function(bool isCorrect) onSubmit;
  Function() onNextPressed;

  @override
  State<MultipleChoiceScreen> createState() => _MultipleChoiceScreenState();
}

class _MultipleChoiceScreenState extends State<MultipleChoiceScreen> {
  bool _isSelected = false;
  String? _correctWord;
  String? selectedWord;

  bool? _isCorrect;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    widget.words.add(widget.testingWord);
    widget.words.shuffle();
  }

  void onTimesUp() {
    if (_correctWord != null) {
      return;
    }
    checkAnswer();
  }

  void checkAnswer() {
    setState(() {
      _correctWord = widget.testingWord.wordTitle;
    });

    if (selectedWord == null) {
      PlaySound.playAssetSound("/assets/sounds/wrong.mp3");
      _isCorrect = false;
      widget.onSubmit(false);
      return;
    }
    if (selectedWord! == _correctWord) {
      PlaySound.playAssetSound("/assets/sounds/right.mp3");
      _isCorrect = true;
    } else {
      PlaySound.playAssetSound("/assets/sounds/wrong.mp3");
      _isCorrect = false;
    }
    widget.onSubmit(selectedWord! == _correctWord);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: Constant.kMarginLarge),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                  child: TimerWidget(
                      startTime: widget.timeLimit, onTimesUp: onTimesUp)),
              Text(
                widget.testingWord.definition,
                style: Constant.kHeadingTextStyle.copyWith(color: Colors.black),
              ),
              SelectionWidget(
                correctWord: _correctWord,
                onChange: (selectedWord, selectedIndex) {
                  setState(() {
                    _isSelected = true;
                    this.selectedWord = selectedWord;
                  });
                },
                words: widget.words,
              ),
              TextButton(
                  style: TextButton.styleFrom(
                      backgroundColor:
                          !_isSelected ? Colors.black12 : Constant.kBlue,
                      shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(Constant.kMarginSmall))),
                  onPressed: !_isSelected ? null : checkAnswer,
                  child: const Text(
                    "Submit",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ))
            ],
          ),
        ),
        if (_isCorrect != null)
          Align(
            alignment: Alignment.bottomCenter,
            child: _isCorrect == true
                ? CorrectFeedback(onNextPressed: widget.onNextPressed)
                : IncorrectFeedback(onNextPressed: widget.onNextPressed),
          )
      ],
    );
  }
}

class SelectionWidget extends StatefulWidget {
  SelectionWidget(
      {super.key,
      required this.words,
      required this.onChange,
      this.correctWord});

  final List<Vocabulary> words;
  Function(String selectedWord, int selectedIndex) onChange;
  final String? correctWord;

  @override
  State<SelectionWidget> createState() => _SelectionWidgetState();
}

class _SelectionWidgetState extends State<SelectionWidget> {
  int? selectedIndex;

  void onChange(int index, String selectedWord) {
    if (widget.correctWord != null) {
      return;
    }
    setState(() {
      selectedIndex = index;
    });
    widget.onChange(selectedWord, index);
  }

  Color pickColor(int index) {
    if (widget.correctWord != null) {
      if (widget.correctWord! == widget.words[index].wordTitle) {
        return Constant.kGreenIndicatorColor;
      }
    }

    if (selectedIndex == index) {
      if (widget.correctWord != null) {
        return Constant.kRedIndicatorColor;
      }
      return Constant.kBlue;
    }
    return Colors.black54;
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: widget.words.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        childAspectRatio: 1.9,
        crossAxisCount: 2,
        crossAxisSpacing: Constant.kMarginExtraLarge,
        mainAxisSpacing: Constant.kMarginExtraLarge,
      ),
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () => onChange(index, widget.words[index].wordTitle),
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Constant.kMarginSmall),
                border: Border.all(color: pickColor(index), width: 2)),
            child: Center(
              child: Text(
                widget.words[index].wordTitle,
                style: Constant.kHeading2TextStyle.copyWith(
                    fontWeight: FontWeight.bold, color: pickColor(index)),
              ),
            ),
          ),
        );
      },
    );
  }
}
