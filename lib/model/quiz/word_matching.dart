import 'package:eng_dict/model/quiz/lesson.dart';
import 'package:eng_dict/model/vocabulary.dart';

class WordMatchingLesson implements Lesson {
  List<Vocabulary> _words = [];

  Map<int, int> connections = {};
  MapEntry<int, int>? currentConnection;

  WordMatchingLesson();

  void insertWord(Vocabulary insertingWord) {
    _words.forEach(
      (element) {
        if (insertingWord.wordTitle == element.wordTitle) {
          return;
        }
      },
    );

    _words.add(insertingWord);
  }

  @override
  List<WordMatchingLesson> generateLesson() {
    return [];
  }

  List<Vocabulary> get words => _words;

  set words(List<Vocabulary> value) {
    _words = value;
  }
}
