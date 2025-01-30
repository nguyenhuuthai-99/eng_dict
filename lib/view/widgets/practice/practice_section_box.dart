import 'package:eng_dict/view/utils/constants.dart';
import 'package:flutter/material.dart';

class PracticeSectionBox extends StatelessWidget {
  String title;
  String subTitle;
  Widget nextScreen;
  AssetImage image;
  PracticeSectionBox(
      {super.key,
      required this.title,
      required this.subTitle,
      required this.nextScreen,
      required this.image});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          vertical: Constant.kMarginSmall, horizontal: Constant.kMarginLarge),
      child: GestureDetector(
        onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => nextScreen,
            )),
        child: Card(
          color: Constant.kGreyBackground,
          child: Container(
            padding: const EdgeInsets.symmetric(
                horizontal: Constant.kMarginLarge,
                vertical: Constant.kMarginMedium),
            height: 100,
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: Constant.kSectionTitle,
                      ),
                      Text(
                        subTitle,
                        style: Constant.kSectionSubTitle,
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  width: Constant.kMarginLarge,
                ),
                Expanded(flex: 1, child: Image(image: image))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
