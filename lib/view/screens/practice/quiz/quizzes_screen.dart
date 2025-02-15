import 'dart:math';

import 'package:eng_dict/model/quiz/multiple_choice.dart';
import 'package:eng_dict/model/quiz/spelling.dart';
import 'package:eng_dict/model/quiz/word_matching.dart';
import 'package:eng_dict/model/vocabulary.dart';
import 'package:eng_dict/networking/database_helper.dart';
import 'package:eng_dict/view/component/count_down_timer.dart';
import 'package:eng_dict/view/utils/constants.dart';
import 'package:eng_dict/view/utils/custom_icon.dart';
import 'package:eng_dict/view/utils/play_sound.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

List<Vocabulary> vocabList = [
  Vocabulary()
    ..id = 1
    ..wordTitle = "Eloquent"
    ..wordForm = "Adjective"
    ..phraseTitle = "He gave an eloquent speech."
    ..wordDefinition =
        "Fluent or persuasive in speaking or writing Fluent or persuasive Fluent or persuasive in speaking or writing in speaking or writing Fluent or persuasive in speaking or writing Fluent or persuasive in speaking or writing Fluent or persuasive in speaking or writing. Fluent or persuasi"
    ..fluencyLevel = 3
    ..URL = "https://example.com/eloquent"
    ..soundUrl = "https://example.com/sounds/eloquent.mp3",
  Vocabulary()
    ..id = 2
    ..wordTitle = "Resilient"
    ..wordForm = "Adjective"
    ..phraseTitle = "She is resilient in tough situations."
    ..wordDefinition = "Able to recover quickly from difficulties."
    ..fluencyLevel = 2
    ..URL = "https://example.com/resilient"
    ..soundUrl =
        "https://dictionary.cambridge.org/media/english/us_pron/r/res/resil/resilient.mp3",
  Vocabulary()
    ..id = 3
    ..wordTitle = "Meticulous"
    ..wordForm = "Adjective"
    ..phraseTitle = "He is meticulous about details."
    ..wordDefinition = "Showing great attention to detail."
    ..fluencyLevel = 1
    ..URL = "https://example.com/meticulous"
    ..soundUrl = "https://example.com/sounds/meticulous.mp3",
  Vocabulary()
    ..id = 4
    ..wordTitle = "Candid"
    ..wordForm = "Adjective"
    ..phraseTitle = "She was candid about her mistakes."
    ..wordDefinition = "Truthful and straightforward."
    ..fluencyLevel = 10
    ..URL = "https://example.com/candid"
    ..soundUrl = "https://example.com/sounds/candid.mp3",
];

const level1Count = 6;
const level2Count = 3;
const level3Count = 1;

const wordMatchingTimeLimit = 60;
const multipleChoiceTimeLimit = 30;
const spellingTimeLimit = 30;

class QuizzesScreen extends StatefulWidget {
  const QuizzesScreen({super.key});

  @override
  State<QuizzesScreen> createState() => _QuizzesScreenState();
}

class _QuizzesScreenState extends State<QuizzesScreen> {
  bool _isQuizReady = false;
  Random random = Random();

  late List<Vocabulary> wordList;

  List<MultipleChoiceLesson> multipleChoiceLessons = [];
  List<WordMatchingLesson> wordMatchingLessons = [];
  List<SpellingLesson> spellingLessons = [];
  List<Object> finalLessons = [];

  late DatabaseHelper databaseHelper;

  @override
  void initState() {
    //todo dummy object
    WordMatchingLesson wordMatchingLesson = WordMatchingLesson();
    wordMatchingLesson.words = vocabList;
    wordMatchingLessons.add(wordMatchingLesson);

    // TODO: implement initState
    super.initState();
    databaseHelper = Provider.of<DatabaseHelper>(context, listen: false);
    initQuizzes();
  }

  void initQuizzes() {
    //todo get practice word, user need to get at least 4 added word to continue
    //todo create lesson for each word maximum 10 words

    //todo initiate practice lesson for each game,
    //todo make a list for each game, may be nested list
    //List [multipleChoiceLessons]

    //when the quiz is ready, start the quiz screen
    setState(() {
      _isQuizReady = true;
    });
  }

  void initLesson() {
    for (int i = 0; i < 4; i++) {
      if (i == 3) {
        initQuiz();
        continue;
      }
      initQuiz();
      initWordMatching();
      initSpelling();
    }
  }

  void initQuiz() {}

  void initWordMatching() {}

  void initSpelling() {}

  List<Vocabulary> pickRandom(List<Vocabulary> source, int count) {
    List<Vocabulary> picked = [];
    for (int i = 0; i < count && source.isNotEmpty; i++) {
      int index = random.nextInt(source.length);
      picked.add(source.removeAt(index));
    }
    return picked;
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

    wordList.addAll(pickRandom(level1Words, level1Count));
    wordList.addAll(pickRandom(level2Words, level2Count));
    wordList.addAll(pickRandom(level3Words, level3Count));

    int remaining = 10 - wordList.length;
    if (remaining > 0) {
      List<Vocabulary> extraElements = [
        ...level2Words,
        ...level3Words,
        ...level1Words
      ];
      wordList.addAll(pickRandom(extraElements, remaining));
    }
  }

  void onNextPressed() {
    //todo move to the next question
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text("3/10"),
        actions: [Text("Skip   ")],
      ),
      body: SpellCheckScreen(
        word: vocabList[1],
        onSubmit: (isCorrect) {},
      ),
    );
  }
}

class SpellCheckScreen extends StatefulWidget {
  SpellCheckScreen({super.key, required this.word, required this.onSubmit});
  Vocabulary word;
  Function(bool isCorrect) onSubmit;

  @override
  State<SpellCheckScreen> createState() => _SpellCheckScreenState();
}

class _SpellCheckScreenState extends State<SpellCheckScreen> {
  int _attempt = 3;
  late String _input;
  bool _canSubmit = false;

  TextEditingController _textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    PlaySound.playSoundFromURL(widget.word.soundUrl!);
  }

  void checkAnswer() {
    if (_input == widget.word.wordTitle.toUpperCase()) {
      PlaySound.playAssetSound("assets/sounds/right.mp3");
      widget.onSubmit(true);
    } else {
      _attempt--;
      PlaySound.playAssetSound("assets/sounds/wrong.mp3");
      _textEditingController.clear();
      if (_attempt <= 0) {
        widget.onSubmit(false);
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
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: Constant.kMarginLarge),
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
                      startTime: spellingTimeLimit, onTimesUp: onTimesUp),
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
                            borderRadius:
                                BorderRadius.circular(Constant.kMarginSmall))),
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
    );
  }
}
