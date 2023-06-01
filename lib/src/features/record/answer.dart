import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../model/answer_model.dart';
import '../../model/question_model.dart';
import '../../services/helpers.dart';

class RecordAnswer extends StatelessWidget {
  const RecordAnswer({super.key, required this.questions});
  final List<QuestionModel> questions;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text("Answer Review"),
        centerTitle: true,
      ),
      body: ListView(
        children: List.generate(questions.length, (index) {
          QuestionModel question = questions[index];

          AnswerModel? chosenAnswer;
          List<AnswerModel> correctAnswers = List.empty(growable: true);

          for (var ans in question.answers) {
            if (ans.isChosen) chosenAnswer = ans;
            if (ans.isCorrect) correctAnswers.add(ans);
          }
          return ExpansionTile(
            leading: chosenAnswer == null
                ? const Icon(
                    CupertinoIcons.clear_circled,
                    color: CustomColor.danger,
                  )
                : chosenAnswer.isCorrect
                    ? const Icon(
                        Icons.check_circle_outline_rounded,
                        color: CustomColor.success,
                      )
                    : const Icon(
                        CupertinoIcons.clear_circled,
                        color: CustomColor.danger,
                      ),
            title: Text(
              question.text,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: CustomColor.neutral1,
              ),
            ),
            children: [
              ListTile(
                title: const Text(
                  "Your Answer :",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                subtitle: Text(
                  chosenAnswer == null ? "Ran out of time" : chosenAnswer.text,
                ),
              ),
              correctAnswers.isEmpty
                  ? const SizedBox()
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: List.generate(
                        correctAnswers.length,
                        (index) => ListTile(
                          title: const Text(
                            "Correct Answer :",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(correctAnswers[index].text),
                            ],
                          ),
                        ),
                      ),
                    ),
            ],
          );
        }),
      ),
    );
  }
}
