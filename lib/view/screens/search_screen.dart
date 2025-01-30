import 'package:eng_dict/model/did_you_mean_word.dart';
import 'package:eng_dict/model/searched_word.dart';
import 'package:eng_dict/model/suggested_word.dart';
import 'package:eng_dict/networking/database_helper.dart';
import 'package:eng_dict/networking/request_handler.dart';
import 'package:eng_dict/provider/action_counter.dart';
import 'package:eng_dict/provider/screen_data.dart';
import 'package:eng_dict/provider/word_field_data.dart';
import 'package:eng_dict/view/utils/constants.dart';
import 'package:eng_dict/view/utils/custom_icon.dart';
import 'package:eng_dict/view/utils/utils.dart';
import 'package:eng_dict/view/widgets/ads/banner_ads_box.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  RequestHandler requestHandler = RequestHandler();
  List<DidYouMeanWord>? didYouMeanWords;
  List<SuggestedWord> suggestedWords = [];
  late List<SearchedWord> searchedWords;
  String searchTextFieldText = "";

  Future<List<SearchedWord>> initSearchedWords() async {
    searchedWords =
        await Provider.of<DatabaseHelper>(context).getSearchedWord();
    return searchedWords;
  }

  @override
  Widget build(BuildContext context) {
    initSearchedWords();
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.only(left: Constant.kMarginMedium),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  right: Constant.kMarginExtraSmall,
                  bottom: Constant.kMarginExtraLarge),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                          prefixIcon: const Padding(
                            padding: EdgeInsets.only(left: 8),
                            child: Icon(
                              color: Constant.kGreyText,
                              CustomIcon.search,
                              size: 25,
                            ),
                          ),
                          isDense: true,
                          border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(
                                  Constant.kMarginMedium)),
                          fillColor: Constant.kGreyBackground,
                          filled: true),
                      maxLines: 1,
                      autofocus: true,
                      onTapOutside: (event) {
                        FocusManager.instance.primaryFocus?.unfocus();
                      },
                      onChanged: (value) async {
                        if (value.length > 1) {
                          suggestedWords =
                              await requestHandler.getSuggestedWord(value);
                          if (suggestedWords.isEmpty) {
                            didYouMeanWords =
                                await requestHandler.getDidYouMeanWord(value);
                          } else {
                            didYouMeanWords = null;
                          }
                        }
                        setState(() {});
                      },
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text(
                      "cancel",
                      style: TextStyle(color: Constant.kHyperLinkTextColor),
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              child: ListView(
                children: [
                  if (suggestedWords.isNotEmpty)
                    BuildSearchResult(
                      suggestedWords: suggestedWords,
                    ),
                  if (didYouMeanWords != null)
                    BuildDidYouMeanResult(didYouMeanWords: didYouMeanWords!),
                  BannerAdsBox(
                    key: UniqueKey(),
                  ),
                  const SizedBox(
                    height: Constant.kMarginMedium,
                  ),
                  FutureBuilder(
                    future: initSearchedWords(),
                    builder:
                        (BuildContext context, AsyncSnapshot<void> snapshot) {
                      if (snapshot.connectionState == ConnectionState.done &&
                          searchedWords.isNotEmpty) {
                        return buildHistoryBox();
                      }
                      return const SizedBox();
                    },
                  )
                ],
              ),
            )
          ],
        ),
      )),
    );
  }

  Widget buildHistoryBox() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Searched words",
          style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Constant.kGreyText),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: searchedWords.length,
          itemBuilder: (context, index) => GestureDetector(
            onTap: () {
              Navigator.pop(context);
              try {
                Provider.of<ActionCounter>(context, listen: false)
                    .incrementCounter();
              } catch (e) {}
              Provider.of<WordFieldData>(context, listen: false)
                  .loadWordFromURL(
                      searchedWords[index].wordTitle, searchedWords[index].url);
              Provider.of<ScreenData>(context, listen: false).changeIndex(1);
            },
            child: ListTile(
                leading: const Icon(
                  CustomIcon.history,
                  color: Constant.kGreyText,
                ),
                title: Text(searchedWords[index].wordTitle)),
          ),
        ),
      ],
    );
  }
}

class BuildSearchResult extends StatelessWidget {
  List<SuggestedWord> suggestedWords;
  BuildSearchResult({
    required this.suggestedWords,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return suggestedWords.isNotEmpty
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Search result",
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Constant.kGreyText),
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: suggestedWords.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      try {
                        Provider.of<ActionCounter>(context, listen: false)
                            .incrementCounter();
                      } catch (e) {
                        debugPrint(e.toString());
                      }

                      String newUrl = Utils.buildURL(suggestedWords[index].url);

                      Provider.of<WordFieldData>(context, listen: false)
                          .loadWordFromURL(
                              suggestedWords[index].wordTitle, newUrl);
                      Provider.of<ScreenData>(context, listen: false)
                          .changeIndex(1);

                      Provider.of<DatabaseHelper>(context, listen: false)
                          .insertSearchedWord(SearchedWord(
                              wordTitle: suggestedWords[index].wordTitle,
                              url: newUrl));
                    },
                    child: ListTile(
                      title: Text(suggestedWords[index].wordTitle),
                      leading: const Icon(
                        CustomIcon.search,
                        color: Constant.kGreyText,
                      ),
                    ),
                  );
                },
              )
            ],
          )
        : const SizedBox();
  }
}

class BuildDidYouMeanResult extends StatelessWidget {
  List<DidYouMeanWord> didYouMeanWords;
  BuildDidYouMeanResult({super.key, required this.didYouMeanWords});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Did you mean",
          style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Constant.kGreyText),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: didYouMeanWords.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                Navigator.pop(context);
                try {
                  Provider.of<ActionCounter>(context, listen: false)
                      .incrementCounter();
                } catch (e) {
                  debugPrint(e.toString());
                }

                Provider.of<WordFieldData>(context, listen: false)
                    .loadWordFromURL(didYouMeanWords[index].title,
                        didYouMeanWords[index].url);
                Provider.of<ScreenData>(context, listen: false).changeIndex(1);

                Provider.of<DatabaseHelper>(context, listen: false)
                    .insertSearchedWord(SearchedWord(
                        wordTitle: didYouMeanWords[index].title,
                        url: didYouMeanWords[index].url));
              },
              child: ListTile(
                title: Text(didYouMeanWords[index].title),
                leading: const Icon(
                  CustomIcon.search,
                  color: Constant.kGreyText,
                ),
              ),
            );
          },
        )
      ],
    );
  }
}
