import 'package:eng_dict/view/component/glass_app_bar.dart';
import 'package:eng_dict/view/utils/constants.dart';
import 'package:eng_dict/view/utils/custom_icon.dart';
import 'package:eng_dict/view/widgets/vocabulary_box.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class VocabularyScreen extends StatelessWidget {
  final String screenId = "VocabularyScreen";
  const VocabularyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          SliverAppBar.medium(
            pinned: true,
            flexibleSpace: AppBar(
              backgroundColor: Colors.white,
              surfaceTintColor: Colors.white,
              title: Text("Vocabulary"),
            ),
            title: Text("Vocabulary"),
            toolbarHeight: kToolbarHeight,
            collapsedHeight: kToolbarHeight,
            expandedHeight: kToolbarHeight,
            surfaceTintColor: Colors.white,
            backgroundColor: Colors.white,
          ),
          SliverPersistentHeader(
              pinned: true,
              delegate: toolBarDelegate(
                Container(
                  padding: const EdgeInsets.only(
                      left: 8.0,
                      right: Constant.kMarginMedium,
                      top: Constant.kMarginMedium),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border:
                          Border(top: BorderSide(color: Constant.kGreyLine))),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Icon(
                        CustomIcon.sort,
                        color: Constant.kHyperLinkTextColor,
                        size: 32,
                      ),
                      Expanded(
                        child: SizedBox(),
                      ),
                      TextButton(
                        style: ButtonStyle(),
                        onPressed: () {
                          print("practice");
                        },
                        child: Text(
                          "Practice now",
                          style: GoogleFonts.openSans(
                              decoration: TextDecoration.underline,
                              decorationThickness: 2,
                              decorationColor: Constant.kHyperLinkTextColor,
                              fontWeight: FontWeight.w400,
                              fontSize: 20,
                              color: Colors.transparent,
                              shadows: [
                                Shadow(
                                    color: Constant.kHyperLinkTextColor,
                                    offset: Offset(0, -5))
                              ]),
                        ),
                      )
                    ],
                  ),
                ),
              )),
          SliverToBoxAdapter(
            child: Column(
              children: [
                VocabularyBox(),
                VocabularyBox(),
                VocabularyBox(),
                VocabularyBox(),
                VocabularyBox(),
                VocabularyBox(),
                VocabularyBox(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class toolBarDelegate extends SliverPersistentHeaderDelegate {
  Widget child;

  toolBarDelegate(this.child);

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    // TODO: implement build
    return child;
  }

  @override
  // TODO: implement maxExtent
  double get maxExtent => kToolbarHeight;

  @override
  // TODO: implement minExtent
  double get minExtent => kToolbarHeight;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    // TODO: implement shouldRebuild
    return true;
  }
}
