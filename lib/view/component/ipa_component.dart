import 'package:eng_dict/view/utils/constants.dart';
import 'package:eng_dict/view/utils/custom_icon.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class IPABox extends StatelessWidget {
  bool canPlay = false;
  final String accent;
  final String IPA;
  final String? soundURL;

  IPABox({super.key, this.soundURL, required this.accent, required this.IPA}) {
    if (soundURL != null) {
      canPlay = true;
    }
  }

  Future<void> playSound() async {
    if (soundURL == null) {
      return;
    }
    final AudioPlayer audioPlayer = AudioPlayer();
    try {
      await audioPlayer.setUrl(soundURL!);
      await audioPlayer.play();
      await audioPlayer.dispose();
    } on PlayerException catch (e) {
      if (kDebugMode) {
        print(e.message);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return canPlay || IPA.isNotEmpty
        ? GestureDetector(
      onTap: () async {
        if (canPlay) {
          await playSound();
        }
      },
      child: Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          const CircleAvatar(
            backgroundColor: Color(0xffe3e3e3),
            radius: 13,
            child: Icon(
              CustomIcon.speaker,
              color: Constant.kPrimaryColor,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: Constant.kMarginSmall),
            child: Text(
              accent,
              style: const TextStyle(
                  color: Constant.kPrimaryColor,
                  fontSize: 16,
                  fontFamily: "Inter"),
            ),
          ),
          Text(
            IPA,
            style: const TextStyle(
                color: Constant.kPrimaryColor,
                fontSize: 16,
                fontFamily: "Inter"),
          )
        ],
      ),
    )
        : const SizedBox();
  }
}
