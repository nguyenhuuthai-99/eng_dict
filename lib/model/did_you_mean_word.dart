class DidYouMeanWord {
  late String _title;
  late String _url;

  DidYouMeanWord();

  factory DidYouMeanWord.fromJson(Map<String, dynamic> json) {
    return DidYouMeanWord()
      .._title = json['title']
      .._url = json['url'];
  }

  String get title => _title;

  set title(String value) {
    _title = value;
  }

  String get url => _url;

  set url(String value) {
    _url = value;
  }
}
