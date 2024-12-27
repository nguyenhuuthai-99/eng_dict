class SearchedWord {
  late int _id;
  late String wordTitle;
  late String url;

  SearchedWord({required this.wordTitle, required this.url});

  SearchedWord.fromMap(Map<String,dynamic> map){
    wordTitle = map['word_title'];
    url = map["url"];
  }

}
