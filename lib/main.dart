import 'dart:io';

import 'package:eng_dict/networking/database_helper.dart';
import 'package:eng_dict/provider/action_counter.dart';
import 'package:eng_dict/provider/vocabulary_data.dart';
import 'package:eng_dict/view/dialog/error-dialog.dart';
import 'package:eng_dict/view/utils/constants.dart';
import 'package:eng_dict/view/utils/internet_checker.dart';
import 'package:eng_dict/view/utils/setting_service.dart';
import 'package:eng_dict/view/widgets/navigation_menu.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:upgrader/upgrader.dart';

import 'provider/screen_data.dart';
import 'provider/word_field_data.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();

  DatabaseHelper databaseHelper = DatabaseHelper();
  await databaseHelper.initializeDatabase();

  VocabularyData vocabularyData = VocabularyData(databaseHelper);
  await vocabularyData.getVocabulary();

  ActionCounter actionCounter = ActionCounter();
  await actionCounter.getCounter();

  runApp(MultiProvider(providers: [
    Provider(
      create: (context) => actionCounter,
    ),
    Provider(
      create: (context) => SettingsService(),
    ),
    Provider(
      create: (context) => databaseHelper,
    ),
    ChangeNotifierProvider(
      create: (context) => vocabularyData,
    ),
    ChangeNotifierProvider(create: (_) => ScreenData()),
    ChangeNotifierProvider(create: (_) => WordFieldData()),
  ], child: const MyApp()));
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
  const MyApp({super.key});
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    checkInternet(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey,
      theme: ThemeData(
          fontFamily: "Open Sans",
          colorScheme: const ColorScheme.light(
            primary: Constant.kPrimaryColor,
          ),
          scaffoldBackgroundColor: Colors.white,
          appBarTheme: const AppBarTheme(color: Colors.white),
          brightness: Brightness.light,
          // textTheme: GoogleFonts.openSansTextTheme(Theme.of(context).textTheme),
          textTheme: TextTheme()),
      title: 'EngDict',
      home: UpgradeAlert(
          dialogStyle: Platform.isIOS
              ? UpgradeDialogStyle.cupertino
              : UpgradeDialogStyle.material,
          showIgnore: false,
          showReleaseNotes: true,
          child: NavigationMenu()),
    );
  }
}
