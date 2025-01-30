import 'package:eng_dict/model/word.dart';
import 'package:eng_dict/model/word_field.dart';
import 'package:eng_dict/provider/word_field_data.dart';
import 'package:eng_dict/view/component/placeholder.dart';
import 'package:eng_dict/view/component/search_bar.dart';
import 'package:eng_dict/view/component/tap_word_notification.dart';
import 'package:eng_dict/view/screens/search_screen.dart';
import 'package:eng_dict/view/utils/constants.dart';
import 'package:eng_dict/view/utils/custom_icon.dart';
import 'package:eng_dict/view/utils/setting_service.dart';
import 'package:eng_dict/view/widgets/dictionary/definition_box.dart';
import 'package:eng_dict/view/widgets/dictionary/word_title_box.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../../model/word_form.dart';

class DictionaryScreen extends StatelessWidget {
  final String screenId = "DictionaryScreen";
  late List<Tab> tabList;
  late int numberOfTab;
  late WordFieldData wordFieldData;
  late bool canNotify;
  bool isBottom = false;
  bool showAppBar;

  DictionaryScreen({super.key, required this.showAppBar});

  void init() {
    tabList = buildTabs(wordFieldData.wordFields!);
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
                            style: Constant.kPhraseSubHeadline,
                          ),
                          Text(
                            word!.wordTitle!,
                            style: Constant.kPhraseTitle,
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

  Future<void> checkUserSetting(SettingsService setting) async {
    canNotify =
        (await setting.readSettings())["notification_dictionary_screen"];
  }

  bool canShowInformationLabel() {
    if (isBottom) {
      return false;
    }
    if (wordFieldData.wordFields.isEmpty) {
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    wordFieldData = Provider.of<WordFieldData>(context);
    checkUserSetting(Provider.of<SettingsService>(context, listen: false));
    init();
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: canShowInformationLabel()
          ? AppBar(
              backgroundColor: Colors.white,
              title: const CustomSearchBar(),
            )
          : null,
      backgroundColor: Colors.white,
      body: !canShowInformationLabel()
          ? SafeArea(
              bottom: false,
              child: wordFieldData.isLoading
                  ? DictionaryLoadingScreen()
                  : DefaultTabController(
                      length: numberOfTab,
                      child: NestedScrollView(
                        headerSliverBuilder:
                            (BuildContext context, bool innerBoxIsScrolled) {
                          return [
                            if (!isBottom)
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
                                  dividerColor: Constant.kGreyLine,
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
                            if (canNotify)
                              SliverToBoxAdapter(
                                child: TapWordNotification(
                                    setting: "notification_dictionary_screen"),
                              ),
                          ];
                        },
                        body: TabBarView(
                            physics: const BouncingScrollPhysics(),
                            children: buildTabsView(wordFieldData.wordFields!)),
                      ),
                    ))
          : SafeArea(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "Start by searching for a word!",
                      style: TextStyle(
                          color: Constant.kPrimaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 22),
                    ),
                    const Text(
                      "What word are you curious about today?",
                      style: TextStyle(color: Colors.black87, fontSize: 18),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SearchScreen(),
                          ),
                        );
                      },
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "Search now ",
                            style: TextStyle(
                              fontSize: 18,
                              color: CupertinoColors.activeBlue,
                              fontFamily: "Open Sans",
                            ),
                          ),
                          Icon(
                            CupertinoIcons.search,
                            size: 18,
                            color: CupertinoColors.activeBlue,
                          )
                        ],
                      ),
                    ),
                  ],
                ),
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
      body: Container(
        padding:
            const EdgeInsets.symmetric(horizontal: Constant.kMarginExtraLarge),
        width: double.infinity,
        child: RefreshIndicator(
          color: Colors.grey,
          backgroundColor: Colors.white,
          onRefresh: () async {
            await Provider.of<WordFieldData>(context, listen: false).reload();
          },
          child: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: Constant.kMarginExtraLarge),
                child: RichText(
                  text: const TextSpan(
                    style: TextStyle(fontSize: 16, color: Colors.black),
                    children: [
                      TextSpan(
                        text:
                            "Oops! Something went wrong. Please try again.\n\n",
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
                          text:
                              "- There could be an issue with our server.\n\n"),
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
      ),
    );
  }
}

class DictionaryLoadingScreen extends StatelessWidget {
  late WordFieldData wordFieldData;

  @override
  Widget build(BuildContext context) {
    wordFieldData = Provider.of<WordFieldData>(context);
    return !wordFieldData.hasError
        ? Scaffold(
            appBar: AppBar(
              title: const CustomSearchBar(),
            ),
            body: Shimmer.fromColors(
              baseColor: Colors.grey.shade300,
              highlightColor: Colors.grey.shade100,
              enabled: true,
              direction: ShimmerDirection.ltr,
              child: const SingleChildScrollView(
                physics: NeverScrollableScrollPhysics(),
                child: Column(
                  children: [
                    TabBarPlaceHolder(),
                    WordTitlePlaceholder(),
                    DefinitionPlaceholder(),
                    DefinitionPlaceholder(),
                    WordTitlePlaceholder(),
                    WordTitlePlaceholder()
                  ],
                ),
              ),
            ),
          )
        : const DictionaryErrorScreen();
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
