import 'dart:async';

import 'package:eng_dict/view/screens/word_scramble_screen.dart';
import 'package:eng_dict/view/utils/constants.dart';
import 'package:flutter/material.dart';

class WordScrambleSelectScreen extends StatefulWidget {
  const WordScrambleSelectScreen({super.key});

  @override
  State<WordScrambleSelectScreen> createState() =>
      _WordScrambleSelectScreenState();
}

class _WordScrambleSelectScreenState extends State<WordScrambleSelectScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Word Scramble"),
      ),
      body: SafeArea(
          child: Padding(
        padding:
            const EdgeInsets.symmetric(horizontal: Constant.kMarginExtraLarge),
        child: StartScreen(),
      )),
    );
  }
}

enum ScrambleDifficulty { easy, medium, hard }

class StartScreen extends StatefulWidget {
  StartScreen({super.key});

  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  bool showHint = true;
  ScrambleDifficulty difficulty = ScrambleDifficulty.easy;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Text(
                "Show hint",
                style: Constant.kHeadingTextStyle,
              ),
              const Expanded(child: SizedBox()),
              Switch(
                activeTrackColor: Constant.kPrimaryColor,
                value: showHint,
                onChanged: (value) {
                  setState(() {
                    showHint = value;
                  });
                },
              )
            ],
          ),
          Text(
            "Time",
            style: Constant.kHeadingTextStyle,
          ),
          DifficultyBox(
            onChange: (value) {
              difficulty = value;
            },
          ),
          const SizedBox(
            height: 50,
          ),
          SizedBox(
            width: double.infinity,
            child: Center(
              child: TextButton(
                  style: TextButton.styleFrom(
                      backgroundColor: Constant.kPrimaryColor,
                      foregroundColor: Colors.grey,
                      padding: const EdgeInsets.symmetric(
                          vertical: 0, horizontal: 40),
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                              Radius.circular(Constant.kMarginSmall)))),
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => WordScrambleScreen(
                              showHint: showHint, difficulty: difficulty),
                        ));
                  },
                  child: Text(
                    "Start",
                    style:
                        Constant.kHeadingTextStyle.apply(color: Colors.white),
                  )),
            ),
          )
        ],
      ),
    );
  }
}

class DifficultyBox extends StatefulWidget {
  final Function(ScrambleDifficulty) onChange;

  const DifficultyBox({super.key, required this.onChange});

  @override
  State<DifficultyBox> createState() => _DifficultyBoxState();
}

class _DifficultyBoxState extends State<DifficultyBox> {
  ScrambleDifficulty _selectedDifficulty = ScrambleDifficulty.easy;

  void _onDifficultySelected(ScrambleDifficulty difficulty) {
    setState(() {
      _selectedDifficulty = difficulty;
    });
    widget.onChange(difficulty);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
          child: DifficultyItem(
              isSelected: _selectedDifficulty == ScrambleDifficulty.easy,
              title: "45s",
              borderColor: Constant.kGreenIndicatorColor,
              onTap: () => _onDifficultySelected(ScrambleDifficulty.easy)),
        ),
        Expanded(
          child: DifficultyItem(
              isSelected: _selectedDifficulty == ScrambleDifficulty.medium,
              title: "30s",
              borderColor: Constant.kYellowIndicatorColor,
              onTap: () => _onDifficultySelected(ScrambleDifficulty.medium)),
        ),
        Expanded(
          child: DifficultyItem(
              isSelected: _selectedDifficulty == ScrambleDifficulty.hard,
              title: "20s",
              borderColor: Constant.kRedIndicatorColor,
              onTap: () => _onDifficultySelected(ScrambleDifficulty.hard)),
        ),
      ],
    );
  }
}

class DifficultyItem extends StatelessWidget {
  final String title;
  final Color borderColor;
  final bool isSelected;
  final VoidCallback onTap;

  const DifficultyItem(
      {required this.isSelected,
      required this.title,
      required this.borderColor,
      required this.onTap,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Constant.kMarginSmall),
      child: TextButton(
        style: TextButton.styleFrom(
            backgroundColor: isSelected ? borderColor : Colors.transparent,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(Constant.kMarginSmall),
                side: BorderSide(color: borderColor))),
        onPressed: onTap,
        child: Center(
          child: Text(
            title,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.white : Constant.kLightGreyText,
                fontSize: 16),
          ),
        ),
      ),
    );
  }
}
