import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:eng_dict/model/word_field.dart';

class RequestHandler {
  late Uri URL;

  Future<List<WordField>> getWordData(String word) async {
    List<WordField> wordFields = [];
    URL = Uri.parse("http://172.20.10.2:8080/dictionary/$word");
    var response = await http.get(URL);

    int responseCode = response.statusCode;
    final contentType = response.headers['content-type'];
    print(contentType);
    log(response.body);
    if (responseCode == HttpStatus.ok) {
      List<dynamic> jsonResult = jsonDecode(response.body);

      wordFields = jsonResult
          .map(
            (e) => WordField.fromJson(e),
          )
          .toList();
    }
    print(wordFields[0].wordForms?[0].ukIPA);
    return wordFields;
  }
}
