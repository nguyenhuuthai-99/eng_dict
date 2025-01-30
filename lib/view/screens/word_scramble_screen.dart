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
  Color alarmColor = Constant.kGreenIndicatorColor;
  int currentIndex = 0;
  int currentResultIndex = 0;

  late List<String> resultList;
  late List<String> inputList;

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

  void onStringInputChange(int index) {}

  void resetClock() {
    alarmColor = Constant.kGreenIndicatorColor;
  }

  void updateWord() {
    currentIndex++;
    currentResultIndex = 0;
    if (currentIndex < widget.words.length) {
      initWordList();
    } else {
      // todo show result
      print('congratulation!! you have finish the game');
    }

    //todo if currentIndex exceed word list: show result
  }

  void checkAnswer() {
    print(resultList.join());
    if (resultList.join() == widget.words[currentIndex]) {
      setState(() {
        updateWord();
        resetClock();
      });
    } else {
      //decrease word fluency level of the word
      //add to wrong list
    }
  }

  void timer() {
    //todo if timer == 0, updateWord()
  }

  List<String> buildScrambleWord() {
    List<String> stringList = widget.words[currentIndex].split("");

    return stringList..shuffle();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${currentIndex + 1}/${widget.words.length}"),
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
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        CupertinoIcons.alarm,
                        color: alarmColor,
                        size: 32,
                      ),
                      const SizedBox(
                        width: Constant.kMarginSmall,
                      ),
                      Text(
                        "00:30",
                        style: GoogleFonts.chivoMono(
                            color: alarmColor,
                            fontSize: 28,
                            fontWeight: FontWeight.w300),
                      )
                    ],
                  ),
                ),
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
                                  resultList[currentResultIndex - 1] != ' ') {
                                //remove the last element
                                var char = resultList[currentResultIndex - 1];
                                resultList[currentResultIndex - 1] = ' ';

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
          ),
        ),
      ),
    );
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

//List<Char> result;
//List<Char> scrambled;
