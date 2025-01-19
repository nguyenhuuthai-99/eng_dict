class LinkedWord {
  late String _title;
  String? _usage;
  String? _justification;
  String? _form;
  late String _url;

  LinkedWord();

  factory LinkedWord.fromJson(Map<String, dynamic> json) {
    return LinkedWord()
      .._title = json['title']
      .._usage = json["usage"]
      .._justification = json['justification']
      .._form = json['form']
      .._url = json['url'];
  }

  String get title => _title;

  set title(String value) {
    _title = value;
  }

  String? get usage => _usage;

  String get url => _url;

  set url(String value) {
    _url = value;
  }

  String? get form => _form;

  set form(String? value) {
    _form = value;
  }

  String? get justification => _justification;

  set justification(String? value) {
    _justification = value;
  }

  set usage(String? value) {
    _usage = value;
  }
}
