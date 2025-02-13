import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../utils/constants.dart';

class TimerWidget extends StatefulWidget {
  final int startTime;
  Function onTimesUp;
  TimerWidget({super.key, required this.startTime, required this.onTimesUp});

  @override
  State<TimerWidget> createState() => _TimerWidgetState();
}

class _TimerWidgetState extends State<TimerWidget> {
  late int _seconds;
  Timer? _timer;

  Color _timerColor = Constant.kGreenIndicatorColor;

  @override
  void initState() {
    super.initState();
    _seconds = widget.startTime;
    _startTimer();
  }

  void _startTimer() {
    if (_timer != null) return;

    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        setState(() {
          if (_seconds > 0) {
            _seconds--;
            updateTimerColor();
          } else {
            _cancelTimer();
            widget.onTimesUp();
          }
        });
      },
    );
  }

  void updateTimerColor() {
    if (_seconds == (widget.startTime * 2 / 3).floor()) {
      _timerColor = Constant.kYellowIndicatorColor;
    } else if (_seconds == (widget.startTime * 1 / 3).floor()) {
      _timerColor = Constant.kRedIndicatorColor;
    }
  }

  void _cancelTimer() {
    _timer?.cancel();
    _timer = null;
  }

  String _formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int secondsLeft = seconds % 60;

    return '${minutes.toString().padLeft(2, '0')}:${secondsLeft.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    super.dispose();
    _cancelTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          CupertinoIcons.alarm,
          color: _timerColor,
          size: 32,
        ),
        const SizedBox(
          width: Constant.kMarginSmall,
        ),
        Text(
          _formatTime(_seconds),
          style: GoogleFonts.chivoMono(
              color: _timerColor, fontSize: 28, fontWeight: FontWeight.w300),
        )
      ],
    );
  }
}
