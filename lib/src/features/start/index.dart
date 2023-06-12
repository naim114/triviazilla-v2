import 'dart:math';

import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:triviazilla/src/features/start/answer.dart';
import 'package:triviazilla/src/features/start/result.dart';
import 'package:triviazilla/src/model/question_model.dart';
import 'package:triviazilla/src/model/user_model.dart';
import 'package:triviazilla/src/services/helpers.dart';
import 'package:triviazilla/src/services/record_service.dart';

import '../../model/record_trivia_model.dart';
import '../../model/trivia_model.dart';

class StartTrivia extends StatefulWidget {
  const StartTrivia({
    super.key,
    required this.trivia,
    required this.user,
  });
  final TriviaModel trivia;
  final UserModel user;

  @override
  State<StartTrivia> createState() => _StartTriviaState();
}

class _StartTriviaState extends State<StartTrivia> {
  final PageController pageController = PageController(initialPage: 0);
  int score = 0;
  int correctCount = 0;
  List<QuestionModel> recordQuestion = List.empty(growable: true);

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: pageController,
      pageSnapping: false,
      physics: const NeverScrollableScrollPhysics(),
      children: List.generate(
        widget.trivia.questions.length,
        (index) {
          QuestionModel question = widget.trivia.questions[index];

          return StartTriviaAnswer(
            questionNo: index + 1,
            triviaLength: widget.trivia.questions.length,
            onSubmit: (result, timeLeft, recordAnswers, isLate) {
              // Correct grant 10 points
              if (result) {
                setState(() {
                  score = score + 10;
                  correctCount++;
                });
                print("CORRECT POINTS: 10");
              }

              // Time points
              if (!isLate) {
                setState(() => score =
                    score + ((timeLeft / question.secondsLimit) * 10).round());
                print(
                    "TIME POINTS: ${((timeLeft / question.secondsLimit) * 10).round()}");
              }

              print("current score: $score");

              // Add to Record
              setState(() {
                recordQuestion.add(QuestionModel(
                  text: question.text,
                  answers: recordAnswers,
                  secondsLimit: question.secondsLimit,
                  timeLeft: timeLeft,
                ));
              });

              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (_) {
                  Future.delayed(const Duration(seconds: 5), () {
                    Navigator.of(context).pop(true);
                  });
                  final random = Random();

                  return Dialog(
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    child: Container(
                      alignment: FractionalOffset.center,
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          isLate
                              ? Image.asset(
                                  customMsg.lateGIF[
                                      random.nextInt(customMsg.lateGIF.length)],
                                  errorBuilder: (context, error, stackTrace) =>
                                      const SizedBox())
                              : Image.asset(
                                  result
                                      ? customMsg.trueGIF[random
                                          .nextInt(customMsg.trueGIF.length)]
                                      : customMsg.falseGIF[random
                                          .nextInt(customMsg.falseGIF.length)],
                                  errorBuilder: (context, error, stackTrace) =>
                                      const SizedBox(),
                                ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Text(
                              // "Correct",
                              isLate
                                  ? "TIMES UP!!"
                                  : result
                                      ? "CORRECT!"
                                      : "INCORRECT!",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 30,
                                color:
                                    result ? Colors.green : CustomColor.danger,
                                fontFamily: "RobotoSlab",
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Text(
                            isLate
                                ? customMsg.lateWord[
                                    random.nextInt(customMsg.lateWord.length)]
                                : result
                                    ? customMsg.trueWord[random
                                        .nextInt(customMsg.trueWord.length)]
                                    : customMsg.falseWord[random
                                        .nextInt(customMsg.falseWord.length)],
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            "Current Score: ${score}PTS",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ).then((_) async {
                if (index + 1 == widget.trivia.questions.length) {
                  print("Last index!");
                  print("FINAL SCORE: $score");

                  RecordTriviaModel? record = await RecordServices().add(
                    trivia: widget.trivia,
                    user: widget.user,
                    questions: recordQuestion,
                    correctCount: correctCount,
                    score: score,
                  );

                  if (record != null && context.mounted) {
                    Navigator.pushAndRemoveUntil(
                      context,
                      PageTransition(
                        type: PageTransitionType.topToBottom,
                        child: StartTriviaResult(
                          trivia: widget.trivia,
                          record: record,
                          user: widget.user,
                        ),
                      ),
                      (route) => route.isFirst,
                    );
                  }
                } else {
                  print("On to the next page");
                  pageController.nextPage(
                    duration: const Duration(milliseconds: 777),
                    curve: Curves.bounceIn,
                  );
                }
              });
            },
            question: question,
          );
        },
      ),
    );
  }
}
