import 'package:eng_dict/view/utils/constants.dart';
import 'package:eng_dict/view/utils/custom_icon.dart';
import 'package:eng_dict/view/widgets/navigation_menu.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatelessWidget {
  String searchTextFieldText = "";
  SearchScreen({super.key});

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
                      onChanged: (value) => searchTextFieldText = value,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);

                      //todo move this to search word action
                      Provider.of<ScreenData>(context, listen: false)
                          .changeIndex(1);
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
                  Text(
                    "Search result",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Constant.kGreyText),
                  ),
                  ListTile(
                    title: Text("data"),
                    leading: Icon(CustomIcon.search),
                  ),
                  ListTile(
                    leading: Icon(CustomIcon.search),
                    title: Text("Informal"),
                  ),
                  ListTile(
                    leading: Icon(CustomIcon.search),
                    title: Text("Informative"),
                  ),
                  ListTile(
                    leading: Icon(CustomIcon.search),
                    title: Text("Information"),
                  ),
                  ListTile(
                    leading: Icon(CustomIcon.search),
                    title: Text("Informational"),
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
