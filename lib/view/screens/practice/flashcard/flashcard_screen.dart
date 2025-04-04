import 'package:eng_dict/view/utils/constants.dart';
import 'package:flutter/material.dart';

import '../../../../model/vocabulary.dart';

Vocabulary vocabulary = Vocabulary()
  ..wordForm = "adjective"
  ..wordTitle = "remarkable"
  ..wordDefinition =
      'this is the definition that you are looking for, please read it carefully before proceed to the next word';

class FlashcardScreen extends StatefulWidget {
  const FlashcardScreen({super.key});

  @override
  State<FlashcardScreen> createState() => _FlashcardScreenState();
}

class _FlashcardScreenState extends State<FlashcardScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Padding(
        padding:
            const EdgeInsets.symmetric(horizontal: Constant.kMarginExtraLarge),
        child: Column(
          children: [
            const Expanded(child: SizedBox()),
            FlashCard(
              vocabulary: vocabulary,
            ),
            const Expanded(child: SizedBox()),
            const Row(
              children: [
                Text(
                  "I know it",
                  style: Constant.kHeading2TextStyle,
                ),
                Expanded(child: SizedBox()),
                Text(
                  "I forgot",
                  style: Constant.kHeading2TextStyle,
                )
              ],
            )
          ],
        ),
      )),
    );
  }
}

class FlashCard extends StatefulWidget {
  final Vocabulary vocabulary;

  const FlashCard({
    required this.vocabulary,
    super.key,
  });
  @override
  State<FlashCard> createState() => _FlashCardState();
}

class _FlashCardState extends State<FlashCard> {
  bool _isTap = false;

  void onTap() {
    setState(() {
      _isTap = !_isTap;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        color: Constant.kGreyBackground,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 80),
            child: _isTap ? const FrontFlashCard() : const BackFlashCard(),
          ),
        ),
      ),
    );
  }
}

class BackFlashCard extends StatelessWidget {
  const BackFlashCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Text("This is the deffinition for the word you looking for");
  }
}

class FrontFlashCard extends StatelessWidget {
  const FrontFlashCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          "adjective",
          style: Constant.kHeading2TextStyle,
        ),
        Text(
          "remarkable",
          style: Constant.kHeadingTextStyle,
        ),
      ],
    );
  }
}
