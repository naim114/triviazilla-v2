import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:triviazilla/src/features/start/answer.dart';
import 'package:triviazilla/src/features/start/result.dart';

class StartTrivia extends StatefulWidget {
  const StartTrivia({super.key});

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
      children: [
        StartTriviaAnswer(
          questionNo: 1,
          triviaLength: 3,
          onSubmit: (result) {
            if (result) setState(() => score++);
            print("score: $score");

            print("On to the next page");
            pageController.nextPage(
              duration: const Duration(milliseconds: 777),
              curve: Curves.bounceIn,
            );
          },
        ),
        StartTriviaAnswer(
          questionNo: 2,
          triviaLength: 3,
          onSubmit: (result) {
            if (result) setState(() => score++);
            print("score: $score");

            print("On to the next page");
            pageController.nextPage(
              duration: const Duration(milliseconds: 777),
              curve: Curves.bounceIn,
            );
          },
        ),
        StartTriviaAnswer(
          questionNo: 3,
          triviaLength: 3,
          onSubmit: (result) {
            if (result) setState(() => score++);
            print("score: $score");

            print("LAST!!!!!!!!");
            Navigator.pushAndRemoveUntil(
              context,
              PageTransition(
                type: PageTransitionType.topToBottom,
                child: StartTriviaResult(),
              ),
              (route) => route.isFirst,
            );
          },
        ),
      ],
    );
  }
}
