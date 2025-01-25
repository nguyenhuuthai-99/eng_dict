import 'package:eng_dict/view/utils/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with SingleTickerProviderStateMixin {
  late AnimationController expandController;
  late Animation<double> animation;
  bool expand = false;

  void prepareAnimations() {
    expandController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    animation = CurvedAnimation(parent: expandController, curve: Curves.ease);
  }

  void _runExpandCheck() {
    if (expand) {
      expandController.forward();
    } else {
      expandController.reverse();
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    prepareAnimations();
    _runExpandCheck();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Text(
                    "idioms with ",
                    style: TextStyle(fontStyle: FontStyle.italic),
                  ),
                  Text(
                    "Take",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Expanded(child: SizedBox()),
                  GestureDetector(
                    child: Icon(CupertinoIcons.arrow_down),
                    onTap: () {
                      setState(() {
                        expand = !expand;
                        _runExpandCheck();
                      });
                    },
                  )
                ],
              ),
              SizeTransition(
                  sizeFactor: animation,
                  child: Column(
                    children: [
                      Text("this is an example"),
                      Text("this is an example"),
                      Text("this is an example"),
                      Text("this is an example"),
                      Text("this is an example"),
                      Text("this is an example"),
                      Text("this is an example"),
                    ],
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
