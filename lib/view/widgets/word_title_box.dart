import 'package:eng_dict/view/utils/constants.dart';
import 'package:eng_dict/view/utils/custom_icon.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class WordTitleBox extends StatelessWidget {
  const WordTitleBox({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Constant.kGreyBackground,
      child: Padding(
        padding: EdgeInsets.symmetric(
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
                    "Sophisticate",
                    style: TextStyle(
                        fontSize: 24,
                        color: Colors.black.withOpacity(0.9),
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    width: Constant.kMarginExtraSmall,
                  ),
                  Text(
                    "noun",
                    style: TextStyle(
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
                IPABox(IPA: "/səsufiwis/", accent: "UK"),
                IPABox(IPA: "/səˈfɪs.tɪ.kət/", accent: "US"),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(
                  top: Constant.kMarginExtraSmall, left: 1),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    CustomIcon.video,
                    color: Constant.kPrimaryColor,
                    size: 22,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 2.0),
                    child: Text(
                      "  Youglish ",
                      style: TextStyle(
                          color: Constant.kPrimaryColor, fontSize: 16),
                    ),
                  ),
                  Icon(
                    Icons.help_outline,
                    size: 17,
                    color: Colors.grey,
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class IPABox extends StatelessWidget {
  bool canPlay = false;
  final String accent;
  final String IPA;
  String? soundURL;

  IPABox({this.soundURL, required this.accent, required this.IPA}) {
    if (soundURL != null) {
      canPlay = true;
    }
  }

  Future<void> playSound() async {
    final AudioPlayer audioPlayer = AudioPlayer();
    String prefix = "https://dictionary.cambridge.org/";
    String url = prefix + soundURL!;
    try {
      await audioPlayer.setUrl(url);
      await audioPlayer.play();
      await audioPlayer.dispose();
    } on PlayerException catch (e) {
      print(e.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        print("ádfasdf");
        if (canPlay) {
          await playSound();
        }
      },
      child: Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          CircleAvatar(
            child: Icon(
              CustomIcon.speaker,
              color: Constant.kPrimaryColor,
            ),
            backgroundColor: Color(0xffe3e3e3),
            radius: 13,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: Constant.kMarginSmall),
            child: Text(
              accent,
              style: TextStyle(
                  color: Constant.kPrimaryColor,
                  fontSize: 16,
                  fontFamily: "Inter"),
            ),
          ),
          Text(
            IPA,
            style: TextStyle(
                color: Constant.kPrimaryColor,
                fontSize: 16,
                fontFamily: "Inter"),
          )
        ],
      ),
    );
  }
}