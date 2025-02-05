import 'dart:async';
import 'dart:math';

import 'package:eng_dict/model/vocabulary.dart';
import 'package:eng_dict/networking/database_helper.dart';
import 'package:eng_dict/provider/vocabulary_data.dart';
import 'package:eng_dict/view/dialog/alertDialog.dart';
import 'package:eng_dict/view/screens/word_scramble_start_screen.dart';
import 'package:eng_dict/view/utils/constants.dart';
import 'package:eng_dict/view/utils/play_sound.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../utils/custom_icon.dart';

class WordScrambleScreen extends StatefulWidget {
  bool showHint;
  ScrambleDifficulty difficulty;
  WordScrambleScreen({
    super.key,
    required this.showHint,
    required this.difficulty,
  });

  @override
  State<WordScrambleScreen> createState() => _WordScrambleScreenState();
}

class _WordScrambleScreenState extends State<WordScrambleScreen> {
  bool isLoading = true;

  late List<Vocabulary> wordList = [];
  late DatabaseHelper databaseHelper;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    initWords();
  }

  Future<void> initWords() async {
    databaseHelper = Provider.of<DatabaseHelper>(context, listen: false);
    Random random = Random();

    // Function to randomly pick `count` elements from a list
    List<Vocabulary> pickRandom(List<Vocabulary> source, int count) {
      List<Vocabulary> picked = [];
      for (int i = 0; i < count && source.isNotEmpty; i++) {
        int index = random.nextInt(source.length);
        picked.add(source.removeAt(index));
      }
      return picked;
    }

    List<Vocabulary> level1Words =
        await databaseHelper.getVocabularyOnLevel(VocabularyLevel.unfamiliar);
    List<Vocabulary> level2Words =
        await databaseHelper.getVocabularyOnLevel(VocabularyLevel.familiar);
    List<Vocabulary> level3Words =
        await databaseHelper.getVocabularyOnLevel(VocabularyLevel.mastered);

    wordList.addAll(pickRandom(level1Words, 6));
    wordList.addAll(pickRandom(level2Words, 2));
    wordList.addAll(pickRandom(level3Words, 2));

    int remaining = 10 - wordList.length;
    if (remaining > 0) {
      List<Vocabulary> extraElements = [
        ...level2Words,
        ...level3Words,
        ...level1Words
      ];
      wordList.addAll(pickRandom(extraElements, remaining));
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Scaffold(
            body: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(),
                  Text("Loading words from vocabulary")
                ],
              ),
            ),
          )
        : wordList.length > 2
            ? ScrambleGameScreen(
                words: wordList,
                showHint: widget.showHint,
                difficulty: widget.difficulty,
              )
            : Scaffold(
                appBar: AppBar(),
                body: SafeArea(
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          textAlign: TextAlign.center,
                          "You need to have at least 3 words in vocabulary list to play scramble game",
                          style: Constant.kSectionTitle,
                        ),
                        const Text(
                          "Please add more word and try later.",
                          style: Constant.kHeading2TextStyle,
                        )
                      ],
                    ),
                  ),
                ),
              );
  }
}

class ScrambleGameScreen extends StatefulWidget {
  final bool showHint;
  final ScrambleDifficulty difficulty;
  final List<Vocabulary> words;
  ScrambleGameScreen(
      {super.key,
      required this.words,
      required this.showHint,
      required this.difficulty});

  @override
  State<ScrambleGameScreen> createState() => _ScrambleGameScreenState();
}

class _ScrambleGameScreenState extends State<ScrambleGameScreen> {
  int currentIndex = 0;
  int currentResultIndex = 0;
  bool firstTry = true;
  bool isWrong = false;

  late List<String> resultList;
  late List<String> inputList;

  List<int> masteredList = [];
  List<int> needToLearnList = [];
  List<int> wrongList = [];

  late int currentFluency;
  List<int> updatedFluency = [];

  late Vocabulary currentWord;
  late String currentWordTitle;

  int timerKey = 0;
  late int countDownTime;
  bool isFinish = false;

  @override
  void initState() {
    super.initState();
    initWordList();
    pickCountDownTime();
  }

  void pickCountDownTime() {
    if (widget.difficulty == ScrambleDifficulty.easy) {
      countDownTime = 120;
    } else if (widget.difficulty == ScrambleDifficulty.medium) {
      countDownTime = 60;
    } else {
      countDownTime = 10;
    }
  }

  void initWordList() {
    currentWord = widget.words[currentIndex];
    currentFluency = currentWord.fluencyLevel;
    currentWordTitle = widget.words[currentIndex].wordTitle;
    resultList = [];
    for (int i = 0; i < currentWordTitle.length; i++) {
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
    currentFluency--;
    needToLearnList.add(currentIndex);
  }

  void updateMasteredList() {
    currentFluency++;
    print(currentFluency);
    updatedFluency.add(currentFluency);
    masteredList.add(currentIndex);
  }

  void updateWrongList() {
    currentFluency--;
    if (currentFluency == 0) {
      currentFluency = 1;
    }
    updatedFluency.add(currentFluency);
    wrongList.add(currentIndex);
  }

  void updateWord() {
    isWrong = false;
    if (isFinish) return;
    currentIndex++;
    currentResultIndex = 0;
    firstTry = true;
    if (currentIndex < widget.words.length) {
      initWordList();
    } else {
      currentIndex--;
      isFinish = true;
      updateFluencyLevel();
    }
  }

  Future<void> updateFluencyLevel() async {
    VocabularyData vocabularyData =
        Provider.of<VocabularyData>(context, listen: false);

    for (int i = 0; i < updatedFluency.length; i++) {
      if (widget.words[i].fluencyLevel != updatedFluency[i]) {
        await vocabularyData.updateVocabulary(
            widget.words[i].id, updatedFluency[i]);
      }
    }
    vocabularyData.getVocabulary();
  }

  void checkAnswer() {
    if (resultList.join() == currentWordTitle) {
      PlaySound.playAssetSound("assets/sounds/right.mp3");
      setState(() {
        if (!firstTry) {
          updateNeedToLearnList();
        }
        updateMasteredList();
        updateWord();
        resetClock();
      });
    } else {
      firstTry = false;
      isWrong = true;
      PlaySound.playAssetSound("assets/sounds/wrong.mp3");
      //decrease word fluency level of the word
      //add to wrong list
      // updateNeedToLearnList();
    }
  }

  List<String> buildScrambleWord() {
    List<String> stringList = currentWordTitle.split("");

    return stringList..shuffle();
  }

  @override
  Widget build(BuildContext context) {
    return !isFinish
        ? Scaffold(
            appBar: AppBar(
              leading: GestureDetector(
                onTap: () => showDialog(
                  context: context,
                  builder: (context) => ConfirmAlert(
                      confirmAction: () {
                        Navigator.pop(context);
                        Navigator.pop(context);
                      },
                      title: "Exit Practice Mode",
                      content:
                          "Are you sure you want to exit current training session.\n"
                          "Your progress won't be saved."),
                ),
                child: const Icon(CupertinoIcons.back),
              ),
              title: Text(
                "${currentIndex + 1}/${widget.words.length}",
                style: Constant.kHeadingTextStyle,
              ),
            ),
            body: SafeArea(
              child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: Constant.kMarginExtraLarge),
                  child: Stack(
                    children: [
                      if (isWrong)
                        Center(
                          child: Text(
                            "INCORRECT ❌",
                            style: GoogleFonts.openSans(
                                fontSize: 24,
                                fontWeight: FontWeight.w900,
                                color: Colors.red),
                          ),
                        ),
                      Column(
                        children: [
                          Flexible(
                            flex: 1,
                            child: Center(
                                child: TimerWidget(
                              startTime: countDownTime,
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
                                      checkAnswer();
                                    }
                                  });
                                },
                              )),
                          Column(
                            children: [
                              Row(
                                children: [
                                  if (widget.showHint == true &&
                                      currentWord.soundUrl != null)
                                    IconButton(
                                        onPressed: () {
                                          PlaySound.playSoundFromURL(
                                              currentWord.soundUrl!);
                                        },
                                        icon: const Icon(
                                          size: 30,
                                          CustomIcon.speaker,
                                          color: Constant.kPrimaryColor,
                                        )),
                                  Text(
                                    currentWord.wordForm,
                                    style: Constant.kHeading2TextStyle
                                        .apply(fontStyle: FontStyle.italic),
                                  ),
                                  const Expanded(child: const SizedBox()),
                                  TextButton(
                                      onPressed: () {
                                        setState(() {
                                          //remove incorrect pop up
                                          if (currentResultIndex ==
                                              currentWordTitle.length) {
                                            isWrong = false;
                                          }

                                          if (currentResultIndex - 1 >= 0 &&
                                              resultList[
                                                      currentResultIndex - 1] !=
                                                  ' ') {
                                            //remove the last element
                                            var char = resultList[
                                                currentResultIndex - 1];
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
                                    currentWord.definition,
                                    style: Constant.kHeadingTextStyle,
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ],
                  )),
            ),
          )
        : ScrambleResultScreen(
            fluencyLevel: updatedFluency,
            originalWordList: widget.words,
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
  List<Vocabulary> originalWordList;
  List<int> fluencyLevel;

  List<int> acedWords;
  List<int> failedWords;
  List<int> sharpenWords;
  int total;

  ScrambleResultScreen(
      {super.key,
      required this.fluencyLevel,
      required this.originalWordList,
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
              fluencyLevel: fluencyLevel,
              originalWordList: originalWordList,
              title: "Aced words",
              statistic: acedWords.length,
              total: total,
              statisticColor: Constant.kGreenIndicatorColor,
              wordsIndex: acedWords,
            ),
            ScrambleReportBox(
                fluencyLevel: fluencyLevel,
                originalWordList: originalWordList,
                title: "Failed words",
                statistic: failedWords.length,
                total: total,
                statisticColor: Constant.kRedIndicatorColor,
                wordsIndex: failedWords),
            ScrambleReportBox(
                fluencyLevel: fluencyLevel,
                originalWordList: originalWordList,
                title: "Words to sharpen",
                statistic: sharpenWords.length,
                statisticColor: Constant.kYellowIndicatorColor,
                total: total,
                explanation: "Words that you got them right after many attempt",
                wordsIndex: sharpenWords),
          ],
        ),
      ),
    );
  }
}

class ScrambleReportBox extends StatelessWidget {
  List<Vocabulary> originalWordList;
  List<int> fluencyLevel;

  String title;
  int statistic;
  int total;
  List<int> wordsIndex;
  String? explanation;
  Color statisticColor;
  TextSpan symbol = Constant.kRemainSymbol;

  ScrambleReportBox(
      {required this.originalWordList,
      required this.fluencyLevel,
      required this.title,
      required this.statistic,
      required this.total,
      required this.wordsIndex,
      this.explanation,
      required this.statisticColor,
      super.key});

  Color pickIndicatorColor(int fluencyLevel) {
    Color fluencyColor = Constant.kRedIndicatorColor;
    if (8 >= fluencyLevel && fluencyLevel > 4) {
      fluencyColor = Constant.kYellowIndicatorColor;
    } else if (fluencyLevel > 8) {
      fluencyColor = Constant.kGreenIndicatorColor;
    }
    return fluencyColor;
  }

  TextSpan pickSymbol(Vocabulary currentWord, int updatedFluency) {
    if (currentWord.fluencyLevel > updatedFluency) {
      return Constant.kDownSymbol;
    } else if (currentWord.fluencyLevel < updatedFluency) {
      return Constant.kUpSymbol;
    }
    return symbol;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Constant.kMarginMedium),
      child: Column(
        children: [
          Row(
            children: [
              RichText(
                  text: TextSpan(style: Constant.kSectionTitle, children: [
                TextSpan(text: "$title "),
                TextSpan(
                    text: "$statistic/$total ",
                    style: TextStyle(color: statisticColor))
              ])),
              if (explanation != null)
                Tooltip(
                  triggerMode: TooltipTriggerMode.tap,
                  preferBelow: false,
                  message: explanation,
                  child: const Icon(
                    CupertinoIcons.question_circle,
                    color: Colors.grey,
                  ),
                )
            ],
          ),
          ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (context, index) => RichText(
                text: TextSpan(children: [
              pickSymbol(originalWordList[wordsIndex[index]],
                  fluencyLevel[wordsIndex[index]]),
              TextSpan(
                  text: "${fluencyLevel[wordsIndex[index]]} ",
                  style: GoogleFonts.openSans(
                      color:
                          pickIndicatorColor(fluencyLevel[wordsIndex[index]]),
                      fontWeight: FontWeight.w900)),
              TextSpan(
                  text: originalWordList[wordsIndex[index]].wordTitle,
                  style: Constant.kHeading2TextStyle),
            ])),
            itemCount: wordsIndex.length,
          )
        ],
      ),
    );
  }
}
