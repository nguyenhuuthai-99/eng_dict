import 'package:eng_dict/view/screens/dictionary_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void showDictionaryBottomSheet(BuildContext context, String word) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (context) {
      return ChangeNotifierProvider(
        create: (_) => WordFieldData()..updateWordFieldList(word),
        child: BottomSheetDictionary(),
      );
    },
  );
}

class BottomSheetDictionary extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: DictionaryScreen(),
    );
  }
}
