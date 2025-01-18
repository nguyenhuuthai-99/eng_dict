import 'package:eng_dict/model/word.dart';
import 'package:eng_dict/view/component/toggle_save_button.dart';
import 'package:eng_dict/view/utils/build_clickable_text.dart';
import 'package:eng_dict/view/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../model/example.dart';

class DefinitionBox extends StatelessWidget {
  Word? word;
  late BuildContext context;

  DefinitionBox({
    required this.word,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    this.context = context;
    if (word == null) {
      return const SizedBox();
    }
    if (word!.isPhrase) {
      return buildPhraseBox(context);
    }
    return buildWordBox();
  }

  Widget buildWordBox() {
    return Padding(
      padding: const EdgeInsets.only(
          top: Constant.kMarginMedium,
          left: Constant.kMarginMedium,
          right: Constant.kMarginMedium,
          bottom: Constant.kMarginSmall),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    Text(
                      word!.level != null ? word!.level! : "",
                      style: GoogleFonts.inter(
                          fontWeight: FontWeight.w700,
                          fontStyle: FontStyle.italic,
                          fontSize: 20,
                          color: Constant.kPrimaryColor),
                    ),
                    const SizedBox(
                      width: Constant.kMarginMedium,
                    ),
                    if (word!.code != null)
                      Text(word!.code!, style: Constant.kUsageAndCodeTextStyle),
                    const SizedBox(
                      width: Constant.kMarginMedium,
                    ),
                    if (word!.usage != null)
                      Text(word!.usage!,
                          style: Constant.kUsageAndCodeTextStyle),
                  ],
                ),
              ),
              ToggleSaveButton(
                word: word,
              )
            ],
          ),
          buildDefinitionText(word!.definition),
          Padding(
            padding: const EdgeInsets.only(
                left: Constant.kMarginMedium,
                top: Constant.kMarginExtraSmall,
                bottom: Constant.kMarginSmall),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: buildExampleBox(word!.examples),
            ),
          ),
          SizedBox(
            height: 1,
            width: double.infinity,
            child: Container(
              color: Constant.kGreyLine,
            ),
          )
        ],
      ),
    );
  }

  List<Widget> buildExampleBox(List<Example>? examples) {
    if (examples == null) {
      return [];
    }
    return examples
        .map(
          (e) => buildExample(e),
        )
        .toList();
  }

  Widget buildPhraseBox(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(
              horizontal: Constant.kMarginMedium,
              vertical: Constant.kMarginMedium),
          color: Constant.kGreyBackground,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                      child: word!.phraseTitle != null
                          ? buildPhraseTitle(word!.phraseTitle!)
                          : const SizedBox()),
                  ToggleSaveButton(
                    word: word,
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: Constant.kMarginMedium),
                child: Container(
                  height: 1,
                  color: Constant.kGreyLine,
                ),
              ),
              buildDefinitionText(word!.definition),
              Padding(
                padding: const EdgeInsets.only(
                    left: Constant.kMarginMedium,
                    top: Constant.kMarginExtraSmall),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: buildExampleBox(word!.examples),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: Constant.kMarginLarge,
        )
      ],
    );
  }

  RichText buildPhraseTitle(String title) {
    return RichText(
        text: TextSpan(
            style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Constant.kPrimaryColor),
            children: BuildClickableText.buildClickableTextSpan(
                text: title, context: context)));
  }

  RichText buildDefinitionText(String text) {
    return RichText(
        text: TextSpan(
            style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: Constant.kHeading1Color),
            children: BuildClickableText.buildClickableTextSpan(
                text: text, context: context)));
  }

  Widget buildExample(Example example) {
    if (example.example == null) {
      return const SizedBox();
    }
    List<TextSpan> toGoWith = example.toGoWith != null
        ? BuildClickableText.buildClickableTextSpan(
            text: "${example.toGoWith!}  ", context: context)
        : [];
    List<TextSpan> children = BuildClickableText.buildClickableTextSpan(
        text: example.example!, context: context);

    TextSpan toGoWithTextSpan = TextSpan(
        style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Constant.kPrimaryColor,
            fontStyle: FontStyle.italic),
        children: toGoWith);

    TextSpan exampleTextSpan = TextSpan(
        style: const TextStyle(color: Colors.black87), children: children);

    toGoWith.insert(
        0, const TextSpan(style: TextStyle(fontSize: 18), text: "• "));
    return RichText(
        text: TextSpan(
            style: const TextStyle(
              fontSize: 15,
              letterSpacing: 0.1,
              height: 1.5,
            ),
            children: [toGoWithTextSpan, exampleTextSpan]));
  }
}
