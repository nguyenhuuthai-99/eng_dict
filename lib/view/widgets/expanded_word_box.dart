import 'package:eng_dict/model/linked_word.dart';
import 'package:eng_dict/view/utils/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class ExpandedWordBox extends StatefulWidget {
  late String wordTitle;
  late String wordType;

  late List<LinkedWord> wordItems;
  ExpandedWordBox(
      {super.key,
      required this.wordTitle,
      required this.wordType,
      required this.wordItems});

  @override
  State<ExpandedWordBox> createState() => _ExpandedWordBoxState();
}

class _ExpandedWordBoxState extends State<ExpandedWordBox>
    with SingleTickerProviderStateMixin {
  bool _isExpand = true;
  late AnimationController animationController;
  late Animation<double> animation;

  void prepareAnimation() {
    animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    animation =
        CurvedAnimation(parent: animationController, curve: Curves.easeInBack);
  }

  void _updateExpand() {
    _isExpand = !_isExpand;
    if (_isExpand) {
      animationController.forward();
    } else {
      animationController.reverse();
    }
  }

  @override
  void initState() {
    super.initState();
    prepareAnimation();
    _updateExpand();
  }

  Widget buildExpandedWordItems() {
    return Column(
      children: [
        ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (context, index) => RichText(
              text: TextSpan(children: [
            Constant.kDot,
            TextSpan(
                style: Constant.kAdditionalTitle,
                text: widget.wordItems[index].title,
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    print(widget.wordItems[index].url);
                  })
          ])),
          itemCount: widget.wordItems.length,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: Constant.kMarginSmall),
      child: Container(
        padding: const EdgeInsets.symmetric(
            horizontal: Constant.kMarginLarge,
            vertical: Constant.kMarginExtraSmall),
        child: Column(
          children: [
            Row(
              children: [
                Wrap(
                  children: [
                    Text(
                      "${widget.wordType} with ",
                      style: Constant.kPhraseSubHeadline,
                    ),
                    Text(
                      "${widget.wordTitle}",
                      style: Constant.kPhraseTitle,
                    )
                  ],
                ),
                const Expanded(child: SizedBox()),
                RotationTransition(
                  turns: animation,
                  child: GestureDetector(
                    child: Icon(
                      _isExpand ? CupertinoIcons.minus : CupertinoIcons.plus,
                      color: Colors.grey,
                      key: ValueKey<bool>(_isExpand),
                    ),
                    onTap: () {
                      setState(() {
                        _updateExpand();
                      });
                    },
                  ),
                )
              ],
            ),
            SizeTransition(
              sizeFactor: animation,
              child: buildExpandedWordItems(),
            )
          ],
        ),
      ),
    );
  }
}
