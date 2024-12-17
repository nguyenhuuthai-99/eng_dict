import 'package:eng_dict/model/word_form.dart';

class WordField {
  String? _fieldTitle;
  List<WordForm>? _wordForms;

  WordField();

  factory WordField.fromJson(Map<String, dynamic> json) {
    return WordField()
      .._fieldTitle = json['']
      .._wordForms = (json['wordForms'] as List<WordForm>?)
          ?.map((e) => WordForm().fromJson(e))
          .toList();
    ;
  }

  List<WordForm>? get wordForms => _wordForms;

  set wordForms(List<WordForm>? value) {
    _wordForms = value;
  }

  String? get fieldTitle => _fieldTitle;

  set fieldTitle(String? value) {
    _fieldTitle = value;
  }
}
