import 'package:eng_dict/model/word_field.dart';
import 'package:eng_dict/model/word_form.dart';
import 'package:eng_dict/networking/request_handler.dart';
import 'package:eng_dict/view/component/glass_app_bar.dart';
import 'package:eng_dict/view/utils/constants.dart';
import 'package:eng_dict/view/utils/utils.dart';
import 'package:eng_dict/view/widgets/readings_box.dart';
import 'package:eng_dict/view/widgets/word_of_the_day_box.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../model/word.dart';
import '../utils/custom_icon.dart';
import '../component/search_bar.dart';

class HomeScreen extends StatelessWidget {
  final String screenId = "HomeScreen";

  late WordForm wordForm = WordForm();

  HomeScreen({super.key}) {
    // init();
  }

  init() async {
    //Get Word of the day
    wordForm = await getWordOfTheDay();
  }

  Future<WordForm> getWordOfTheDay() async {
    String word = Utils.getWordOfTheDay();

    List<WordField> wordFields = await RequestHandler().getWordData(word);

    return wordFields[0].wordForms![0];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.white,
      appBar: GlassAppBar(title: "Home"),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: Constant.kMarginLarge),
        child: ListView(
          children: [
            const CustomSearchBar(),
            const SizedBox(
              height: Constant.kMarginExtraLarge,
            ),
            // WordOfTheDayBox(
            //   wordForm: wordForm,
            // ),
            FutureBuilder(
              future: init(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return WordOfTheDayBox(
                    wordForm: wordForm,
                  );
                } else {
                  return Shimmer.fromColors(
                    baseColor: Colors.grey.shade300,
                    highlightColor: Colors.grey.shade100,
                    enabled: true,
                    direction: ShimmerDirection.ltr,
                    child: Container(
                      decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Constant.kRadiusSmall),
                          color: Colors.grey),
                      height: 190,
                    ),
                  );
                }
              },
            ),
            const SizedBox(
              height: Constant.kMarginExtraLarge,
            ),
            // const ReadingsBox(),
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
      margin: const EdgeInsets.symmetric(vertical: Constant.kMarginExtraLarge),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(Constant.kMarginSmall)),
        gradient: Constant.kGradient,
      ),
      child: Row(
        children: [
          const Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: Constant.kMarginLarge,
                  vertical: Constant.kMarginExtraSmall),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Remove Ads",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                        color: Colors.white),
                  ),
                  Text(
                    "Enjoy searching words without distraction",
                    style: TextStyle(
                        color: Colors.white,
                        fontStyle: FontStyle.italic,
                        fontSize: 15),
                  ),
                  Icon(
                    CustomIcon.arrow,
                    color: Colors.white,
                    size: 30,
                  )
                ],
              ),
            ),
          ),
          Container(
              margin: const EdgeInsets.only(right: 30),
              child: const Icon(
                CustomIcon.noads,
                color: Colors.white,
                size: 50,
              ))
        ],
      ),
    );
  }
}
