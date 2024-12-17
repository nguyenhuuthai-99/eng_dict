import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:eng_dict/model/word.dart';
import 'package:eng_dict/model/word_field.dart';
import 'package:eng_dict/view/component/search_bar.dart';
import 'package:eng_dict/view/utils/constants.dart';
import 'package:eng_dict/view/widgets/definition_box.dart';
import 'package:eng_dict/view/widgets/word_title_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class DictionaryScreen extends StatelessWidget {
  final numberOfTab = 2;
  final String screenId = "DictionaryScreen";
  late WordFieldData wordFieldData;

  DictionaryScreen({super.key}) {
    wordFieldData = WordFieldData();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => wordFieldData,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: Colors.white,
        body: SafeArea(
          bottom: false,
          child: DefaultTabController(
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
                      child: const TabBar(
                        dividerHeight: 2,
                        tabAlignment: TabAlignment.start,
                        isScrollable: true,
                        tabs: [
                          Tab(
                            text: "General",
                          ),
                          Tab(
                            text: "Business",
                          ),
                        ],
                        unselectedLabelColor: Constant.kGreyText,
                        labelColor: Constant.kPrimaryColor,
                        padding: EdgeInsets.zero,
                        indicatorSize: TabBarIndicatorSize.tab,
                        indicatorColor: Constant.kPrimaryColor,
                        labelStyle: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                ];
              },
              body: TabBarView(children: [
                ListView(
                  children: [
                    WordTitleBox(),
                    DefinitionBox(
                      word: Word()..isPhrase = false,
                    ),
                    DefinitionBox(
                      word: Word()..isPhrase = true,
                    ),
                  ],
                ),
                Container(
                  color: Colors.blue,
                  child: Text("Business"),
                ),
              ]),
            ),
          ),
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
  List<WordField> wordFields = [];

  WordFieldData() {
    getWordData("name");
  }

  void updateWordFieldList() {
    notifyListeners();
  }

  void getWordData(String word) async {
    if (word.isEmpty) {
      return;
    }

    var URL = Uri.parse("http://localhost:8080/dictionary/$word");
    var response = await http.get(URL);

    int responseCode = response.statusCode;

    if (responseCode == HttpStatus.ok) {
      var jsonResult = response.body;
      parseJsonOutput(jsonResult);
    }
  }

  void parseJsonOutput(String json) {
    var jsonOutput = jsonDecode(json);
    for (var wordField in jsonOutput) {
      print(wordField["fieldTitle"]);
    }
  }
}
