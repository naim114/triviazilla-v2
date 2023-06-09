import 'package:confetti/confetti.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:triviazilla/src/features/record/answer.dart';

import 'package:triviazilla/src/services/helpers.dart';
import 'package:triviazilla/src/widgets/list_tile/list_tile_answer.dart';

import '../../model/record_trivia_model.dart';
import '../../model/trivia_model.dart';
import '../../model/user_model.dart';
import '../../widgets/button/custom_pill_button.dart';
import 'countdown.dart';

class StartTriviaResult extends StatefulWidget {
  const StartTriviaResult({
    super.key,
    required this.trivia,
    required this.record,
    required this.user,
  });
  final TriviaModel trivia;
  final RecordTriviaModel record;
  final UserModel user;

  @override
  State<StartTriviaResult> createState() => _StartTriviaResultState();
}

class _StartTriviaResultState extends State<StartTriviaResult> {
  late ConfettiController _controllerTopCenter;

  @override
  void initState() {
    super.initState();
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
                // Total Score
                Padding(
                  padding: const EdgeInsets.only(
                    top: 10,
                    left: 20,
                    right: 20,
                  ),
                  child: Center(
                    child: Column(
                      children: [
                        const Text(
                          "You scored..",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                        Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: widget.record.score.toString(),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontSize: 60,
                                ),
                              ),
                              const TextSpan(
                                text: "PTS",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontSize: 30,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Box Score
                Padding(
                  padding: const EdgeInsets.only(top: 10, left: 20, right: 20),
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
                            "TRIVIA NAME",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                            ),
                          ),
                          Text(
                            widget.trivia.title,
                            style: const TextStyle(
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
                                    percent: widget.record.correctCount /
                                        widget.record.questions.length,
                                    backgroundColor:
                                        CupertinoColors.lightBackgroundGray,
                                    center: Text.rich(
                                      TextSpan(
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                        children: [
                                          TextSpan(
                                            text: widget.record.correctCount
                                                .toString(),
                                            style: const TextStyle(
                                              fontSize: 30,
                                            ),
                                          ),
                                          TextSpan(
                                            text:
                                                "/${widget.record.questions.length}",
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
                                    "You answered ${widget.record.correctCount} out of ${widget.record.questions.length} questions correct",
                                    style: const TextStyle(
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
                    "Review Answer",
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
                          listTileAnswer(question: widget.record.questions[0]),
                          widget.record.questions.length <= 1
                              ? const SizedBox()
                              : listTileAnswer(
                                  question: widget.record.questions[1]),
                          ListTile(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => RecordAnswer(
                                    questions: widget.record.questions,
                                  ),
                                ),
                              );
                            },
                            title: const Text(
                              "Tap to view all",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: CupertinoColors.darkBackgroundGray,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            titleAlignment: ListTileTitleAlignment.center,
                          ),
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
                          child: StartTriviaCountdown(
                            trivia: widget.trivia,
                            user: widget.user,
                          ),
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
                  padding: const EdgeInsets.only(
                    left: 20,
                    right: 20,
                    bottom: 20,
                  ),
                  child: customPillButton(
                    width: MediaQuery.of(context).size.width * 0.9,
                    context: context,
                    borderColor: CupertinoColors.darkBackgroundGray,
                    fillColor: CupertinoColors.darkBackgroundGray,
                    onPressed: () => Navigator.pop(context),
                    child: const Text(
                      'Close',
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
