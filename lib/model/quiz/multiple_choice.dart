import 'package:eng_dict/model/quiz/lesson.dart';
import 'package:eng_dict/model/quiz/spelling.dart';
import 'package:eng_dict/model/vocabulary.dart';

class MultipleChoiceLesson implements Lesson {
  List<String> _words = [];
  Vocabulary correctWord;

  MultipleChoiceLesson({required this.correctWord});

  void insertWord(String insertingWord) {
    if (insertingWord == correctWord.wordTitle) {
      return;
    }
    _words.add(insertingWord);
  }

  List<String> get words => _words;

  @override
  List<MultipleChoiceLesson> generateLesson() {
    return [];
  }
}
