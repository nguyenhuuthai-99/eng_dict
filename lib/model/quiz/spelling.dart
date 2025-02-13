import 'package:eng_dict/model/quiz/lesson.dart';
import 'package:eng_dict/model/vocabulary.dart';
import 'package:eng_dict/networking/database_helper.dart';

class SpellingLesson implements Lesson {
  Vocabulary word;

  SpellingLesson({required this.word});

  @override
  List<SpellingLesson> generateLesson() {
    // TODO: implement generateLesson
    throw UnimplementedError();
  }
}
