import 'package:eng_dict/model/story.dart';
import 'package:eng_dict/view/utils/stories.dart';
import 'package:eng_dict/view/widgets/banner_ads_box.dart';
import 'package:eng_dict/view/widgets/reading_item_box.dart';
import 'package:flutter/material.dart';

class ReadingScreen extends StatelessWidget {
  ReadingScreen({super.key});
  List<Story> stories = Stories.stories;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Readings"),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemBuilder: (context, index) => ReadingItemBox(
                story: stories[index],
              ),
              itemCount: stories.length,
            ),
          ),
          BannerAdsBox(
            key: UniqueKey(),
          )
        ],
      ),
    );
  }
}
