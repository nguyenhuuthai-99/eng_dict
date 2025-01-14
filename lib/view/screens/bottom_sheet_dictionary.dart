import 'package:eng_dict/provider/word_field_data.dart';
import 'package:eng_dict/view/screens/dictionary_screen.dart';
import 'package:eng_dict/view/widgets/banner_ads_box.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';

void showDictionaryBottomSheet(BuildContext context, String word) {
  showCupertinoModalBottomSheet(
    context: context,
    builder: (context) {
      return ChangeNotifierProvider(
        create: (_) => WordFieldData()..updateWordFieldList(word),
        child: const BottomSheetDictionary(),
      );
    },
  );
}

class BottomSheetDictionary extends StatelessWidget {
  const BottomSheetDictionary({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Expanded(
            child: DictionaryScreen(
              showAppBar: false,
            ),
          ),
          BannerAdsBox(
            key: UniqueKey(),
          )
        ],
      ),
    );
  }
}
