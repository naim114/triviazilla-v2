import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:triviazilla/src/widgets/button/answer_button.dart';
import 'package:triviazilla/src/widgets/button/time_button.dart';
import 'package:triviazilla/src/widgets/editor/answer_editor.dart';

import '../appbar/appbar_confirm_cancel.dart';

class QuestionEditor extends StatefulWidget {
  const QuestionEditor({
    super.key,
    required this.onConfirm,
    this.question,
  });

  final Function(Map<String, dynamic> question) onConfirm;
  final Map<String, dynamic>? question;

  @override
  State<QuestionEditor> createState() => _QuestionEditorState();
}

class _QuestionEditorState extends State<QuestionEditor> {
  bool _loading = false;

  double secondsLimit = 5;
  final TextEditingController textController = TextEditingController();
  List<Map<String, dynamic>> answers = List.empty(growable: true);

  bool ansCheck() {
    // check if all answer is false
    for (var ans in answers) {
      if (ans['isCorrect'] == true) {
        return true;
      }
    }

    return false;
  }

  bool confirm() {
    if (textController.text.isEmpty) {
      Fluttertoast.showToast(msg: "Question can't be empty");

      return false;
    } else if (answers.isEmpty) {
      Fluttertoast.showToast(msg: "Answers can't be empty");

      return false;
    } else if (!ansCheck()) {
      Fluttertoast.showToast(msg: "All answers can't be incorrect");

      return false;
    } else if (answers.length < 2) {
      Fluttertoast.showToast(msg: "Answers can't only be just one");

      return false;
    }

    setState(() => _loading = true);

    Map<String, dynamic> question = {
      'text': textController.text,
      'answers': answers,
      'secondsLimit': secondsLimit,
    };

    widget.onConfirm(question);

    return true;
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    if (widget.question != null) {
      textController.text = widget.question!['text'];
      answers = widget.question!['answers'];
      secondsLimit = widget.question!['secondsLimit'];
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _loading
          ? null
          : appBarConfirmCancel(
              onCancel: () => Navigator.pop(context),
              onConfirm: () {
                var res = confirm();
                if (res) Navigator.pop(context);
              },
              title: widget.question == null ? "Add Question" : "Edit Question",
              context: context,
            ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: ListView(
                children: [
                  // Time
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Row(
                      children: [
                        timeButton(
                          secondsLimit: secondsLimit,
                          onPressed: () => timeAlert(context),
                        ),
                      ],
                    ),
                  ),
                  // Title
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 15,
                    ),
                    child: TextField(
                      controller: textController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.all(15),
                        labelText: 'Question',
                        hintText: 'Enter question',
                        focusColor: CupertinoColors.systemGrey,
                        hoverColor: CupertinoColors.systemGrey,
                      ),
                    ),
                  ),
                  // Answers
                  const Padding(
                    padding: EdgeInsets.only(left: 20, right: 20, top: 5),
                    child: Text(
                      'Answers',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 20,
                      right: 20,
                      bottom: 20,
                      top: 10,
                    ),
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: () async {
                            Map<String, dynamic>? newAnswer =
                                await showAnswerEditorModal(context: context);

                            print('answer: $newAnswer');

                            if (newAnswer != null) {
                              setState(() {
                                answers.add(newAnswer);
                              });
                            }
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Center(
                                child: Text(
                                  "+ Tap to add a answer",
                                  style: TextStyle(color: Colors.grey[800]),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Column(
                          children: List.generate(
                            answers.length,
                            (i) => Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: answerButton(
                                text: answers[i]['text'],
                                onTap: () async {
                                  Map<String, dynamic>? editedAnswer =
                                      await showAnswerEditorModal(
                                    context: context,
                                    answer: answers[i],
                                  );

                                  if (editedAnswer != null) {
                                    setState(() {
                                      answers[i] = editedAnswer;
                                    });
                                  }
                                },
                                isCorrect: answers[i]['isCorrect'],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Future<void> timeAlert(BuildContext context) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            "Choose time limit for this question",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 3),
                        child: timeButton(
                            secondsLimit: 5,
                            onPressed: () {
                              setState(() => secondsLimit = 5);
                              Navigator.pop(context);
                            }),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 3),
                        child: timeButton(
                            secondsLimit: 10,
                            onPressed: () {
                              setState(() => secondsLimit = 10);
                              Navigator.pop(context);
                            }),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 3),
                        child: timeButton(
                            secondsLimit: 20,
                            onPressed: () {
                              setState(() => secondsLimit = 20);
                              Navigator.pop(context);
                            }),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 3),
                        child: timeButton(
                            secondsLimit: 30,
                            onPressed: () {
                              setState(() => secondsLimit = 30);
                              Navigator.pop(context);
                            }),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 3),
                        child: timeButton(
                            secondsLimit: 60,
                            onPressed: () {
                              setState(() => secondsLimit = 60);
                              Navigator.pop(context);
                            }),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 3),
                        child: timeButton(
                            secondsLimit: 90,
                            onPressed: () {
                              setState(() => secondsLimit = 90);
                              Navigator.pop(context);
                            }),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 3),
                        child: timeButton(
                            secondsLimit: 120,
                            onPressed: () {
                              setState(() => secondsLimit = 120);
                              Navigator.pop(context);
                            }),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 3),
                        child: timeButton(
                            secondsLimit: 180,
                            onPressed: () {
                              setState(() => secondsLimit = 180);
                              Navigator.pop(context);
                            }),
                      ),
                    ),
                  ],
                ),
                timeButton(
                    secondsLimit: 240,
                    onPressed: () {
                      setState(() => secondsLimit = 240);
                      Navigator.pop(context);
                    }),
              ],
            ),
          ),
        );
      },
    );
  }
}
