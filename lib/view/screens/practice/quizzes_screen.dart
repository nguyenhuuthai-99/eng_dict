import 'package:eng_dict/view/component/count_down_timer.dart';
import 'package:eng_dict/view/utils/constants.dart';
import 'package:flutter/material.dart';

class QuizzesScreen extends StatefulWidget {
  const QuizzesScreen({super.key});

  @override
  State<QuizzesScreen> createState() => _QuizzesScreenState();
}

class _QuizzesScreenState extends State<QuizzesScreen> {
  void onTimesUp() {
    //todo move to the next question
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("3/10"),
        actions: [Text("Skip   ")],
      ),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: Constant.kMarginLarge),
        child: Column(
          children: [
            TimerWidget(startTime: 120, onTimesUp: () => onTimesUp()),
            Row(
              children: [
                Flexible(
                  flex: 3,
                  child: Column(
                    children: [WordMatchingTitleWidget()],
                  ),
                ),
                const Expanded(child: SizedBox()),
                Flexible(
                  flex: 6,
                  child: Column(
                    children: [WordMatchingDeffinitionWidget()],
                  ),
                ),
              ],
            )
          ],
        ),
      )),
    );
  }
}

class WordMatchingTitleWidget extends StatefulWidget {
  const WordMatchingTitleWidget({
    super.key,
  });

  @override
  State<WordMatchingTitleWidget> createState() =>
      _WordMatchingTitleWidgetState();
}

class _WordMatchingTitleWidgetState extends State<WordMatchingTitleWidget> {
  bool _isDragging = false;

  Color borderColor = Constant.kGreyLine;
  Color textColor = Colors.black87;
  Color selectedColor = Constant.kBlue;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanDown: (details) {
        setState(() {
          _isDragging = true;
        });
        print(details);
      },
      onPanEnd: (details) {
        setState(() {
          _isDragging = false;
        });

        print("end dragging");
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: Constant.kMarginExtraSmall),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Constant.kMarginExtraSmall),
            border: Border.all(
                color: _isDragging ? selectedColor : borderColor, width: 2)),
        child: Center(
          child: Text(
            "Incorrectfhsisk",
            style: TextStyle(
                fontWeight: FontWeight.w900,
                color: _isDragging ? Constant.kBlue : textColor),
          ),
        ),
      ),
    );
  }
}

class WordMatchingDeffinitionWidget extends StatefulWidget {
  const WordMatchingDeffinitionWidget({
    super.key,
  });

  @override
  State<WordMatchingDeffinitionWidget> createState() =>
      _WordMatchingDeffinitionWidgetState();
}

class _WordMatchingDeffinitionWidgetState
    extends State<WordMatchingDeffinitionWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: Constant.kMarginSmall,
          vertical: Constant.kMarginExtraSmall),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Constant.kMarginExtraSmall),
          border: Border.all(color: Constant.kGreyLine, width: 2)),
      child: Text(
        "unusual or special and therefore surprising and worth mentioning:",
        style: TextStyle(fontWeight: FontWeight.w900),
      ),
    );
  }
}
