import 'package:flutter/material.dart';

import 'model/word_field.dart';
import 'provider/word_field_data.dart';

void main() async {
  List<Tab> tabList = [];
  int numberOfTab;

  WordFieldData wordFieldData = WordFieldData();
  await wordFieldData.updateWordFieldList("hello");
  tabList = buildTabs(wordFieldData.wordFields);
  print(tabList);
  numberOfTab = tabList.length;
  print(numberOfTab);
}

List<Tab> buildTabs(List<WordField> wordField) {
  return wordField
      .map((e) => Tab(
            text: e.fieldTitle!,
          ))
      .toList();
}
