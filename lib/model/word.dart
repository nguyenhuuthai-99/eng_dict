
class Word{
  String? _wordTitle;
  String? _wordForm;
  late bool isPhrase;
  String? _phraseTitle;
  String? _usage;
  String? _level;
  late String _definition;
  List<String>? _examples;
  late String _url;



  String? get wordTitle => _wordTitle;

  set wordTitle(String? value) {
    _wordTitle = value;
  }

  String? get wordForm => _wordForm;

  String get url => _url;

  set url(String value) {
    _url = value;
  }

  List<String>? get examples => _examples;

  set examples(List<String>? value) {
    _examples = value;
  }

  String get definition => _definition;

  set definition(String value) {
    _definition = value;
  }

  String? get level => _level;

  set level(String? value) {
    _level = value;
  }

  String? get usage => _usage;

  set usage(String? value) {
    _usage = value;
  }

  String? get phraseTitle => _phraseTitle;

  set phraseTitle(String? value) {
    _phraseTitle = value;
  }

  set wordForm(String? value) {
    _wordForm = value;
  }

}