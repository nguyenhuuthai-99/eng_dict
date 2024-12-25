import 'dart:ui';

import 'package:eng_dict/provider/screen_data.dart';
import 'package:eng_dict/provider/vocabulary_data.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utils/constants.dart';
import '../utils/custom_icon.dart';

class NavigationMenu extends StatelessWidget {
  bool isNewWordCheck = false;
  late VocabularyData vocabularyData;
  NavigationMenu({super.key});

  @override
  Widget build(BuildContext context) {
    vocabularyData = Provider.of<VocabularyData>(context);
    ScreenData data = Provider.of<ScreenData>(context);
    return Scaffold(
      extendBody: true,
      bottomNavigationBar: NavigationBarTheme(
        data: buildNavigationBarThemeData(),
        child: ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(
                sigmaX: 25, sigmaY: 25, tileMode: TileMode.mirror),
            child: Container(
              decoration: const BoxDecoration(
                  border: Border(top: BorderSide(color: Constant.kGreyBorder))),
              child: NavigationBar(
                selectedIndex: data.index,
                indicatorColor: Colors.transparent,
                backgroundColor: Colors.white.withOpacity(0.6),
                height: 70,
                onDestinationSelected: (index) {
                  if (index == 2) {
                    isNewWordCheck = true;
                  } else {
                    if (isNewWordCheck == true) {
                      vocabularyData.resetNewVocabularyList();
                      isNewWordCheck = false;
                    }
                  }
                  data.changeIndex(index);
                },
                destinations: [
                  const NavigationDestination(
                      icon: Icon(CustomIcon.house), label: "Home"),
                  const NavigationDestination(
                      icon: Icon(CustomIcon.book), label: "Dictionary"),
                  NavigationDestination(
                      icon: Badge(
                          isLabelVisible:
                              vocabularyData.newVocabularyList.isNotEmpty,
                          label: Text(vocabularyData.newVocabularyList.length
                              .toString()),
                          child: const Icon(CustomIcon.vocabulary)),
                      label: "Vocabulary"),
                ],
              ),
            ),
          ),
        ),
      ),
      body: IndexedStack(
        index: data.index,
        children: data.screens,
      ),
    );
  }

  NavigationBarThemeData buildNavigationBarThemeData() {
    return NavigationBarThemeData(
        labelTextStyle: WidgetStateTextStyle.resolveWith((state) {
      bool isSelected = state.contains(WidgetState.selected);
      return isSelected
          ? Constant.kBottomNavigationBarTextStyleSelected
          : Constant.kBottomNavigationBarTextStyle;
    }), iconTheme: WidgetStateProperty.resolveWith<IconThemeData>((state) {
      bool isSelected = state.contains(WidgetState.selected);
      return IconThemeData(
          size: 25,
          color: isSelected
              ? Constant.kPrimaryColor
              : Constant.kButtonUnselectedColor);
    }));
  }
}
