import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../provider/vocabulary_data.dart';

class DeleteWordAlert extends StatelessWidget {
  late int id;

  DeleteWordAlert(this.id, {super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      title: const Text("Delete Vocabulary Confirmation!!!"),
      content: const Text("Are you sure you want to delete this word?"),
      actions: [
        TextButton(
            onPressed: () {
              Provider.of<VocabularyData>(context, listen: false)
                  .deleteVocabulary(id);
              Navigator.pop(context);
            },
            child: const Text(
              "OK",
              style: TextStyle(color: Colors.red),
            )),
        TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"))
      ],
    );
  }
}

class ConfirmAlert extends StatelessWidget {
  Function confirmAction;
  String title;
  String content;

  ConfirmAlert(
      {super.key,
      required this.confirmAction,
      required this.title,
      required this.content});

  @override
  Widget build(BuildContext context) {
    return Platform.isIOS
        ? CupertinoAlertDialog(
            title: Text(title),
            actions: [
              TextButton(
                  onPressed: () => confirmAction(),
                  child: const Text(
                    "OK",
                    style: TextStyle(color: Colors.red),
                  )),
              TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Cancel"))
            ],
          )
        : AlertDialog(
            title: Text(title),
            content: Text(content),
            actions: [
              TextButton(
                  onPressed: () => confirmAction,
                  child: const Text(
                    "OK",
                    style: TextStyle(color: Colors.red),
                  )),
              TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Cancel"))
            ],
          );
  }
}
