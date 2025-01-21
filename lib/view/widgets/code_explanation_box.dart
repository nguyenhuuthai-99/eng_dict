import 'package:eng_dict/view/utils/code_table.dart';
import 'package:eng_dict/view/utils/constants.dart';
import 'package:flutter/material.dart';

class CodeExplanationBox extends StatelessWidget {
  final Map<String, dynamic> codeMap = CodeTable.dictionaryLabels;
  CodeExplanationBox({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView(
        children: [
          const Text(
            "Code Table",
            style: Constant.kCodeTable,
          ),
          buildCodeBox("Adjectives"),
          buildCodeBox("Nouns"),
          buildCodeBox("Verbs"),
          buildCodeBox("Other labels"),
        ],
      ),
    );
  }

  Map<String, String>? getCode(String form) {
    if (!codeMap.containsKey(form)) {
      return null;
    }
    return CodeTable.dictionaryLabels[form];
  }

  Widget buildCodeBox(String form) {
    Map<String, String>? formMap = getCode(form);
    if (formMap == null) {
      return const SizedBox();
    }

    final entries = formMap.entries.toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          form,
          style: Constant.kCodeHeading,
        ),
        ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: entries.length,
          itemBuilder: (context, index) => Container(
            padding: const EdgeInsets.all(Constant.kMarginSmall),
            decoration: const BoxDecoration(
                border:
                    Border(bottom: BorderSide(color: Constant.kGreyDivider))),
            child: Row(
              children: [
                SizedBox(
                    width: 130,
                    child: Text(
                      entries[index].key,
                      style: TextStyle(color: Constant.kSecondaryColor),
                    )),
                Flexible(child: Text(entries[index].value))
              ],
            ),
          ),
        )
      ],
    );
  }
}
