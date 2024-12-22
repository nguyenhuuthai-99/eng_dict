import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:eng_dict/model/suggested_word.dart';
import 'package:http/http.dart' as http;
import 'package:eng_dict/model/word_field.dart';

class RequestHandler {
  late Uri URL;

  Future<List<WordField>> getWordData(String word) async {
    List<WordField> wordFields = [];
    URL = Uri.parse("http://10.0.2.2:8080/dictionary/$word");
    var response = await http.get(URL);

    int responseCode = response.statusCode;
    log(response.body);
    if (responseCode == HttpStatus.ok) {
      List<dynamic> jsonResult = jsonDecode(response.body);

      wordFields = jsonResult
          .map(
            (e) => WordField.fromJson(e),
          )
          .toList();
    }
    return wordFields;
  }

  Future<List<SuggestedWord>> getSuggestedWord(String prefix) async {
    List<SuggestedWord> suggestedWords = [];

    URL = Uri.parse(
        "https://dictionary.cambridge.org/autocomplete/amp?dataset=english&q=$prefix");

    final headers = {
      "User-Agent":
          "Mozilla/5.0 (Windows NT 10.0; Win64; x64) Chrome/91.0.4472.124"
    };

    var response = await http.get(URL, headers: headers);

    int responseCode = response.statusCode;
    if (responseCode == HttpStatus.ok) {
      List<dynamic> jsonResult = jsonDecode(response.body);
      suggestedWords = jsonResult
          .map(
            (e) => SuggestedWord.fromJson(e),
          )
          .toList();
    }
    return suggestedWords;
  }

  static String buildYougLishHTML(String word) {
    return """<a id="yg-widget-0" class="youglish-widget" data-query="great%20power" data-lang="english" data-zones="all,us,uk,aus" data-components="8415" width="1000" data-bkg-color="theme_light"  rel="nofollow" href="https://youglish.com">Visit YouGlish.com</a>
<script async src="https://youglish.com/public/emb/widget.js" charset="utf-8"></script>""";
  }
}
