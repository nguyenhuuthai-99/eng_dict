class Vocabulary {
  late int _id;
  late String _wordTitle;
  late String _wordForm;
  late String _phraseTitle;
  late String _wordDefinition;
  late int fluencyLevel;
  late String _URL;
  late String? _soundUrl;

  Vocabulary();

  Vocabulary.fromMap(Map<String, dynamic> map) {
    id = map["id"];
    wordTitle = map["word_title"];
    wordForm = map["word_form"];
    phraseTitle = map["phrase_title"];
    wordDefinition = map["word_definition"];
    fluencyLevel = map["fluency_level"];
    URL = map['url'];
    soundUrl = map['sound_url'];
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "word_title": wordTitle,
      "word_form": wordForm,
      "phrase_title": phraseTitle,
      "word_definition": wordDefinition,
      "fluency_level": fluencyLevel,
      "url": URL,
      "sound_url": soundUrl
    };
  }

  int get id => _id;

  set id(int value) {
    _id = value;
  }

  String get phraseTitle => _phraseTitle;

  set phraseTitle(String value) {
    _phraseTitle = value;
  }

  String get wordTitle => _wordTitle;

  set wordTitle(String value) {
    _wordTitle = value;
  }

  String get wordForm => _wordForm;

  String get URL => _URL;

  set URL(String value) {
    _URL = value;
  }

  String get definition => _wordDefinition;

  set definition(String value) {
    _wordDefinition = value;
  }

  set wordForm(String value) {
    _wordForm = value;
  }

  String get wordDefinition => _wordDefinition;

  set wordDefinition(String value) {
    _wordDefinition = value;
  }

  String? get soundUrl => _soundUrl;

  set soundUrl(String? value) {
    _soundUrl = value;
  }
}
