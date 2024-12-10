
import 'package:eng_dict/model/word.dart';

class WordForm{
  String? _formTitle;
  String? _ukIPA;
  String? _ukIPASoundURL;
  String? _usIPA;
  String? _usIPASoundURL;
  late Word _word;

  WordForm();


  String? get formTitle => _formTitle;

  set formTitle(String? value) {
    _formTitle = value;
  }

  String? get ukIPA => _ukIPA;

  set ukIPA(String? value) {
    _ukIPA = value;
  }

  String? get usIPA => _usIPA;

  set usIPA(String? value) {
    _usIPA = value;
  }

  String? get usIPASoundURL => _usIPASoundURL;

  set usIPASoundURL(String? value) {
    _usIPASoundURL = value;
  }

  String? get ukIPASoundURL => _ukIPASoundURL;

  set ukIPASoundURL(String? value) {
    _ukIPASoundURL = value;
  }

  Word get word => _word;

  set word(Word value) {
    _word = value;
  }
}