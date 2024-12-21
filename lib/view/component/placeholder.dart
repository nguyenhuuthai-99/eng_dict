import 'package:eng_dict/view/utils/constants.dart';
import 'package:flutter/material.dart';

const double kLineSpace = 5;

class WordTitlePlaceholder extends StatelessWidget {
  const WordTitlePlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: Constant.kMarginSmall),
      height: 120,
      color: Constant.kGreyBackground,
    );
  }
}

class DefinitionPlaceholder extends StatelessWidget {
  const DefinitionPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Constant.kMarginLarge),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: kLineSpace),
            height: 22,
            color: Colors.grey.shade300,
          ),
          Container(
            margin: const EdgeInsets.only(bottom: kLineSpace),
            height: 22,
            width: 300,
            color: Colors.grey.shade300,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: Constant.kMarginSmall,
                vertical: Constant.kMarginSmall),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(bottom: kLineSpace),
                  height: 20,
                  color: Colors.grey,
                ),
                Container(
                  margin: const EdgeInsets.only(bottom: kLineSpace),
                  height: 20,
                  width: 70,
                  color: Colors.grey,
                ),
                Container(
                  margin: const EdgeInsets.only(bottom: kLineSpace),
                  height: 20,
                  color: Colors.grey.shade200,
                ),
                Container(
                  margin: const EdgeInsets.only(bottom: kLineSpace),
                  height: 20,
                  width: 280,
                  color: Colors.grey.shade200,
                ),
                Container(
                  margin: const EdgeInsets.only(bottom: kLineSpace),
                  height: 20,
                  color: Colors.grey.shade200,
                ),
                Container(
                  margin: const EdgeInsets.only(bottom: kLineSpace),
                  height: 20,
                  width: 150,
                  color: Colors.grey.shade200,
                ),
                Container(
                  margin: const EdgeInsets.only(bottom: kLineSpace),
                  height: 20,
                  color: Colors.grey.shade200,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class TabBarPlaceHolder extends StatelessWidget {
  const TabBarPlaceHolder({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: Constant.kMarginLarge, vertical: Constant.kMarginSmall),
      child: Row(
        children: [
          Container(
            color: Colors.grey.shade300,
            height: 20,
            width: 100,
          ),
          Container(
            margin: const EdgeInsets.only(left: 20),
            color: Colors.grey.shade300,
            height: 20,
            width: 100,
          )
        ],
      ),
    );
  }
}
