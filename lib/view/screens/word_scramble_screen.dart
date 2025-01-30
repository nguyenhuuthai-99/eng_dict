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

  late List<String> result;
  late List<String> scrambledWord;

  @override
  void initState() {
    super.initState();
    scrambledWord = buildScrambleWord();
    initResultList();
  }

  void initResultList() {
    String currentString = widget.words[currentIndex];
    result = [];
    for (int i = 0; i < currentString.length; i++) {
      result.add(" ");
    }
  }

  void onStringInputChange(int index) {}

  void resetClock() {
    alarmColor = Constant.kGreenIndicatorColor;
  }

  void updateWord() {
    currentIndex++;
    resetClock();
    //todo if currentIndex exceed word list: show result
  }

  void checkAnswer() {}

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
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              CupertinoIcons.alarm,
              color: alarmColor,
            ),
            Text(
              " 00:30",
              style: GoogleFonts.chivoMono(color: alarmColor),
            )
          ],
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
                  flex: 2,
                  child: ScrambleResultStringBox(
                    result: result,
                  )),
              Flexible(
                  flex: 1,
                  child: ScrambleInputStringBox(
                    scrambledWordList: scrambledWord,
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
                            //todo delete char
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
  ScrambleInputStringBox({
    required this.scrambledWordList,
    super.key,
  });

  List<Widget> buildCharList(List<String> wordString) {
    return wordString
        .map(
          (e) => ScrambleInputCharBox(char: e.toUpperCase()),
        )
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
  const ScrambleInputCharBox({
    required this.char,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
            Container(
              color: Constant.kPrimaryColor,
              height: 2,
            )
          ],
        ),
      ),
    );
  }
}

//List<Char> result;
//List<Char> scrambled;
