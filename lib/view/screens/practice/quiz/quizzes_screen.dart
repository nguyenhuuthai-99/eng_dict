import 'dart:math';

import 'package:eng_dict/model/quiz/multiple_choice.dart';
import 'package:eng_dict/model/quiz/spelling.dart';
import 'package:eng_dict/model/quiz/word_matching.dart';
import 'package:eng_dict/model/vocabulary.dart';
import 'package:eng_dict/networking/database_helper.dart';
import 'package:eng_dict/view/screens/practice/quiz/multiple_choice.dart';
import 'package:eng_dict/view/screens/practice/quiz/spelling.dart';
import 'package:eng_dict/view/screens/practice/quiz/word_matching.dart';
import 'package:eng_dict/view/utils/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../component/animated_progression_indicator.dart';
import '../../../widgets/practice/quiz/circle_progression_box.dart';

const level1Count = 6;
const level2Count = 3;
const level3Count = 1;

const wordMatchingTimeLimit = 60;
const multipleChoiceTimeLimit = 30;
const spellingTimeLimit = 30;

const minimumVocabularyCount = 4;

class QuizzesScreen extends StatefulWidget {
  const QuizzesScreen({super.key});

  @override
  State<QuizzesScreen> createState() => _QuizzesScreenState();
}

class _QuizzesScreenState extends State<QuizzesScreen> {
  bool _isQuizReady = false;
  bool _isEnoughTestingWord = true;
  bool _isQuizFinished = false;

  List<Vocabulary> testingVocabularies = [];
  late List<Vocabulary> fetchedVocabularies;

  List<MultipleChoiceLesson> multipleChoiceLessons = [];
  List<WordMatchingLesson> wordMatchingLessons = [];
  List<SpellingLesson> spellingLessons = [];
  List<Object?> generatedLessons = [];
  int currentLessonIndex = 0;

  late DatabaseHelper databaseHelper;

  @override
  void initState() {
    super.initState();
    databaseHelper = Provider.of<DatabaseHelper>(context, listen: false);
    initQuizzes();
  }

  void initQuizzes() async {
    testingVocabularies = await fetchVocabularies();

    if (!canInitQuizzes(testingVocabularies)) {
      _isEnoughTestingWord = false;
    }

    initLesson();

    //when the quiz is ready, start the quiz screen
    setState(() {
      _isQuizReady = true;
    });
  }

  void initLesson() {
    for (int i = 0; i < testingVocabularies.length; i++) {
      if (i == 10) break;

      if ((i + 1) % 3 == 1) {
        generatedLessons.add(initMultipleChoice(testingVocabularies[i]));
      } else if ((i + 1) % 3 == 2) {
        generatedLessons.add(initWordMatching(testingVocabularies[i]));
      } else {
        generatedLessons.add(initSpelling(testingVocabularies[i]));
      }
    }
  }

  MultipleChoiceLesson? initMultipleChoice(Vocabulary vocabulary) {
    MultipleChoiceLesson multipleChoiceLesson =
        MultipleChoiceLesson(correctWord: vocabulary);

    var vocabulariesCopy = [...fetchedVocabularies];

    Random random = Random();

    Map<String, Vocabulary> selections = {};
    for (int i = 0; i < 3; i++) {
      bool isFound = false;
      var count = 0;
      while (!isFound) {
        if (count > 5) break;
        if (vocabulariesCopy.isNotEmpty) {
          int randomIndex = random.nextInt(vocabulariesCopy.length);
          final title = vocabulariesCopy[randomIndex].wordTitle;
          if (title != vocabulary.wordTitle && !selections.containsKey(title)) {
            selections[title] = vocabulariesCopy.removeAt(randomIndex);
            isFound = true;
          }
        }
        count++;
      }
    }

    selections.forEach(
      (key, value) => multipleChoiceLesson.insertWord(value),
    );
    if (multipleChoiceLesson.words.isEmpty) {
      return null;
    }
    return multipleChoiceLesson;
  }

  WordMatchingLesson initWordMatching(Vocabulary vocabulary) {
    WordMatchingLesson wordMatchingLesson = WordMatchingLesson();
    wordMatchingLesson.insertWord(vocabulary);

    Set<String> testingWords = {vocabulary.wordTitle};
    List<Vocabulary> vocabulariesCopy = [...fetchedVocabularies];
    Random random = Random();

    for (int i = 0; i < 3; i++) {
      bool isFound = false;
      var count = 0;
      while (!isFound) {
        if (count > 5) {
          break;
        }
        int randomIndex = random.nextInt(vocabulariesCopy.length);
        final title = vocabulariesCopy[randomIndex].wordTitle;
        if (!testingWords.contains(title)) {
          testingWords.add(title);
          wordMatchingLesson.insertWord(vocabulariesCopy.removeAt(randomIndex));
          isFound = true;
        }
        count++;
      }
    }
    return wordMatchingLesson;
  }

  SpellingLesson initSpelling(Vocabulary vocabulary) {
    SpellingLesson spellingLesson = SpellingLesson(word: vocabulary);
    return spellingLesson;
  }

  List<Vocabulary> pickRandom(List<Vocabulary> source, int count) {
    Random random = Random();
    List<Vocabulary> picked = [];
    for (int i = 0; i < count && source.isNotEmpty; i++) {
      int index = random.nextInt(source.length);
      picked.add(source.removeAt(index));
    }
    return picked;
  }

  Future<List<Vocabulary>> fetchVocabularies() async {
    List<Vocabulary> vocabularies = [];

    databaseHelper = Provider.of<DatabaseHelper>(context, listen: false);

    List<Vocabulary> level1Words =
        await databaseHelper.getVocabularyOnLevel(VocabularyLevel.unfamiliar);
    List<Vocabulary> level2Words =
        await databaseHelper.getVocabularyOnLevel(VocabularyLevel.familiar);
    List<Vocabulary> level3Words =
        await databaseHelper.getVocabularyOnLevel(VocabularyLevel.mastered);

    fetchedVocabularies = [...level2Words, ...level3Words, ...level1Words];

    vocabularies.addAll(pickRandom(level1Words, level1Count));
    vocabularies.addAll(pickRandom(level2Words, level2Count));
    vocabularies.addAll(pickRandom(level3Words, level3Count));

    int remaining = 10 - vocabularies.length;

    List<Vocabulary> remainingVocabularies = [
      ...level2Words,
      ...level3Words,
      ...level1Words
    ];
    if (remaining > 0) {
      vocabularies.addAll(pickRandom(remainingVocabularies, remaining));
    }
    return vocabularies;
  }

  bool canInitQuizzes(List<Vocabulary> vocabularies) {
    if (vocabularies.length < 4) {
      return false;
    } else {
      Set<String> distinctWords = {};

      vocabularies.forEach(
        (element) => distinctWords.add(element.wordTitle),
      );

      if (distinctWords.length < 4) {
        return false;
      } else {
        return true;
      }
    }
  }

  void onNextPressed() {
    setState(() {
      currentLessonIndex++;
      _isFinished();
    });
  }

  void _isFinished() {
    if (currentLessonIndex >= generatedLessons.length) {
      _isQuizFinished = true;
    }
  }

  void onSubmit(bool isCorrect) {}

  void onWordMatchingSubmit(
      List<Vocabulary> correctWords, List<Vocabulary> incorrectWords) {}

  Widget pickLesson() {
    if (currentLessonIndex >= generatedLessons.length)
      return Container(
        child: const Text("finished"),
      );

    Object? currentLesson = generatedLessons[currentLessonIndex];
    if (currentLesson == null) {
      currentLessonIndex++;
      pickLesson();
    }
    if (currentLesson is MultipleChoiceLesson) {
      return MultipleChoiceScreen(
          timeLimit: multipleChoiceTimeLimit,
          words: currentLesson.words,
          testingWord: currentLesson.correctWord,
          onSubmit: onSubmit,
          onNextPressed: onNextPressed);
    } else if (currentLesson is WordMatchingLesson) {
      return WordMatchingScreen(
          wordMatchingLesson: currentLesson,
          onSubmit: onWordMatchingSubmit,
          onNextPressed: onNextPressed,
          timeLimit: wordMatchingTimeLimit);
    } else {
      currentLesson as SpellingLesson;
      return SpellingLessonScreen(
          word: currentLesson.word,
          onNextPressed: onNextPressed,
          onSubmit: onSubmit,
          timeLimit: spellingTimeLimit);
    }
  }

  @override
  Widget build(BuildContext context) {
    return QuizResultScreen(
      correctQuizzes: [null, null, null],
      incorrectQuizzes: [null, null, null, null, null],
      testingQuizzes: testingVocabularies,
      numberOfQuizzes: 10,
    );
    return !_isQuizFinished
        ? Scaffold(
            resizeToAvoidBottomInset: true,
            appBar: _isEnoughTestingWord
                ? AppBar(
                    title: currentLessonIndex == testingVocabularies.length
                        ? null
                        : Text(
                            "${currentLessonIndex + 1}/${testingVocabularies.length}"),
                    actions: [
                      TextButton(
                          onPressed: onNextPressed,
                          child: const Text("Skip   "))
                    ],
                  )
                : AppBar(),
            body: _isQuizReady
                ? _isEnoughTestingWord
                    ? pickLesson()
                    : const InsufficientWordsScreen()
                : const Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircularProgressIndicator(),
                        Text("Retrieving user data")
                      ],
                    ),
                  ),
          )
        : QuizResultScreen(
            correctQuizzes: [],
            incorrectQuizzes: [],
            numberOfQuizzes: 10,
            testingQuizzes: []);
  }
}

class QuizResultScreen extends StatelessWidget {
  final List<Vocabulary?> correctQuizzes;
  final List<Vocabulary?> incorrectQuizzes;
  final List<Vocabulary> testingQuizzes;
  final int numberOfQuizzes;

  const QuizResultScreen({
    required this.correctQuizzes,
    required this.incorrectQuizzes,
    required this.numberOfQuizzes,
    required this.testingQuizzes,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Result"),
      ),
      body: SafeArea(
        child: Padding(
          padding:
              const EdgeInsets.symmetric(horizontal: Constant.kMarginMedium),
          child: ListView(
            children: [
              const SizedBox(
                height: Constant.kMarginMedium,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: Constant.kMarginExtraLarge),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    CircleProgressionIndicatorBox(
                        title: "Correct",
                        indicatorColor: Constant.kGreenIndicatorColor,
                        progression: correctQuizzes.length,
                        total: numberOfQuizzes),
                    CircleProgressionIndicatorBox(
                        title: "Incorrect",
                        indicatorColor: Constant.kRedIndicatorColor,
                        progression: incorrectQuizzes.length,
                        total: numberOfQuizzes)
                  ],
                ),
              ),
              ListView.builder(
                itemBuilder: (context, index) {
                  var curWord = testingQuizzes[index];
                  return Card(
                    color: Constant.kGreyBackground,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: Constant.kMarginExtraLarge,
                          vertical: Constant.kMarginLarge),
                      child: Row(
                        children: [
                          RichText(
                              text: TextSpan(children: [
                            TextSpan(
                              text: "${curWord.fluencyLevel}  ",
                              style: GoogleFonts.openSans(
                                  color: curWord.pickIndicatorColor(),
                                  fontWeight: FontWeight.w900,
                                  fontSize: 16),
                            ),
                            curWord.pickUpdatedSymbol(),
                          ])),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: Constant.kMarginMedium),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  curWord.wordTitle,
                                  style: Constant.kHeadingTextStyle,
                                ),
                                Text(
                                  curWord.wordForm,
                                  style: const TextStyle(
                                      color: Colors.black87,
                                      fontStyle: FontStyle.italic),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                },
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: testingQuizzes.length,
              )
            ],
          ),
        ),
      ),
    );
  }
}

class InsufficientWordsScreen extends StatelessWidget {
  const InsufficientWordsScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding:
            const EdgeInsets.symmetric(horizontal: Constant.kMarginExtraLarge),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Not enough saved words",
              style: Constant.kHeadingTextStyle,
            ),
            Text(
              "You need to have at least 4 distinct saved vocabularies to start practice quizzes. Please add more vocabulary and try later.",
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
