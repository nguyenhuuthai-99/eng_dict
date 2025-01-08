import 'package:flutter/material.dart';

class ReadingScreen extends StatelessWidget {
  const ReadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:const Text("Readings"),
      ),
      body: ListView.builder(itemBuilder: (context, index) => null,),
    );
  }


}
