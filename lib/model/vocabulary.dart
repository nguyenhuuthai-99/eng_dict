class Vocabulary {
  late String _wordTitle;
  late String _wordForm;
  late String _definition;
  late String _URL;

  String get wordTitle => _wordTitle;

  set wordTitle(String value) {
    _wordTitle = value;
  }

  String get wordForm => _wordForm;

  String get URL => _URL;

  set URL(String value) {
    _URL = value;
  }

  String get definition => _definition;

  set definition(String value) {
    _definition = value;
  }

  set wordForm(String value) {
    _wordForm = value;
  }
}
