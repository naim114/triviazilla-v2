import 'dart:async';

import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:triviazilla/src/features/start/index.dart';
import 'package:triviazilla/src/model/trivia_model.dart';
import 'package:triviazilla/src/widgets/image/logo_main.dart';

import '../../model/user_model.dart';

class StartTriviaCountdown extends StatefulWidget {
  const StartTriviaCountdown({
    super.key,
    required this.trivia,
    required this.user,
  });
  final UserModel user;
  final TriviaModel trivia;

  @override
  State<StartTriviaCountdown> createState() => _StartTriviaCountdownState();
}

class _StartTriviaCountdownState extends State<StartTriviaCountdown> {
  int countdownValue = 5;

  @override
  void initState() {
    super.initState();
    startCountdown();
  }

  void startCountdown() {
    Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        countdownValue--;
        if (countdownValue <= 0) {
          timer.cancel();
          Navigator.pushAndRemoveUntil(
            context,
            PageTransition(
              type: PageTransitionType.fade,
              child: StartTrivia(
                trivia: widget.trivia,
                user: widget.user,
              ),
            ),
            (route) => route.isFirst,
          );
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            logoMain(context: context),
            Text(
              widget.trivia.title,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            SizedBox(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Starting in...',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 28,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    countdownValue.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 50,
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
}
