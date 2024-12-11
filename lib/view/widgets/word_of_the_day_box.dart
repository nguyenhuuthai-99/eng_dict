import 'package:eng_dict/model/word.dart';
import 'package:eng_dict/model/word_form.dart';
import 'package:eng_dict/view/utils/constants.dart';
import 'package:eng_dict/view/utils/custom_icon.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class WordOfTheDayBox extends StatelessWidget {
  final WordForm wordForm;
  late Word word;
  WordOfTheDayBox({
    super.key, required this.wordForm
  });

  init(){
    word = wordForm.word;
  }


  @override
  Widget build(BuildContext context) {
    init();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Word of the day", style: Constant.kHeadingTextStyle,),
        Container(
          padding: EdgeInsets.symmetric(horizontal:Constant.kMarginLarge, vertical: Constant.kMarginSmall),
          margin: EdgeInsets.only(top: Constant.kMarginExtraSmall),
          decoration: BoxDecoration(
              color: Constant.kGreyBackground,
              borderRadius: BorderRadius.circular(Constant.kBorderRadiusSmall)
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  word.wordTitle != null?Text(word.wordTitle!, style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600, color: Constant.kPrimaryColor),):SizedBox(),
                  const SizedBox(width: 5,),
                  wordForm.formTitle != null?Text(wordForm.formTitle!, style:  TextStyle(fontStyle: FontStyle.italic, color: Constant.kHeading2Color),):SizedBox(),
                  const Expanded(child: SizedBox()),
                  Icon(CustomIcon.book_mark, color: Constant.kPrimaryColor,size: 30,)
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: Constant.kMarginExtraSmall, bottom: Constant.kMarginSmall),
                child: Row(
                  children: [
                    wordForm.ukIPA != null?IPAComponents(accent: "UK", IPA: wordForm.ukIPA!,soundURL: "media/english/uk_pron/u/ukd/ukdis/ukdisun030.mp3"):SizedBox(),
                    const SizedBox(width: Constant.kMarginMedium,),
                    wordForm.usIPA != null ? IPAComponents(accent: "US", IPA: wordForm.usIPA!, soundURL: "media/english/us_pron/e/eus/eus71/eus71340.mp3",):SizedBox()

                  ],
                ),
              ),
              Text( word.definition, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w100, color: Constant.kHeading2Color)),
              const Padding(
                padding: EdgeInsets.only(top: Constant.kMarginMedium),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text("view more", style: TextStyle(color: Constant.kLightGreyText, fontSize: 15)),
                    Padding(
                      padding: EdgeInsets.only(top: 2.0, left: 6),
                      child: Icon(CustomIcon.arrow, color: Constant.kLightGreyText,size: 16,),
                    )

                  ],
                ),
              )
            ],
          ),
        )

      ],
    );
  }
}

class IPAComponents extends StatelessWidget {
  late bool canPlay;
  String accent;
  String IPA;
  String soundURL;
  IPAComponents({super.key,required this.accent, required this.IPA, required this.soundURL});

  Future<void> playSound()async {
    final AudioPlayer audioPlayer = AudioPlayer();
    String prefix = "https://dictionary.cambridge.org/";
    String url = prefix + soundURL;
    try{
      await audioPlayer.setUrl(url);
      await audioPlayer.play();
      await audioPlayer.dispose();
    }on PlayerException catch(e){
      print(e.message);

    }

  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async{
        await playSound();
        print("asdf");
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        textBaseline: TextBaseline.alphabetic,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 3.0),
            child: Icon(CustomIcon.speaker, color: Constant.kHeading2Color,),
          ),
          Padding(
              padding: EdgeInsets.symmetric(horizontal: Constant.kMarginExtraSmall),
              child: Text(accent, style: Constant.kHeading2TextStyle,)),
          Text(IPA,style: Constant.kIPATextStyle,)
        ],
      ),
    );
  }
}