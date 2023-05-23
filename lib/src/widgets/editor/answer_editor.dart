import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

Future<Map<String, dynamic>?> showAnswerEditorModal({
  required BuildContext context,
  Map<String, dynamic>? answer,
}) async {
  TextEditingController textEditingController = TextEditingController();
  bool isCorrect = false;
  Map<String, dynamic> newAnswer = {
    'text': null,
    'isCorrect': null,
  };

  if (answer != null) {
    textEditingController.text = answer['text'];
    isCorrect = answer['isCorrect'];
  }

  return await showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(answer == null ? 'Add Answers' : 'Edit Answers'),
        content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          return SizedBox(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: textEditingController,
                  decoration: const InputDecoration(
                    labelText: 'Enter Text',
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 15, bottom: 5),
                  child: Text(
                    'Correct Answer',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
                Center(
                  child: Switch(
                    value: isCorrect,
                    onChanged: (bool value) {
                      setState(() => isCorrect = value);
                    },
                  ),
                ),
              ],
            ),
          );
        }),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text(
              'Close',
              style: TextStyle(color: Colors.grey),
            ),
          ),
          TextButton(
            onPressed: () {
              if (textEditingController.text.isEmpty) {
                Fluttertoast.showToast(msg: 'Please enter answer');
              } else {
                newAnswer['text'] = textEditingController.text;
                newAnswer['isCorrect'] = isCorrect;

                Navigator.of(context).pop(newAnswer);
              }
            },
            child: const Text('Save'),
          ),
        ],
      );
    },
  );
}
