import 'package:eng_dict/view/utils/constants.dart';
import 'package:flutter/material.dart';

class HomeScreenSectionBox extends StatelessWidget {
  late String title;
  String heading;
  String subTitle;
  AssetImage image;
  Widget screen;
  HomeScreenSectionBox(
      {super.key,
      required this.title,
      required this.heading,
      required this.subTitle,
      required this.image,
      required this.screen});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: Constant.kMarginLarge),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            heading,
            style: Constant.kHeadingTextStyle,
          ),
          Padding(
            padding: const EdgeInsets.only(top: Constant.kMarginExtraSmall),
            child: GestureDetector(
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => screen,
                  )),
              child: Container(
                padding: EdgeInsets.symmetric(
                    horizontal: Constant.kMarginLarge,
                    vertical: Constant.kMarginSmall),
                decoration: const BoxDecoration(
                    color: Constant.kGreyBackground,
                    boxShadow: [
                      BoxShadow(
                        color: Color(0x26000000),
                        offset: Offset(0, 2),
                        blurRadius: 3,
                      ),
                    ],
                    borderRadius: BorderRadius.all(
                        Radius.circular(Constant.kMarginSmall))),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 6,
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
                      width: Constant.kMarginExtraLarge,
                    ),
                    Flexible(
                        flex: 5,
                        child: Image(
                          image: image,
                        ))
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
