import 'package:eng_dict/view/dialog/error-dialog.dart';
import 'package:eng_dict/view/utils/internet_checker.dart';
import 'package:eng_dict/view/widgets/navigation_menu.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'provider/screen_data.dart';
import 'provider/word_field_data.dart';

void main() {
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => ScreenData()),
    ChangeNotifierProvider(
        create: (_) => WordFieldData()..updateWordFieldList("hello")),
  ], child: MyApp()));
}

Future<void> checkInternet() async {
  BuildContext context = MyApp.navigatorKey.currentState!.context;
  bool isConnected = await InternetChecker.checkInternet();
  if (!isConnected) {
    if (context.mounted) {
      showDialog(
        context: MyApp.navigatorKey.currentState!.context,
        builder: (context) => const NoInternetDialog(),
      );
    }
  }
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    checkInternet();
    return MaterialApp(
      navigatorKey: navigatorKey,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(color: Colors.white),
        brightness: Brightness.light,
        textTheme: GoogleFonts.openSansTextTheme(Theme.of(context).textTheme),
      ),
      title: 'Eng Dict',
      home: const NavigationMenu(),
    );
  }
}
