import 'dart:convert';
import 'dart:io';
import 'package:eng_dict/model/did_you_mean_word.dart';
import 'package:flutter/cupertino.dart';
import "package:path_provider/path_provider.dart";
import 'package:eng_dict/model/suggested_word.dart';
import 'package:http/http.dart' as http;
import 'package:eng_dict/model/word_field.dart';

class RequestHandler {
  final String _domain = "https://engdictbackend-1.onrender.com";
  // final String _domain =
  //     Platform.isIOS ? "http://localhost:8080" : "http://10.0.2.2:8080";
  // final String _domain = "http://192.168.0.227:8080";

  late Uri URL;

  Future<List<WordField>> getWordData(String word) async {
    List<WordField> wordFields = [];
    URL = Uri.parse("$_domain/dictionary/$word");
    var response = await http.get(URL);

    int responseCode = response.statusCode;
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

  Future<List<WordField>> getWordDataFromSearch(String url) async {
    List<WordField> wordFields = [];
    URL = Uri.parse("$_domain/dictionary/suggested/")
        .replace(queryParameters: {"url": url});
    var response = await http.get(URL);

    int responseCode = response.statusCode;
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

  Future<List<WordField>> getWordDataFromURL(String url) async {
    List<WordField> wordFields = [];
    URL = Uri.parse("$_domain/dictionary/")
        .replace(queryParameters: {"url": url});
    var response = await http.get(URL);

    int responseCode = response.statusCode;
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

  Future<List<DidYouMeanWord>> getDidYouMeanWord(String prefix) async {
    List<DidYouMeanWord> didYouMeanWords = [];

    Uri url = Uri.parse("$_domain/spellcheck/$prefix");

    var response = await http.get(url);

    int responseCode = response.statusCode;

    if (responseCode == HttpStatus.ok) {
      List<dynamic> json = jsonDecode(response.body);

      didYouMeanWords = json
          .map(
            (e) => DidYouMeanWord.fromJson(e),
          )
          .toList();
    }
    return didYouMeanWords;
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
    return """
<html>
<head>
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
</head>
  <body>
    <!-- 1. The widget will replace this <div> tag. -->
    <div id="widget-1"></div>


    <script>
      // 2. This code loads the widget API code asynchronously.
      var tag = document.createElement('script');

      tag.src = "https://youglish.com/public/emb/widget.js";
      var firstScriptTag = document.getElementsByTagName('script')[0];
      firstScriptTag.parentNode.insertBefore(tag, firstScriptTag);

      // 3. This function creates a widget after the API code downloads.
      var widget;
      function onYouglishAPIReady(){
        widget = new YG.Widget("widget-1", {
          components:94, //search box & caption 
          events: {
            'onFetchDone': onFetchDone,
            'onVideoChange': onVideoChange,
            'onCaptionConsumed': onCaptionConsumed
          }          
        });
        // 4. process the query
        widget.fetch("$word","english");
      }


      var views = 0, curTrack = 0, totalTracks = 0;

      // 5. The API will call this method when the search is done
      function onFetchDone(event){
        if (event.totalResult === 0)   alert("No result found");
        else totalTracks = event.totalResult; 
      }

      // 6. The API will call this method when switching to a new video. 
      function onVideoChange(event){
        curTrack = event.trackNumber;
        views = 0;
      }

      // 7. The API will call this method when a caption is consumed. 
      function onCaptionConsumed(event){
        if (++views < 2)
          widget.replay();
        else 
          if (curTrack < totalTracks)  
            widget.next();
      }
    </script>
  </body>
</html>""";
  }

  static Future<String> downloadSoundForAndroid(String url) async {
    try {
      final response = await http.get(Uri.parse(url), headers: {
        'User-Agent':
            'Mozilla/5.0 (Linux; Android 13; Mobile) AppleWebKit/537.36 (KHTML, like Gecko) Mobile Safari/537.36'
      });

      //Get cache directory
      final directory = await getTemporaryDirectory();

      // file path to save mp3
      final filePath = '${directory.path}/ipa.mp3';

      //save the file
      final file = File(filePath);
      await file.writeAsBytes(response.bodyBytes);

      debugPrint("file downloaded to: $filePath");
      return filePath;
    } catch (e) {
      debugPrint("Download failed: $e");
      rethrow;
    }
  }
}
