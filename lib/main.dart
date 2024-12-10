import 'package:eng_dict/view/widgets/navigation_menu.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context)=>ScreenData(),
      child: MaterialApp(
        theme: ThemeData(
            brightness: Brightness.light,
            textTheme: GoogleFonts.openSansTextTheme(Theme.of(context).textTheme),
        ),
        title: 'Eng Dict',
        home: const NavigationMenu(),
      ),
    );
  }
}