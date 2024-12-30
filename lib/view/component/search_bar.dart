import 'package:eng_dict/view/dialog/error-dialog.dart';
import 'package:eng_dict/view/screens/search_screen.dart';
import 'package:eng_dict/view/utils/constants.dart';
import 'package:eng_dict/view/utils/internet_checker.dart';
import 'package:flutter/material.dart';

import '../utils/custom_icon.dart';

class CustomSearchBar extends StatelessWidget {
  const CustomSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        Navigator.push(
            context, MaterialPageRoute(builder: (c) => const SearchScreen()));
        bool isConnected = await InternetChecker.checkInternet();
        if (!isConnected) {
          showDialog(
            context: context,
            builder: (context) => NoInternetDialog(),
          );
        }
      },
      child: Container(
        decoration: BoxDecoration(
            color: Constant.kGreyBackground,
            borderRadius: BorderRadius.circular(Constant.kBorderRadiusSmall)),
        child: const Padding(
          padding: EdgeInsets.symmetric(
              horizontal: Constant.kMarginLarge,
              vertical: Constant.kMarginMedium),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  Icon(
                    CustomIcon.search,
                    color: Constant.kGreyText,
                    size: 25,
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Text(
                    "Search your word",
                    style: Constant.kSearchBarTextStyle,
                  ),
                ],
              ),
              Expanded(child: SizedBox()),
              Padding(
                padding: EdgeInsets.only(top: 2.0),
                child: Icon(
                  CustomIcon.history,
                  color: Constant.kGreyText,
                  size: 25,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
