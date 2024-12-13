import 'dart:ui';

import 'package:eng_dict/view/component/glass_app_bar.dart';
import 'package:eng_dict/view/component/search_bar.dart';
import 'package:eng_dict/view/component/sliver_glass_app_bar.dart';
import 'package:eng_dict/view/utils/constants.dart';
import 'package:eng_dict/view/utils/custom_icon.dart';
import 'package:eng_dict/view/widgets/word_title_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:just_audio/just_audio.dart';

class DictionaryScreen extends StatelessWidget {
  final numberOfTab = 2;
  final String screenId = "DictionaryScreen";
  DictionaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.white,
      body: SafeArea(
        bottom: false,
        child: DefaultTabController(
          length: numberOfTab,
          child: NestedScrollView(
            headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
              return [
                const SliverAppBar(
                pinned: false,
                snap: true,
                floating: true,
                backgroundColor: Colors.white,
                surfaceTintColor: Colors.white,
                title: CustomSearchBar()
              ),
                SliverPersistentHeader(
                  pinned: true,
                  delegate: TabBarDelegate(
                    child: const TabBar(
                      
                      dividerHeight: 2,
                      tabAlignment: TabAlignment.start,
                      isScrollable: true,
                      tabs: [
                        Tab(text: "General",),
                        Tab(text: "Business",),
                      ],
                      unselectedLabelColor: Constant.kGreyText,
                      labelColor: Constant.kPrimaryColor,
                      padding: EdgeInsets.zero,
                      indicatorSize: TabBarIndicatorSize.tab,
                      indicatorColor: Constant.kPrimaryColor,
                      labelStyle: TextStyle(
                        fontSize: 18,
                      ),


                    ),
                  ),
                ),
              ];
            },
            body: TabBarView(children: [
              ListView(
                children: [
                  WordTitleBox(),
                  Padding(
                    padding: const EdgeInsets.only(top: Constant.kMarginMedium, left: Constant.kMarginMedium),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 12.0),
                          child: Row(
                            children: [
                              Expanded(child: Text("B1", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic, color: Constant.kPrimaryColor),)),
                              Icon(Icons.bookmark_outline, size: 30, color: Colors.redAccent,)
                            ],
                          ),
                        ),
                        Text("The word or words that a person, thing, or place is known by:", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),),
                        Padding(
                          padding: const EdgeInsets.only(left: Constant.kMarginMedium, top: Constant.kMarginExtraSmall),
                          child: Column(
                            children: [
                              Text("-  Please write your full (= complete) name and address on the form."),
                              Text("-  Please write your full (= complete) name and address on the form."),
                              Text("-  Please write your full (= complete) name and address on the form."),
                              Text("-  Please write your full (= complete) name and address on the form."),
                              Text("-  Please write your full (= complete) name and address on the form."),
                              Text("-  Please write your full (= complete) name and address on the form."),
                            ],
                          ),
                        )

                      ],
                    ),
                  )
                ],
              )
              ,Container(
                color: Colors.blue,
                child: Text("Business"),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}


class TabBarDelegate extends SliverPersistentHeaderDelegate{
  final TabBar child;

  TabBarDelegate({required this.child});

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    // TODO: implement build
    return Container(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: child,
      )
    );
  }

  @override
  // TODO: implement maxExtent
  double get maxExtent => child.preferredSize.height;

  @override
  // TODO: implement minExtent
  double get minExtent => child.preferredSize.height;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }

  @override
  OverScrollHeaderStretchConfiguration get stretchConfiguration =>
      OverScrollHeaderStretchConfiguration();

}
