import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:eng_dict/model/word.dart';
import 'package:eng_dict/model/word_field.dart';
import 'package:eng_dict/networking/request_handler.dart';
import 'package:eng_dict/view/component/placeholder.dart';
import 'package:eng_dict/view/component/search_bar.dart';
import 'package:eng_dict/view/utils/constants.dart';
import 'package:eng_dict/view/widgets/definition_box.dart';
import 'package:eng_dict/view/widgets/word_title_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:shimmer/shimmer.dart';

import '../../model/word_form.dart';

class DictionaryScreen extends StatelessWidget {
  final String screenId = "DictionaryScreen";

  late List<Tab> tabList = [
    Tab(
      text: "General",
    )
  ];
  late int numberOfTab = 1;
  late WordFieldData wordFieldData;

  DictionaryScreen({super.key});

  Future<void> init() async {
    wordFieldData = WordFieldData();
    await wordFieldData.updateWordFieldList("name");
    tabList = buildTabs(wordFieldData.wordFields);
    numberOfTab = tabList.length;
  }

  List<Tab> buildTabs(List<WordField> wordField) {
    return wordField
        .map((e) => Tab(
              text: e.fieldTitle!,
            ))
        .toList();
  }

  List<Widget> buildTabsView(List<WordField> wordFields) {
    return (wordFields.map(
      (e) => ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          final WordForm? wordForm = e.wordForms?[index];
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: buildWordBox(wordForm),
          );
        },
        itemCount: e.wordForms?.length,
      ),
    )).toList();
  }

  List<Widget> buildWordBox(WordForm? wordForm) {
    return [
      WordTitleBox(
        wordForm: wordForm,
      ),
      ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, wordIndex) {
          final Word? word = wordForm?.words?[wordIndex];
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: Constant.kMarginLarge),
                child: word?.isPhrase == true && word?.wordTitle != null
                    ? Row(
                        children: [
                          const Text(
                            "phrase with ",
                            style: TextStyle(
                                color: Constant.kGreyText,
                                fontStyle: FontStyle.italic),
                          ),
                          Text(
                            word!.wordTitle!,
                            style: const TextStyle(
                                color: Color(0xb82a3343),
                                fontWeight: FontWeight.bold),
                          )
                        ],
                      )
                    : const SizedBox(),
              ),
              DefinitionBox(word: word),
            ],
          );
        },
        itemCount: wordForm?.words?.length,
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.white,
      body: SafeArea(
        bottom: false,
        child: FutureBuilder(
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const DictionaryLoadingScreen();
            } else if (snapshot.hasError) {
              return const DictionaryErrorScreen();
            } else {
              return DefaultTabController(
                length: numberOfTab,
                child: NestedScrollView(
                  headerSliverBuilder:
                      (BuildContext context, bool innerBoxIsScrolled) {
                    return [
                      const SliverAppBar(
                          pinned: false,
                          snap: true,
                          floating: true,
                          backgroundColor: Colors.white,
                          surfaceTintColor: Colors.white,
                          title: CustomSearchBar()),
                      SliverPersistentHeader(
                        pinned: true,
                        delegate: TabBarDelegate(
                          child: TabBar(
                            dividerHeight: 2,
                            tabAlignment: TabAlignment.start,
                            isScrollable: true,
                            tabs: tabList,
                            unselectedLabelColor: Constant.kGreyText,
                            labelColor: Constant.kPrimaryColor,
                            padding: EdgeInsets.zero,
                            indicatorSize: TabBarIndicatorSize.tab,
                            indicatorColor: Constant.kPrimaryColor,
                            labelStyle: const TextStyle(
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                    ];
                  },
                  body: TabBarView(
                      children: buildTabsView(wordFieldData.wordFields)),
                ),
              );
            }
          },
          future: init(),
        ),
      ),
    );
  }
}

class DictionaryErrorScreen extends StatelessWidget {
  const DictionaryErrorScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const CustomSearchBar(),
      ),
      body: SizedBox(
        width: double.infinity,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: Constant.kMarginExtraLarge),
              child: RichText(
                text: const TextSpan(
                  style: TextStyle(fontSize: 16, color: Colors.black),
                  children: [
                    TextSpan(
                      text: "Oops! Something went wrong. Please try again.\n\n",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    TextSpan(
                      text: "What could have happened?\n",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    TextSpan(
                        text:
                            "- Your internet connection might be unstable or disconnected.\n"),
                    TextSpan(
                        text:
                            "- You might have searched for an invalid word.\n"),
                    TextSpan(
                        text: "- There could be an issue with our server.\n\n"),
                    TextSpan(
                      text:
                          "If you believe this is a server issue, please let us know.\n",
                    ),
                  ],
                ),
              ),
            ),
            TextButton(onPressed: () {}, child: const Text("Report"))
          ],
        ),
      ),
    );
  }
}

class DictionaryLoadingScreen extends StatelessWidget {
  const DictionaryLoadingScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const CustomSearchBar(),
      ),
      body: Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        enabled: true,
        direction: ShimmerDirection.ltr,
        child: Column(
          children: [
            TabBarPlaceHolder(),
            WordTitlePlaceholder(),
            DefinitionPlaceholder(),
            DefinitionPlaceholder(),
            Expanded(child: WordTitlePlaceholder()),
            Expanded(child: WordTitlePlaceholder())
          ],
        ),
      ),
    );
  }
}

class TabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar child;

  TabBarDelegate({required this.child});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: child,
        ));
  }

  @override
  double get maxExtent => child.preferredSize.height;

  @override
  double get minExtent => child.preferredSize.height;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }

  @override
  OverScrollHeaderStretchConfiguration get stretchConfiguration =>
      OverScrollHeaderStretchConfiguration();
}

class WordFieldData extends ChangeNotifier {
  RequestHandler requestHandler = RequestHandler();
  List<WordField> wordFields = [];

  WordFieldData();

  Future<void>? updateWordFieldList(String word) async {
    wordFields = await requestHandler.getWordData(word);
    notifyListeners();
  }
}
