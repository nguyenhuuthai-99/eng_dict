import 'package:eng_dict/view/screens/word_scramble_start_screen.dart';
import 'package:eng_dict/view/utils/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class WordScrambleScreen extends StatefulWidget {
  bool showHint;
  ScrambleDifficulty difficulty;
  WordScrambleScreen(
      {super.key, required this.showHint, required this.difficulty});

  @override
  State<WordScrambleScreen> createState() => _WordScrambleScreenState();
}

class _WordScrambleScreenState extends State<WordScrambleScreen> {
  bool isLoading = false;
  Color alarmColor = Constant.kGreenDotColor;
  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          )
        : Scaffold(
            appBar: AppBar(
              title: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    CupertinoIcons.alarm,
                    color: alarmColor,
                  ),
                  Text(
                    " 00:30",
                    style: GoogleFonts.chivoMono(color: alarmColor),
                  )
                ],
              ),
              actions: [
                IconButton(onPressed: () {}, icon: Icon(Icons.pause_outlined))
              ],
            ),
          );
  }
}
