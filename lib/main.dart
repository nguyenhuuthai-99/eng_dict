import 'package:eng_dict/networking/database_helper.dart';
import 'package:eng_dict/provider/vocabulary_data.dart';
import 'package:eng_dict/view/dialog/error-dialog.dart';
import 'package:eng_dict/view/screens/vocabulary_screen.dart';
import 'package:eng_dict/view/utils/constants.dart';
import 'package:eng_dict/view/utils/internet_checker.dart';
import 'package:eng_dict/view/widgets/navigation_menu.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'provider/screen_data.dart';
import 'provider/word_field_data.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  DatabaseHelper databaseHelper = DatabaseHelper();
  await databaseHelper.initializeDatabase();

  VocabularyData vocabularyData = VocabularyData(databaseHelper);
  await vocabularyData.getVocabulary();

  runApp(MultiProvider(providers: [
    Provider(
      create: (context) => databaseHelper,
    ),
    ChangeNotifierProvider(
      create: (context) => vocabularyData,
    ),
    ChangeNotifierProvider(create: (_) => ScreenData()),
    ChangeNotifierProvider(
        create: (_) => WordFieldData()..updateWordFieldList("hello")),
  ], child: MyApp()));
}

Future<void> checkInternet(BuildContext context) async {
  bool isConnected = await InternetChecker.checkInternet();
  if (!isConnected) {
    if (context.mounted) {
      showDialog(
        context: context,
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
    checkInternet(context);
    return MaterialApp(
      navigatorKey: navigatorKey,
      theme: ThemeData(
        colorScheme: ColorScheme.light(primary: Constant.kPrimaryColor),
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(color: Colors.white),
        brightness: Brightness.light,
        textTheme: GoogleFonts.openSansTextTheme(Theme.of(context).textTheme),
      ),
      title: 'Eng Dict',
      home: NavigationMenu(),
    );
  }
}
