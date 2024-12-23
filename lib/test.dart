import 'package:flutter/material.dart';

import 'model/word_field.dart';
import 'provider/word_field_data.dart';
import 'dart:math';

void main() async {
  runApp(MaterialApp(
    home: FullExpandingCircleButtonScreen(),
  ));
}

class FullExpandingCircleButtonScreen extends StatefulWidget {
  @override
  _FullExpandingCircleButtonScreenState createState() =>
      _FullExpandingCircleButtonScreenState();
}

class _FullExpandingCircleButtonScreenState
    extends State<FullExpandingCircleButtonScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 600),
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _expandCircle() {
    setState(() {
      _isExpanded = true;
    });
    _controller.forward().then((_) {
      Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => NewScreen(),
          transitionDuration: Duration.zero, // No transition duration
          reverseTransitionDuration:
              Duration.zero, // No reverse transition duration
        ),
      ).then((_) {
        setState(() {
          _isExpanded = false;
        });
        _controller.reverse();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // Calculate the diagonal of the screen to ensure full coverage
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final maxDiameter = sqrt(pow(screenWidth, 2) + pow(screenHeight, 2));

    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return GestureDetector(
                  onTap: _isExpanded ? null : _expandCircle,
                  child: Container(
                    width: _isExpanded
                        ? maxDiameter * _animation.value
                        : 70, // Initial button size
                    height: _isExpanded
                        ? maxDiameter * _animation.value
                        : 70, // Initial button size
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      shape: BoxShape.circle,
                    ),
                    child: !_isExpanded
                        ? Center(
                            child: Text(
                              "Press Me",
                              style: TextStyle(color: Colors.white),
                            ),
                          )
                        : null,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class NewScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("New Screen")),
      body: Center(
        child: Text("Welcome to the new screen!"),
      ),
    );
  }
}
