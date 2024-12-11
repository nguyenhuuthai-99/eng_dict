import 'dart:ui';

import 'package:eng_dict/model/word_form.dart';
import 'package:eng_dict/view/utils/constants.dart';
import 'package:eng_dict/view/widgets/readings_box.dart';
import 'package:eng_dict/view/widgets/word_of_the_day_box.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:just_audio/just_audio.dart';
import '../../model/word.dart';
import '../utils/custom_icon.dart';
import '../widgets/search_bar.dart';

class HomeScreen extends StatelessWidget {

  final String screenId = "HomeScreen";

  late AppBar appBar;

  late WordForm wordForm;

  HomeScreen({super.key}){
    init();
  }


  init(){
    //Build Appbar
    appBar = buildAppBar();

    //Get Word of the day
    wordForm = getWordOfTheDay();

  }

  WordForm getWordOfTheDay(){
    WordForm wordForm= WordForm();
    wordForm.formTitle = "noun";
    wordForm.usIPA = "/dɪˈvɝː.sə.t̬i/";
    wordForm.ukIPA = "/daɪˈvɜː.sə.ti/";

    Word word = Word();
    word.wordTitle = "diversity";
    word.definition = "the fact of many different types of things or people being included in something; a range of different things or people:";
    word.url = "";
    wordForm.word = word;

    return wordForm;
  }



  AppBar buildAppBar(){
    return AppBar(
      title: Text("Home"),
      backgroundColor: Colors.white.withOpacity(0.2),
      surfaceTintColor: Colors.grey.withOpacity(0.2),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        child: ClipRRect(
            child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
                child: appBar)),
        preferredSize: Size(MediaQuery.of(context).size.width, appBar.preferredSize.height),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: Constant.kMarginLarge),
        child: ListView(
          children: [
              const CustomSearchBar(),
              const SizedBox(height: Constant.kMarginExtraLarge,),
              WordOfTheDayBox(wordForm: wordForm,),
              const SizedBox(height: Constant.kMarginExtraLarge,),
              const ReadingsBox()
          ],
        ),
      ),
    );
  }
}





