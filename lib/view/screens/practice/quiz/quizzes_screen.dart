import 'dart:math';

import 'package:eng_dict/model/quiz/multiple_choice.dart';
import 'package:eng_dict/model/quiz/spelling.dart';
import 'package:eng_dict/model/quiz/word_matching.dart';
import 'package:eng_dict/model/vocabulary.dart';
import 'package:eng_dict/networking/database_helper.dart';
import 'package:eng_dict/view/screens/practice/quiz/multiple_choice.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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

  late List<Vocabulary> vocabularies;

  List<MultipleChoiceLesson> multipleChoiceLessons = [];
  List<WordMatchingLesson> wordMatchingLessons = [];
  List<SpellingLesson> spellingLessons = [];
  List<Object> generatedLessons = [];
  int currentLessonIndex = 0;

  late DatabaseHelper databaseHelper;

  @override
  void initState() {
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
    Random random = Random();
    List<Vocabulary> picked = [];
    for (int i = 0; i < count && source.isNotEmpty; i++) {
      int index = random.nextInt(source.length);
      picked.add(source.removeAt(index));
    }
    return picked;
  }

  Future<void> initWords() async {
    databaseHelper = Provider.of<DatabaseHelper>(context, listen: false);

    List<Vocabulary> level1Words =
        await databaseHelper.getVocabularyOnLevel(VocabularyLevel.unfamiliar);
    List<Vocabulary> level2Words =
        await databaseHelper.getVocabularyOnLevel(VocabularyLevel.familiar);
    List<Vocabulary> level3Words =
        await databaseHelper.getVocabularyOnLevel(VocabularyLevel.mastered);

    vocabularies.addAll(pickRandom(level1Words, level1Count));
    vocabularies.addAll(pickRandom(level2Words, level2Count));
    vocabularies.addAll(pickRandom(level3Words, level3Count));

    int remaining = 10 - vocabularies.length;
    if (remaining > 0) {
      List<Vocabulary> extraElements = [
        ...level2Words,
        ...level3Words,
        ...level1Words
      ];
      vocabularies.addAll(pickRandom(extraElements, remaining));
    }
  }

  void onNextPressed() {
    //todo move to the next question
    setState(() {
      currentLessonIndex++;
    });
  }

  void onSubmit(bool isCorrect){

  }

  Widget pickLesson(){
    Object currenLesson = generatedLessons[currentLessonIndex];
    if(currenLesson == MultipleChoiceLesson){
      currenLesson as MultipleChoiceLesson;
      return MultipleChoiceScreen(timeLimit: multipleChoiceTimeLimit, words: currenLesson.words, testingWord: currenLesson.testingWord, onSubmit: onSubmit, onNextPressed: onNextPressed)
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text("3/10"),
        actions: [Text("Skip   ")],
      ),
      body: generatedLessons[currentLessonIndex],
    );
  }
}
