import 'dart:convert';
import 'dart:io';

import 'package:eng_dict/view/widgets/interstitial_ads_box.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:path_provider/path_provider.dart';

class ActionCounter {
  late int counter;

  Future<File> _getCounterFile() async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/counter.json');
  }

  Future<void> getCounter() async {
    try {
      final file = await _getCounterFile();
      if (await file.exists()) {
        final content = await file.readAsString();
        final data = jsonDecode(content);
        counter = data['counter'] ?? 0;
      } else {
        counter = 0;
        _saveCounter();
      }
      debugPrint("counter loaded $counter");
    } catch (e) {
      // Handle any errors
      print('Error loading counter: $e');
    }
  }

  Future<void> _saveCounter() async {
    try {
      final file = await _getCounterFile();
      final data = {'counter': counter};
      await file.writeAsString(jsonEncode(data));
    } catch (e) {
      // Handle any errors
      print('Error saving counter: $e');
    }
  }

  void incrementCounter() {
    counter++;
    _saveCounter();

    debugPrint(counter.toString());
    // // Show interstitial ad if divisible by 20
    if (counter % 20 == 0) {
      _showInterstitialAd();
    }
  }

  void _showInterstitialAd() async {
    InterstitialAdsBox interstitialAdsBox = InterstitialAdsBox();
    await interstitialAdsBox.loadAd();
  }
}
