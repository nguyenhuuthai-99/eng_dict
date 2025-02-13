import 'package:eng_dict/model/quiz/lesson.dart';
import 'package:eng_dict/model/quiz/spelling.dart';
import 'package:eng_dict/model/vocabulary.dart';

class MultipleChoiceLesson implements Lesson {
  List<Vocabulary> _words = [];
  Vocabulary correctWord;

  MultipleChoiceLesson({required this.correctWord});

  void insertWord(Vocabulary insertingWord) {
    if (insertingWord.wordTitle == correctWord.wordTitle) {
      return;
    }
    _words.add(insertingWord);
  }

  @override
  List<MultipleChoiceLesson> generateLesson() {
    return [];
  }
}
