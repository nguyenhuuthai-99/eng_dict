import 'package:flutter/material.dart';

class AnimatedCircularProgress extends StatefulWidget {
  const AnimatedCircularProgress(
      {super.key,
      required this.progression,
      required this.total,
      this.progressionIndicatorColor});
  final int progression;
  final int total;
  final Color? progressionIndicatorColor;

  @override
  _AnimatedCircularProgressState createState() =>
      _AnimatedCircularProgressState();
}

class _AnimatedCircularProgressState extends State<AnimatedCircularProgress> {
  late final double progressionByPercentage;

  @override
  void initState() {
    super.initState();
    progressionByPercentage = calculateProgression();
  }

  double calculateProgression() {
    return widget.progression / widget.total;
  }

  int calculateAnimationTime() {
    return 500 + (progressionByPercentage * 1000).ceil();
  }

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0, end: progressionByPercentage),
      duration: Duration(milliseconds: calculateAnimationTime()),
      builder: (context, double value, child) {
        return SizedBox(
          width: 100,
          height: 100,
          child: Stack(
            fit: StackFit.expand,
            children: [
              CircularProgressIndicator(
                color: widget.progressionIndicatorColor,
                value: value,
                strokeWidth: 15,
                backgroundColor: Colors.grey[300],
              ),
              Opacity(
                opacity: value / progressionByPercentage,
                child: Center(
                  child: Text(
                    "${widget.progression}",
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
