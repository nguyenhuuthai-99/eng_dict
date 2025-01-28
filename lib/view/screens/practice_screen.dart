import 'package:eng_dict/view/screens/word_scramble_start_screen.dart';
import 'package:eng_dict/view/widgets/practice_section_box.dart';
import 'package:flutter/material.dart';

class PracticeScreen extends StatelessWidget {
  final String screenId = "PracticeScreen";
  const PracticeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Practice"),
      ),
      body: Center(
        child: ListView(
          children: [
            PracticeSectionBox(
              title: "Word Scramble",
              nextScreen: WordScrambleSelectScreen(),
              subTitle: "Fix the mix, master your spelling",
              image: const AssetImage("assets/images/scramble.png"),
            ),
            PracticeSectionBox(
              title: "Word Board",
              nextScreen: const WordScrambleSelectScreen(),
              subTitle: "Beat the board, refine your vocabulary",
              image: const AssetImage("assets/images/word_board.png"),
            ),
            PracticeSectionBox(
              title: "Quizzes",
              nextScreen: WordScrambleSelectScreen(),
              subTitle: "Test your knowledge and beat the clock",
              image: const AssetImage("assets/images/practice.png"),
            ),
            PracticeSectionBox(
              title: "Flashcard",
              nextScreen: WordScrambleSelectScreen(),
              subTitle: "Flip, remember, and level up your vocabulary",
              image: const AssetImage("assets/images/flashcard.png"),
            ),
          ],
        ),
      ),
    );
  }
}
