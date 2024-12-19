import 'package:eng_dict/model/suggested_word.dart';
import 'package:eng_dict/networking/request_handler.dart';
import 'package:eng_dict/view/utils/constants.dart';
import 'package:eng_dict/view/utils/custom_icon.dart';
import 'package:eng_dict/view/widgets/navigation_menu.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'dictionary_screen.dart';

class SearchScreen extends StatefulWidget {
  SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  RequestHandler requestHandler = RequestHandler();
  List<SuggestedWord> suggestedWords = [];
  String searchTextFieldText = "";

  @override
  Widget build(BuildContext context) {
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
                          prefixIcon: Padding(
                            padding: const EdgeInsets.only(left: 8),
                            child: Icon(
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
                        if (value.length > 2) {
                          suggestedWords =
                              await requestHandler.getSuggestedWord(value);
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
                  buildSearchResult(
                    suggestedWords: suggestedWords,
                  ),
                  Text(
                    "Searched words",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Constant.kGreyText),
                  ),
                  ListTile(
                    leading: Icon(CustomIcon.history),
                    title: Text("history"),
                  ),
                  ListTile(
                    leading: Icon(CustomIcon.history),
                    title: Text("sophisticate"),
                  ),
                  ListTile(
                    leading: Icon(CustomIcon.history),
                    title: Text("quantive"),
                  ),
                ],
              ),
            )
          ],
        ),
      )),
    );
  }
}

class buildSearchResult extends StatelessWidget {
  List<SuggestedWord> suggestedWords;
  buildSearchResult({
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
                physics: NeverScrollableScrollPhysics(),
                itemCount: suggestedWords.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.pop(context);

                      Provider.of<WordFieldData>(context, listen: false)
                          .updateWordFieldList(suggestedWords[index].wordTitle);
                      Provider.of<ScreenData>(context, listen: false)
                          .changeIndex(1);
                    },
                    child: ListTile(
                      title: Text(suggestedWords[index].wordTitle),
                      leading: const Icon(CustomIcon.search),
                    ),
                  );
                },
              )
            ],
          )
        : const SizedBox();
  }
}
