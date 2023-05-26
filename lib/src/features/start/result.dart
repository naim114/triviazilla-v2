import 'package:confetti/confetti.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import 'package:triviazilla/src/services/helpers.dart';
import 'package:triviazilla/src/widgets/list_tile/list_tile_answer.dart';

import '../../widgets/button/custom_pill_button.dart';
import 'countdown.dart';

class StartTriviaResult extends StatefulWidget {
  const StartTriviaResult({super.key});

  @override
  State<StartTriviaResult> createState() => _StartTriviaResultState();
}

class _StartTriviaResultState extends State<StartTriviaResult> {
  late ConfettiController _controllerTopCenter;

  @override
  void initState() {
    super.initState();
    // TODO save result function here
    _controllerTopCenter =
        ConfettiController(duration: const Duration(seconds: 3));
    _controllerTopCenter.play();
  }

  @override
  void dispose() {
    _controllerTopCenter.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColor.secondary,
      body: Stack(
        children: [
          Align(
            alignment: Alignment.center,
            child: ListView(
              children: [
                // Box Score
                Padding(
                  padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
                  child: Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "QUIZ NAME",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                            ),
                          ),
                          Text(
                            "Is this a rhinosaurus?",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: Row(
                              children: [
                                Expanded(
                                  child: CircularPercentIndicator(
                                    radius: 60.0,
                                    lineWidth: 10,
                                    percent: 0.8,
                                    backgroundColor:
                                        CupertinoColors.lightBackgroundGray,
                                    center: Text.rich(
                                      TextSpan(
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                        children: [
                                          TextSpan(
                                            text: "8",
                                            style: const TextStyle(
                                              fontSize: 30,
                                            ),
                                          ),
                                          TextSpan(
                                            text: "/10",
                                            style: const TextStyle(
                                              fontSize: 20,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    progressColor: CustomColor.primary,
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    "You answered 8 out of 10 questions",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                //  Answer Review
                const Padding(
                  padding: EdgeInsets.only(
                    top: 10,
                    bottom: 5,
                    left: 20,
                    right: 20,
                  ),
                  child: Text(
                    "Your Answer",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: CustomColor.neutral1,
                      fontSize: 18,
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 20, right: 20, bottom: 20),
                  child: Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: [
                          listTileAnswer(isCorrect: true),
                          listTileAnswer(isCorrect: false),
                          listTileAnswer(isCorrect: true),
                          listTileAnswer(isCorrect: false),
                        ],
                      ),
                    ),
                  ),
                ),
                // Buttons
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: customPillButton(
                    width: MediaQuery.of(context).size.width * 0.9,
                    context: context,
                    borderColor: Colors.black,
                    fillColor: Colors.white,
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        PageTransition(
                          type: PageTransitionType.topToBottom,
                          child: StartTriviaCountdown(),
                        ),
                      );
                    },
                    child: const Text(
                      'Try Again',
                      style: TextStyle(
                        color: CustomColor.neutral1, // Text color
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: customPillButton(
                    width: MediaQuery.of(context).size.width * 0.9,
                    context: context,
                    borderColor: CupertinoColors.darkBackgroundGray,
                    fillColor: CupertinoColors.darkBackgroundGray,
                    onPressed: () => Navigator.pop(context),
                    child: const Text(
                      'Finish',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _controllerTopCenter,
              blastDirectionality: BlastDirectionality.explosive,
              minBlastForce: 10,
              maxBlastForce: 15,
              emissionFrequency: 0.2,
              numberOfParticles: 20,
              gravity: 0.2,
            ),
          ),
        ],
      ),
    );
  }
}
