import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:triviazilla/src/model/answer_model.dart';
import 'package:triviazilla/src/model/question_model.dart';

import '../../services/helpers.dart';

Widget listTileAnswer({
  required QuestionModel question,
}) {
  AnswerModel? chosenAnswer;

  for (var ans in question.answers) {
    if (ans.isChosen) chosenAnswer = ans;
  }

  return Padding(
    padding: const EdgeInsets.only(bottom: 8.0),
    child: ListTile(
      leading: chosenAnswer == null
          ? const Icon(
              CupertinoIcons.clear_circled,
              color: CustomColor.danger,
              size: 50,
            )
          : chosenAnswer.isCorrect
              ? const Icon(
                  Icons.check_circle_outline_rounded,
                  color: CustomColor.success,
                  size: 50,
                )
              : const Icon(
                  CupertinoIcons.clear_circled,
                  color: CustomColor.danger,
                  size: 50,
                ),
      title: Text(
        question.text,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: CustomColor.neutral1,
        ),
      ),
      subtitle: Text.rich(
        TextSpan(
          style: const TextStyle(color: CustomColor.neutral1),
          children: [
            const TextSpan(
                text: "Your answer: ",
                style: TextStyle(fontWeight: FontWeight.bold)),
            TextSpan(
              text:
                  chosenAnswer == null ? "Ran out of time" : chosenAnswer.text,
            ),
          ],
        ),
      ),
    ),
  );
}
