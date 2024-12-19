class SuggestedWord {
  late String wordTitle;
  late String url;

  SuggestedWord();

  factory SuggestedWord.fromJson(Map<String, dynamic> json) {
    return SuggestedWord()
      ..wordTitle = json['word']
      ..url = json['url'];
  }
}
