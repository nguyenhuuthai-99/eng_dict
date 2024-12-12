import 'dart:ui';

import 'package:eng_dict/view/component/glass_app_bar.dart';
import 'package:eng_dict/view/component/search_bar.dart';
import 'package:eng_dict/view/component/sliver_glass_app_bar.dart';
import 'package:eng_dict/view/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class DictionaryScreen extends StatelessWidget {
  final String screenId = "DictionaryScreen";
  DictionaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: DefaultTabController(
          length: 3,
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
                      tabAlignment: TabAlignment.start,
                      isScrollable: true,
                      tabs: [
                        Tab(text: "General",),
                        Tab(text: "Business",),
                        Tab(text: "American",),
                      ],
                      unselectedLabelColor: Constant.kGreyText,
                      labelColor: Constant.kPrimaryColor,
                      padding: EdgeInsets.zero,
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
                  Container(
                    height: 300,
                    child: Text("data asd fas dfas dfasd fas dfasd fasd f"),
                  ),
                  SizedBox(height: 10,),Container(
                    height: 300,
                    color: Colors.red,
                  ),
                  SizedBox(height: 10,),Container(
                    height: 300,
                    color: Colors.red,
                  ),
                  SizedBox(height: 10,),Container(
                    height: 300,
                    color: Colors.red,
                  ),
                  SizedBox(height: 10,),Container(
                    height: 300,
                    color: Colors.red,
                  ),
                  SizedBox(height: 10,),


                ],
              ),Container(
                color: Colors.blue,
                child: Text("Business"),
              ),Container(
                color: Colors.green,
                child: Text("American"),
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
      child: child
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
