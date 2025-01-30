import 'package:eng_dict/model/linked_word.dart';
import 'package:eng_dict/model/word.dart';
import 'package:eng_dict/view/component/toggle_save_button.dart';
import 'package:eng_dict/view/utils/build_clickable_text.dart';
import 'package:eng_dict/view/utils/code_table.dart';
import 'package:eng_dict/view/utils/constants.dart';
import 'package:eng_dict/view/widgets/dictionary/code_explanation_box.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../model/example.dart';

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
                    if (word!.level != null)
                      Tooltip(
                        message: CodeTable.CEFRTable[word!.level!],
                        triggerMode: TooltipTriggerMode.tap,
                        preferBelow: false,
                        showDuration: const Duration(milliseconds: 2500),
                        textStyle: Constant.kToolTipTextStyle,
                        margin: const EdgeInsets.symmetric(
                            horizontal: Constant.kMarginSmall),
                        decoration: const BoxDecoration(
                            color: Constant.kPrimaryColor,
                            borderRadius: BorderRadius.all(
                                Radius.circular(Constant.kMarginExtraSmall))),
                        child: Text(
                          "${word!.level!}  ",
                          style: Constant.kWordLevelTextStyle,
                        ),
                      ),
                    if (word!.code != null)
                      GestureDetector(
                        onTap: () => showCodeExplanation(),
                        child: Text("${word!.code!} ",
                            style: Constant.kUsageAndCodeTextStyle),
                      ),
                    if (word!.usage != null)
                      Text("${word!.usage!} ",
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
          if (word!.synonyms != null)
            buildAdditionalWord("Synonyms", word!.synonyms!),
          if (word!.compare != null)
            buildAdditionalWord("Compare", word!.compare!),
          if (word!.seeAlso != null)
            buildAdditionalWord("See Also", word!.seeAlso!),
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

  void showCodeExplanation() {
    showModalBottomSheet(
      enableDrag: true,
      isScrollControlled: true,
      useSafeArea: true,
      showDragHandle: true,
      context: context,
      builder: (context) => CodeExplanationBox(),
    );
  }

  Widget buildAdditionalWord(String title, List<LinkedWord> words) {
    return Padding(
      padding: const EdgeInsets.only(bottom: Constant.kMarginLarge),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Constant.kAdditionalType,
          ),
          Padding(
              padding: const EdgeInsets.only(left: Constant.kMarginMedium),
              child: buildAdditionChildren(words))
        ],
      ),
    );
  }

  ListView buildAdditionChildren(List<LinkedWord> words) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (context, index) => buildAdditionalChild(words[index]),
      itemCount: words.length,
    );
  }

  RichText buildAdditionalChild(LinkedWord word) {
    final title =
        BuildClickableText.buildClickableWord("${word.title} ", context);
    final titleTextSpan =
        TextSpan(children: [title], style: Constant.kAdditionalTitle);
    final justification = TextSpan(
        text: "${word.justification} ",
        style: Constant.kAdditionalJustification);
    final usage =
        TextSpan(text: "${word.usage} ", style: Constant.kAdditionalUsage);
    final form =
        TextSpan(text: "${word.form} ", style: Constant.kAdditionalUsage);

    List<TextSpan> additionalWords = [
      Constant.kDot,
      titleTextSpan,
      if (word.justification!.isNotEmpty) justification,
      if (word.form!.isNotEmpty) form,
      if (word.usage!.isNotEmpty) usage
    ];
    return RichText(
        text: TextSpan(
      children: additionalWords,
    ));
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

    TextSpan exampleCodeSpan = example.code != null
        ? TextSpan(
            style: Constant.kUsageAndCodeTextStyle,
            text: "${example.code!} ",
            recognizer: TapGestureRecognizer()
              ..onTap = () => showCodeExplanation())
        : const TextSpan();

    TextSpan toGoWithTextSpan = TextSpan(
        style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Constant.kPrimaryColor,
            fontStyle: FontStyle.italic),
        children: toGoWith);

    TextSpan exampleTextSpan = TextSpan(
        style: const TextStyle(color: Colors.black87), children: children);

    return RichText(
        text: TextSpan(
            style: const TextStyle(
              fontSize: 15,
              letterSpacing: 0.1,
              height: 1.5,
            ),
            children: [
          Constant.kDotExample,
          exampleCodeSpan,
          toGoWithTextSpan,
          exampleTextSpan
        ]));
  }
}
