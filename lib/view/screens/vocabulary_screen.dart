import 'package:eng_dict/model/vocabulary.dart';
import 'package:eng_dict/provider/vocabulary_data.dart';
import 'package:eng_dict/view/utils/constants.dart';
import 'package:eng_dict/view/utils/custom_icon.dart';
import 'package:eng_dict/view/widgets/vocabulary_box.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class VocabularyScreen extends StatelessWidget {
  final String screenId = "VocabularyScreen";
  VocabularyScreen({super.key});
  late List<Vocabulary> vocabularyList;

  @override
  Widget build(BuildContext context) {
    vocabularyList = Provider.of<VocabularyData>(context).vocabularyList;
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          SliverAppBar.medium(
            pinned: true,
            flexibleSpace: AppBar(
              backgroundColor: Colors.white,
              surfaceTintColor: Colors.white,
              title: const Text("Vocabulary"),
            ),
            title: const Text("Vocabulary"),
            toolbarHeight: kToolbarHeight,
            collapsedHeight: kToolbarHeight,
            expandedHeight: kToolbarHeight,
            surfaceTintColor: Colors.white,
            backgroundColor: Colors.white,
          ),
          SliverPersistentHeader(
              pinned: true,
              delegate: ToolBarDelegate(
                Container(
                  padding: const EdgeInsets.only(
                      left: 8.0,
                      right: Constant.kMarginMedium,
                      top: Constant.kMarginMedium),
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      border:
                          Border(top: BorderSide(color: Constant.kGreyLine))),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      const Icon(
                        CustomIcon.sort,
                        color: Constant.kHyperLinkTextColor,
                        size: 32,
                      ),
                      const Expanded(
                        child: SizedBox(),
                      ),
                      TextButton(
                        style: const ButtonStyle(),
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
                                const Shadow(
                                    color: Constant.kHyperLinkTextColor,
                                    offset: Offset(0, -5))
                              ]),
                        ),
                      )
                    ],
                  ),
                ),
              )),
          SliverList.builder(
            itemCount: vocabularyList.length,
            itemBuilder: (context, index) {
              return VocabularyBox(
                vocabulary: vocabularyList[index],
              );
            },
          ),

          // SliverToBoxAdapter(
          //   child: ListView.builder(
          //     physics: const NeverScrollableScrollPhysics(),
          //     shrinkWrap: true,
          //
          //   ),
          // ),
        ],
      ),
    );
  }
}

class ToolBarDelegate extends SliverPersistentHeaderDelegate {
  Widget child;

  ToolBarDelegate(this.child);

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
