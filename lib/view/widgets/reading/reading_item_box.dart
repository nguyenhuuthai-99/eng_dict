import 'package:eng_dict/model/story.dart';
import 'package:eng_dict/view/screens/reading/story_screen.dart';
import 'package:eng_dict/view/utils/constants.dart';
import 'package:eng_dict/view/utils/custom_icon.dart';
import 'package:eng_dict/view/utils/setting_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ReadingItemBox extends StatelessWidget {
  Story story;
  ReadingItemBox({
    required this.story,
    super.key,
  });

  Future<bool> checkNotification(SettingsService settings) async {
    return (await settings.readSettings())["notification_story_screen"];
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
              vertical: Constant.kMarginSmall,
              horizontal: Constant.kMarginLarge),
          child: GestureDetector(
            onTap: () async {
              final canNotify = await checkNotification(
                  Provider.of<SettingsService>(context, listen: false));
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          StoryScreen(story: story, canNotify: canNotify)));
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(story.title, style: Constant.kSectionTitle),
                Wrap(
                  children: [
                    Text(
                      "${story.genre} - ",
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Constant.kLightGreyText),
                    ),
                    Text(
                      story.level.name,
                      style: const TextStyle(color: Constant.kSecondaryColor),
                    )
                  ],
                ),
                Text(
                  story.summary,
                  style: TextStyle(
                    color: Constant.kLightGreyText,
                  ),
                ),
                const Row(
                  children: [
                    Expanded(child: SizedBox()),
                    Text("view more",
                        style: TextStyle(
                            color: Constant.kLightGreyText, fontSize: 15)),
                    Padding(
                      padding: EdgeInsets.only(top: 2.0, left: 6),
                      child: Icon(
                        CustomIcon.arrow,
                        color: Constant.kLightGreyText,
                        size: 16,
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
        Container(
          height: 1,
          color: Constant.kGreyDivider,
        )
      ],
    );
  }
}
