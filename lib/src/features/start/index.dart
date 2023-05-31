import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:triviazilla/src/features/start/answer.dart';
import 'package:triviazilla/src/features/start/result.dart';
import 'package:triviazilla/src/model/question_model.dart';

import '../../model/trivia_model.dart';

class StartTrivia extends StatefulWidget {
  const StartTrivia({super.key, required this.trivia});
  final TriviaModel trivia;

  @override
  State<StartTrivia> createState() => _StartTriviaState();
}

class _StartTriviaState extends State<StartTrivia> {
  final PageController pageController = PageController(initialPage: 0);
  int score = 0;

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
            onSubmit: (result) {
              if (result) setState(() => score++);
              print("score: $score");

              if (index + 1 == widget.trivia.questions.length) {
                print("Last index!");
                print(
                    "FINAL SCORE: $score / ${widget.trivia.questions.length}");

                Navigator.pushAndRemoveUntil(
                  context,
                  PageTransition(
                    type: PageTransitionType.topToBottom,
                    child: StartTriviaResult(
                      trivia: widget.trivia,
                      questionLength: widget.trivia.questions.length,
                      score: score,
                    ),
                  ),
                  (route) => route.isFirst,
                );
              } else {
                print("On to the next page");
                pageController.nextPage(
                  duration: const Duration(milliseconds: 777),
                  curve: Curves.bounceIn,
                );
              }
            },
            question: question,
          );
        },
      ),
    );
  }
}
