import 'dart:ui';

import 'package:eng_dict/model/word_form.dart';
import 'package:eng_dict/view/component/glass_app_bar.dart';
import 'package:eng_dict/view/utils/constants.dart';
import 'package:eng_dict/view/widgets/readings_box.dart';
import 'package:eng_dict/view/widgets/word_of_the_day_box.dart';
import 'package:flutter/material.dart';
import '../../model/word.dart';
import '../utils/custom_icon.dart';
import '../component/search_bar.dart';

class HomeScreen extends StatelessWidget {

  final String screenId = "HomeScreen";

  late WordForm wordForm;

  HomeScreen({super.key}){
    init();
  }


  init(){
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


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.white,
      appBar: GlassAppBar(title: 'Home',),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: Constant.kMarginLarge),
        child: ListView(
          children: [
              const CustomSearchBar(),
              const SizedBox(height: Constant.kMarginExtraLarge,),
              WordOfTheDayBox(wordForm: wordForm,),
              const SizedBox(height: Constant.kMarginExtraLarge,),
              const ReadingsBox(),
              const RemoveAdsBox()
          ],
        ),
      ),
    );
  }
}

class RemoveAdsBox extends StatelessWidget {
  const RemoveAdsBox({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: Constant.kMarginExtraLarge),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(Constant.kMarginSmall)),
        gradient: Constant.kGradient,
      ),
      child: Row(
        children: [
          Expanded(
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: Constant.kMarginLarge, vertical: Constant.kMarginExtraSmall),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Remove Ads", style: TextStyle(fontWeight: FontWeight.bold,fontSize: 24,color: Colors.white),),
                  Text(
                    "Enjoy searching words without distraction ad asdf asf ", style: TextStyle(color: Colors.white, fontStyle: FontStyle.italic, fontSize: 15),),
                  Icon(CustomIcon.arrow, color: Colors.white,size: 30,)
            
                ],
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(right: 30),
              child: Icon(CustomIcon.noads, color: Colors.white,size: 50,))
        ],
      ),
    );
  }
}






