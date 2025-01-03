import 'package:eng_dict/view/utils/constants.dart';
import 'package:eng_dict/view/utils/custom_icon.dart';
import 'package:eng_dict/view/widgets/youglish_web_view.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

import '../../model/word_form.dart';

class WordTitleBox extends StatelessWidget {
  WordForm? wordForm;

  WordTitleBox({
    required this.wordForm,
    super.key,
  }) {}

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Constant.kGreyBackground,
      child: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: 20, vertical: Constant.kMarginSmall),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: Constant.kMarginSmall),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    wordForm?.words?[0].wordTitle != null
                        ? wordForm!.words![0].wordTitle!
                        : "",
                    style: TextStyle(
                        fontSize: 24,
                        color: Colors.black.withOpacity(0.9),
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    width: Constant.kMarginExtraSmall,
                  ),
                  Text(
                    wordForm?.formTitle != null ? wordForm!.formTitle! : "",
                    style: const TextStyle(
                        color: Constant.kGreyText,
                        fontStyle: FontStyle.italic,
                        fontSize: 15),
                  )
                ],
              ),
            ),
            Wrap(
              spacing: 20, // Space between children
              runSpacing: 8.0, // Space between rows
              children: [
                if (wordForm?.usIPASoundURL != null || wordForm?.usIPA != null)
                  IPABox(
                    IPA: wordForm?.usIPA != null ? wordForm!.usIPA! : "",
                    accent: "US",
                    soundURL: wordForm?.usIPASoundURL,
                  ),
                IPABox(
                  IPA: wordForm?.ukIPA != null ? wordForm!.ukIPA! : "",
                  accent: "UK",
                  soundURL: wordForm?.ukIPASoundURL,
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(
                  top: Constant.kMarginExtraSmall, left: 1),
              child: GestureDetector(
                onTap: () {
                  if (wordForm?.words?[0].wordTitle != null) {
                    youglishButtonTapped(
                        context: context, word: wordForm!.words![0].wordTitle!);
                  }
                },
                child: const Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      CustomIcon.video,
                      color: Constant.kPrimaryColor,
                      size: 22,
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 2.0),
                      child: Text(
                        "  Youglish ",
                        style: TextStyle(
                            color: Constant.kPrimaryColor, fontSize: 16),
                      ),
                    ),
                    Tooltip(
                      preferBelow: false,
                      verticalOffset: 10,
                      triggerMode: TooltipTriggerMode.tap,
                      message: "Real-world pronunciation in context.",
                      child: Icon(
                        Icons.help_outline,
                        size: 17,
                        color: Colors.grey,
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void youglishButtonTapped(
      {required BuildContext context, required String word}) async {
    showModalBottomSheet(
      enableDrag: false,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      context: context,
      builder: (context) {
        return YouglishWebView(word: word);
      },
    );
  }
}

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
