import 'package:eng_dict/model/story.dart';
import 'package:eng_dict/view/component/tap_word_notification.dart';
import 'package:eng_dict/view/utils/build_clickable_text.dart';
import 'package:eng_dict/view/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';



class StoryScreen extends StatelessWidget {
  late bool canNotify;
  late Story story;
  late BuildContext context;
  StoryScreen({required this.story,required this.canNotify, super.key});
  
  @override
  Widget build(BuildContext context) {
    this.context = context;
    return Scaffold(
      appBar: AppBar(
        title: Text(story.title,maxLines: 1,),
      ),
      body: SafeArea(
        child: Scrollbar(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: Constant.kMarginLarge),
            child: ListView(
              children: [
                if(canNotify) TapWordNotification(setting: "notification_story_screen"),
                buildTitle(story.title),
                StoryOriginBox(story: story),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: buildContent(story.content),
                )
              ],
            ),
          ),
        ),
      )
    );
  }

  RichText buildTitle(String title){
    List<TextSpan> children = BuildClickableText.buildClickableTextSpan(text: title, context: context);
    return RichText(text: TextSpan(
      style: GoogleFonts.openSans(color: Constant.kPrimaryColor, fontSize: 24, fontWeight: FontWeight.bold),
      children: children
    ),);
  }
  
  RichText buildContent(String content){
    List<TextSpan> children = BuildClickableText.buildClickableTextSpan(text: content, context: context);
    return RichText(text: TextSpan(
      style: GoogleFonts.openSans(color: Colors.black87, fontSize: 20),
      children: children
    ),);
  }
  
  
}

class StoryOriginBox extends StatelessWidget {
  const StoryOriginBox({
    super.key,
    required this.story,
  });

  final Story story;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: Constant.kMarginMedium,
      children: [
        Wrap(
          spacing: Constant.kMarginSmall,
          children: [
            Text("Author", style: GoogleFonts.openSans(color: Colors.black87, fontWeight: FontWeight.bold),),
            Text(story.author, style: GoogleFonts.openSans(color: Constant.kSecondaryColor),)
          ],
        ),
        Wrap(
          spacing: Constant.kMarginSmall,
          children: [
            Text("From", style: GoogleFonts.openSans(color: Colors.black87, fontWeight: FontWeight.bold),),
            Text(story.reference, style: GoogleFonts.openSans(color: Constant.kSecondaryColor),)
          ],
        ),

      ],
    );
  }
}
