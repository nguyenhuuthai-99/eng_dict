import 'package:eng_dict/provider/action_counter.dart';
import 'package:eng_dict/view/component/ipa_component.dart';
import 'package:eng_dict/view/utils/constants.dart';
import 'package:eng_dict/view/utils/custom_icon.dart';
import 'package:eng_dict/view/widgets/banner_ads_box.dart';
import 'package:eng_dict/view/widgets/expanded_word_box.dart';
import 'package:eng_dict/view/widgets/youglish_web_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../model/word_form.dart';

class WordTitleBox extends StatelessWidget {
  WordForm? wordForm;

  WordTitleBox({
    required this.wordForm,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: Constant.kGreyBackground,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20, vertical: Constant.kMarginSmall),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding:
                          const EdgeInsets.only(bottom: Constant.kMarginSmall),
                      child: Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        // textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text(
                            wordForm?.words?[0].wordTitle != null
                                ? wordForm!.words![0].wordTitle!
                                : "",
                            style: const TextStyle(
                                fontSize: 24,
                                color: Colors.black87,
                                fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            width: Constant.kMarginExtraSmall,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 6.0),
                            child: Text(
                              wordForm?.formTitle != null
                                  ? wordForm!.formTitle!
                                  : "",
                              style: const TextStyle(
                                  color: Constant.kGreyText,
                                  fontStyle: FontStyle.italic,
                                  fontSize: 15),
                            ),
                          )
                        ],
                      ),
                    ),
                    Wrap(
                      spacing: 20, // Space between children
                      runSpacing: 8.0, // Space between rows
                      children: [
                        if (wordForm?.usIPASoundURL != null ||
                            wordForm?.usIPA != null)
                          IPABox(
                            IPA:
                                wordForm?.usIPA != null ? wordForm!.usIPA! : "",
                            accent: "US",
                            soundURL: wordForm?.usIPASoundURL,
                          ),
                        IPABox(
                          IPA: wordForm?.ukIPA != null ? wordForm!.ukIPA! : "",
                          accent: "UK",
                          soundURL: wordForm?.ukIPASoundURL,
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          top: Constant.kMarginExtraSmall, left: 1),
                      child: GestureDetector(
                        onTap: () {
                          if (wordForm?.words?[0].wordTitle != null) {
                            youglishButtonTapped(
                                context: context,
                                word: wordForm!.words![0].wordTitle!);
                          }
                        },
                        child: const Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              CustomIcon.video,
                              color: Constant.kPrimaryColor,
                              size: 22,
                            ),
                            Padding(
                              padding: EdgeInsets.only(bottom: 2.0),
                              child: Text(
                                "  Youglish ",
                                style: TextStyle(
                                    color: Constant.kPrimaryColor,
                                    fontSize: 16),
                              ),
                            ),
                            Tooltip(
                              preferBelow: false,
                              verticalOffset: 10,
                              triggerMode: TooltipTriggerMode.tap,
                              message: "Real-world pronunciation in context.",
                              child: Icon(
                                Icons.help_outline,
                                size: 17,
                                color: Colors.grey,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        if (wordForm?.words?[0].wordTitle != null && wordForm?.idioms != null)
          ExpandedWordBox(
              wordTitle: wordForm!.words![0].wordTitle!,
              wordType: "idioms",
              wordItems: wordForm!.idioms!),
        if (wordForm?.words?[0].wordTitle != null &&
            wordForm?.phrasalVerbs != null)
          ExpandedWordBox(
              wordTitle: wordForm!.words![0].wordTitle!,
              wordType: "phrasal verbs",
              wordItems: wordForm!.phrasalVerbs!)
      ],
    );
  }

  void youglishButtonTapped(
      {required BuildContext context, required String word}) async {
    try {
      Provider.of<ActionCounter>(context, listen: false).incrementCounter();
    } catch (e) {
      debugPrint(e.toString());
    }
    showModalBottomSheet(
      enableDrag: false,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      context: context,
      builder: (context) {
        return YouglishWebView(word: word);
      },
    );
  }
}
