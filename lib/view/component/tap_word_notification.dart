import 'package:flutter/material.dart';

class TapWordNotification extends StatefulWidget {
  const TapWordNotification({super.key});

  @override
  State<TapWordNotification> createState() => _TapWordNotificationState();
}

class _TapWordNotificationState extends State<TapWordNotification> {
  bool closed = false;
  @override
  Widget build(BuildContext context) {
    return !closed ?Card(
      color: const Color(0xff414141),
      child: Row(
        children: [
          const Expanded(child: Text("   Tap any word you don’t know to see its definition!", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),)),
          IconButton(onPressed: (){
            setState(() {
              closed = true;
            });
          }, icon:const Icon(Icons.close, color: Colors.white,))
        ],
      ),
    ): const SizedBox();
  }
}
