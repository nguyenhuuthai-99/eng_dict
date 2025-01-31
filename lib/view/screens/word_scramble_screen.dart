import 'dart:async';

import 'package:eng_dict/model/word.dart';
import 'package:eng_dict/view/screens/word_scramble_start_screen.dart';
import 'package:eng_dict/view/utils/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../utils/custom_icon.dart';

class WordScrambleScreen extends StatelessWidget {
  bool showHint;
  ScrambleDifficulty difficulty;
  WordScrambleScreen(
      {super.key, required this.showHint, required this.difficulty});

  bool isLoading = false;

  List<String> testWord = [
    "remarkable",
    "consequence",
    "persuade",
    "sufficient",
    "elaborate",
    "moderate",
    "compromise",
    "integrate",
    "prejudice",
    "ambiguity"
  ];

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          )
        : ScrambleGameScreen(
            words: testWord,
          );
  }
}

class ScrambleGameScreen extends StatefulWidget {
  //todo replace this after the prototype
  // final List<Word> word;
  final List<String> words;
  const ScrambleGameScreen({super.key, required this.words});

  @override
  State<ScrambleGameScreen> createState() => _ScrambleGameScreenState();
}

class _ScrambleGameScreenState extends State<ScrambleGameScreen> {
  int currentIndex = 0;
  int currentResultIndex = 0;
  bool firstTry = true;

  late List<String> resultList;
  late List<String> inputList;

  List<String> masteredList = [];
  List<String> needToLearnList = [];
  List<String> wrongList = [];

  int timerKey = 0;
  bool isFinish = false;

  @override
  void initState() {
    super.initState();
    initWordList();
  }

  void initWordList() {
    String currentString = widget.words[currentIndex];
    resultList = [];
    for (int i = 0; i < currentString.length; i++) {
      resultList.add(" ");
    }
    inputList = buildScrambleWord();
  }

  void resetClock() {
    timerKey++;
  }

  void onTimesUp() {
    if (isFinish) return;
    setState(() {
      resetClock();
      updateWrongList();
      updateWord();
    });
  }

  void updateNeedToLearnList() {
    needToLearnList.add(widget.words[currentIndex]);
  }

  void updateMasteredList() {
    masteredList.add(widget.words[currentIndex]);
  }

  void updateWrongList() {
    wrongList.add(widget.words[currentIndex]);
  }

  void updateWord() {
    if (isFinish) return;
    currentIndex++;
    currentResultIndex = 0;
    firstTry = true;
    if (currentIndex < widget.words.length) {
      initWordList();
    } else {
      currentIndex--;
      isFinish = true;
    }
  }

  void checkAnswer() {
    if (resultList.join() == widget.words[currentIndex]) {
      setState(() {
        updateMasteredList();
        if (!firstTry) {
          updateNeedToLearnList();
        }
        updateWord();
        resetClock();
      });
    } else {
      firstTry = false;
      //decrease word fluency level of the word
      //add to wrong list
      // updateNeedToLearnList();
    }
  }

  List<String> buildScrambleWord() {
    List<String> stringList = widget.words[currentIndex].split("");

    return stringList..shuffle();
  }

  @override
  Widget build(BuildContext context) {
    return !isFinish
        ? Scaffold(
            appBar: AppBar(
              title: Text(
                "${currentIndex + 1}/${widget.words.length}",
                style: Constant.kHeadingTextStyle,
              ),
              actions: [
                IconButton(onPressed: () {}, icon: Icon(Icons.pause_outlined))
              ],
            ),
            body: SafeArea(
              child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: Constant.kMarginExtraLarge),
                  child: Column(
                    children: [
                      Flexible(
                        flex: 1,
                        child: Center(
                            child: TimerWidget(
                          startTime: 10,
                          onTimesUp: () => onTimesUp(),
                          key: ValueKey(timerKey),
                        )),
                      ),
                      Flexible(
                          flex: 1,
                          child: ScrambleResultStringBox(
                            result: resultList,
                          )),
                      Flexible(
                          flex: 1,
                          child: ScrambleInputStringBox(
                            scrambledWordList: inputList,
                            onChange: (index) {
                              setState(() {
                                //remove element from the input list
                                var char = inputList.removeAt(index);

                                //add that element to the result list
                                resultList[currentResultIndex] = char;
                                //scrambleWord list is empty, check answer
                                //checkAnswer();
                                currentResultIndex++;

                                if (inputList.isEmpty) {
                                  //todo check answer
                                  checkAnswer();
                                }
                              });
                            },
                          )),
                      Column(
                        children: [
                          Row(
                            children: [
                              IconButton(
                                  onPressed: () {
                                    //todo play sounds
                                  },
                                  icon: const Icon(
                                    size: 30,
                                    CustomIcon.speaker,
                                    color: Constant.kPrimaryColor,
                                  )),
                              Text(
                                "noun",
                                style: Constant.kHeading2TextStyle
                                    .apply(fontStyle: FontStyle.italic),
                              ),
                              Expanded(child: const SizedBox()),
                              TextButton(
                                  onPressed: () {
                                    setState(() {
                                      //if currentResultIndex > 0

                                      if (currentResultIndex - 1 >= 0 &&
                                          resultList[currentResultIndex - 1] !=
                                              ' ') {
                                        //remove the last element
                                        var char =
                                            resultList[currentResultIndex - 1];
                                        resultList[currentResultIndex - 1] =
                                            ' ';

                                        //add to input list
                                        inputList.add(char);

                                        //if the current index reach boundary
                                        if (currentResultIndex > 0) {
                                          currentResultIndex--;
                                        }
                                      }
                                    });
                                  },
                                  child: const Icon(
                                    CupertinoIcons.delete_left_fill,
                                    size: 24,
                                    color: Colors.black87,
                                  ))
                            ],
                          ),
                          const SizedBox(
                            height: Constant.kMarginMedium,
                          ),
                          SizedBox(
                            height: 200,
                            child: SingleChildScrollView(
                              child: Text(
                                "asdjasd fasd fas fasd fasd faifj fjsif a",
                                style: Constant.kHeadingTextStyle,
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  )),
            ),
          )
        : ScrambleResultScreen(
            acedWords: masteredList,
            failedWords: wrongList,
            sharpenWords: needToLearnList,
            total: widget.words.length);
  }
}

class ScrambleInputStringBox extends StatelessWidget {
  List<String> scrambledWordList;
  Function(int index) onChange;
  ScrambleInputStringBox({
    required this.scrambledWordList,
    required this.onChange,
    super.key,
  });

  List<Widget> buildCharList(List<String> wordString) {
    return wordString
        .asMap()
        .map(
          (index, e) => MapEntry(
              index,
              ScrambleInputCharBox(
                index: index,
                char: e.toUpperCase(),
                onInputChange: (index) => onChange(index),
              )),
        )
        .values
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FittedBox(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: buildCharList(scrambledWordList),
        ),
      ),
    );
  }
}

class ScrambleResultStringBox extends StatelessWidget {
  List<String> result;
  String currentString = '';
  ScrambleResultStringBox({
    required this.result,
    super.key,
  });

  List<Widget> buildCharBox() {
    return result
        .map(
          (e) => ScrambleResultCharBox(char: e.toUpperCase()),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FittedBox(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: buildCharBox(),
        ),
      ),
    );
  }
}

class ScrambleInputCharBox extends StatelessWidget {
  final String char;
  final int index;
  Function(int index) onInputChange;
  ScrambleInputCharBox({
    required this.index,
    required this.char,
    required this.onInputChange,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onInputChange(index),
      child: Container(
        width: 35,
        height: 35,
        padding: const EdgeInsets.only(bottom: 2),
        margin: EdgeInsets.symmetric(horizontal: Constant.kMarginExtraSmall),
        decoration: BoxDecoration(
            color: Constant.kGreyBackground,
            border: Border.all(color: Constant.kGreyLine, width: 2)),
        child: Center(
          child: Text(
            char,
            style: GoogleFonts.azeretMono(
              color: Constant.kPrimaryColor,
              fontWeight: FontWeight.bold,
              height: 0.7,
              fontSize: 32,
            ),
          ),
        ),
      ),
    );
  }
}

class ScrambleResultCharBox extends StatelessWidget {
  final String char;
  const ScrambleResultCharBox({
    required this.char,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.symmetric(horizontal: Constant.kMarginExtraSmall),
      child: IntrinsicWidth(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              char,
              style: GoogleFonts.azeretMono(
                  height: 1,
                  backgroundColor: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Constant.kPrimaryColor),
            ),
            if (char == " ")
              Container(
                color: Constant.kPrimaryColor,
                height: 4,
              )
          ],
        ),
      ),
    );
  }
}

class TimerWidget extends StatefulWidget {
  final int startTime;
  Function onTimesUp;
  TimerWidget({super.key, required this.startTime, required this.onTimesUp});

  @override
  State<TimerWidget> createState() => _TimerWidgetState();
}

class _TimerWidgetState extends State<TimerWidget> {
  late int _seconds;
  Timer? _timer;

  Color _timerColor = Constant.kGreenIndicatorColor;

  @override
  void initState() {
    super.initState();
    _seconds = widget.startTime;
    _startTimer();
  }

  void _startTimer() {
    if (_timer != null) return;

    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        setState(() {
          if (_seconds > 0) {
            _seconds--;
            updateTimerColor();
          } else {
            _cancelTimer();
            widget.onTimesUp();
          }
        });
      },
    );
  }

  void updateTimerColor() {
    if (_seconds == (widget.startTime * 2 / 3).floor()) {
      _timerColor = Constant.kYellowIndicatorColor;
    } else if (_seconds == (widget.startTime * 1 / 3).floor()) {
      _timerColor = Constant.kRedIndicatorColor;
    }
  }

  void _cancelTimer() {
    _timer?.cancel();
    _timer = null;
  }

  String _formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int secondsLeft = seconds % 60;

    return '${minutes.toString().padLeft(2, '0')}:${secondsLeft.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    super.dispose();
    _cancelTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          CupertinoIcons.alarm,
          color: _timerColor,
          size: 32,
        ),
        const SizedBox(
          width: Constant.kMarginSmall,
        ),
        Text(
          _formatTime(_seconds),
          style: GoogleFonts.chivoMono(
              color: _timerColor, fontSize: 28, fontWeight: FontWeight.w300),
        )
      ],
    );
  }
}

class ScrambleResultScreen extends StatelessWidget {
  List<String> acedWords;
  List<String> failedWords;
  List<String> sharpenWords;
  int total;
  ScrambleResultScreen(
      {super.key,
      required this.acedWords,
      required this.failedWords,
      required this.sharpenWords,
      required this.total});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Result"),
      ),
      body: Padding(
        padding:
            const EdgeInsets.symmetric(horizontal: Constant.kMarginExtraLarge),
        child: ListView(
          children: [
            const Text(
              "🎉 Well done! You completed the Scramble Game! 🎊",
              style: Constant.kHeading2TextStyle,
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: Constant.kMarginExtraLarge,
            ),
            ScrambleReportBox(
                title: "Aced words",
                statistic: acedWords.length,
                total: total,
                color: Constant.kGreenIndicatorColor,
                words: acedWords),
            ScrambleReportBox(
                title: "Failed words",
                statistic: failedWords.length,
                total: total,
                color: Constant.kRedIndicatorColor,
                words: failedWords),
            ScrambleReportBox(
                title: "Words to sharpen",
                statistic: sharpenWords.length,
                color: Constant.kYellowIndicatorColor,
                total: total,
                explanation: "Words that you got them right after many attempt",
                words: sharpenWords),
          ],
        ),
      ),
    );
  }
}

class ScrambleReportBox extends StatelessWidget {
  String title;
  int statistic;
  int total;
  List<String> words;
  String? explanation;
  Color color;

  ScrambleReportBox(
      {required this.title,
      required this.statistic,
      required this.total,
      required this.words,
      this.explanation,
      required this.color,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Constant.kMarginMedium),
      child: Column(
        children: [
          Row(
            children: [
              RichText(
                  text: TextSpan(style: Constant.kHeadingTextStyle, children: [
                TextSpan(text: "$title "),
                TextSpan(
                    text: "$statistic/$total ", style: TextStyle(color: color))
              ])),
              if (explanation != null)
                Tooltip(
                  triggerMode: TooltipTriggerMode.tap,
                  preferBelow: false,
                  child: Icon(
                    CupertinoIcons.question_circle,
                    color: Colors.grey,
                  ),
                  message: explanation,
                )
            ],
          ),
          ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (context, index) => RichText(
                text: TextSpan(style: TextStyle(color: color), children: [
              Constant.kDotCustom..style?.copyWith(color: color),
              TextSpan(
                  text: words[index],
                  style: Constant.kAdditionalTitle.apply(color: color)),
            ])),
            itemCount: words.length,
          )
        ],
      ),
    );
  }
}
