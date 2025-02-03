import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';

import '../../networking/request_handler.dart';

class PlaySound {
  static Future<void> playSoundFromURL(String url) async {
    final AudioPlayer audioPlayer = AudioPlayer();
    if (Platform.isIOS) {
      _playSoundOnIOS(audioPlayer, url);
    } else {
      _playSoundOnAndroid(audioPlayer, url);
    }
  }

  static Future<void> _playSoundOnIOS(audioPlayer, soundURL) async {
    try {
      await audioPlayer.setUrl(soundURL);
      await audioPlayer.play();
      await audioPlayer.dispose();
    } on PlayerException catch (e) {
      if (kDebugMode) {
        print(e.message);
      }
    }
  }

  static Future<void> _playSoundOnAndroid(audioPlayer, soundURL) async {
    String filePath = await RequestHandler.downloadSoundForAndroid(soundURL);

    try {
      await audioPlayer.setAudioSource(AudioSource.uri(Uri.file(filePath)));
      await audioPlayer.play();
      debugPrint("Playing audio");

      await audioPlayer.processingStateStream.firstWhere(
        (element) => element == ProcessingState.completed,
      );

      final file = File(filePath);
      if (await file.exists()) {
        await file.delete();
        debugPrint("file deleted: $filePath");
      }
    } catch (e) {
      debugPrint("Playback error: $e");
    }
  }

  static Future<void> playAssetSound(String path) async {
    final AudioPlayer audioPlayer = AudioPlayer();

    try {
      await audioPlayer.setAsset(path);
      await audioPlayer.play();
      await audioPlayer.dispose();
    } on PlayerException catch (e) {
      if (kDebugMode) {
        print(e.message);
      }
    }
  }
}
