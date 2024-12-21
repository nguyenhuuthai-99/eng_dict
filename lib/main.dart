import 'package:eng_dict/view/screens/dictionary_screen.dart';
import 'package:eng_dict/view/widgets/navigation_menu.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ScreenData()),
        ChangeNotifierProvider(
            create: (_) => WordFieldData()..updateWordFieldList("hello")),
      ],
      child: MaterialApp(
        theme: ThemeData(
          scaffoldBackgroundColor: Colors.white,
          appBarTheme: AppBarTheme(color: Colors.white),
          brightness: Brightness.light,
          textTheme: GoogleFonts.openSansTextTheme(Theme.of(context).textTheme),
        ),
        title: 'Eng Dict',
        home: const NavigationMenu(),
      ),
    );
  }
}
