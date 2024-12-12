
import 'package:eng_dict/view/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../utils/custom_icon.dart';

class CustomSearchBar extends StatelessWidget {
  const CustomSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        print("search word");
      },
      child: Container(
        decoration: BoxDecoration(
          color: Constant.kGreyBackground,
          borderRadius: BorderRadius.circular(
            Constant.kBorderRadiusSmall
          )
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: Constant.kMarginLarge),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Row(
                children: [
                  Icon(CustomIcon.search, color: Constant.kGreyText, size: 25,),
                  SizedBox(width: 20,),
                  Text("Search your word", style: Constant.kSearchBarTextStyle,),
                ],
              ),
              Expanded(child: SizedBox()),
              Padding(
                padding: const EdgeInsets.only(top: 2.0),
                child: TextButton(
                    onPressed: (){
                    print("history");
                    },
                    child: const Icon(CustomIcon.history, color: Constant.kGreyText,size: 25,)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}