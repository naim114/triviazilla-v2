import 'dart:async';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:triviazilla/src/model/answer_model.dart';
import 'package:triviazilla/src/model/question_model.dart';
import 'package:triviazilla/src/services/helpers.dart';
import 'package:triviazilla/src/widgets/image/logo_favicon.dart';

import '../../widgets/button/answer_button.dart';

class StartTriviaAnswer extends StatefulWidget {
  const StartTriviaAnswer({
    super.key,
    required this.questionNo,
    required this.triviaLength,
    required this.onSubmit,
    required this.question,
  });

  final Function(
    bool result,
    double timeLeft,
    List<AnswerModel> recordAnswers,
  ) onSubmit;
  final int questionNo;
  final int triviaLength;
  final QuestionModel question;

  @override
  State<StartTriviaAnswer> createState() => _StartTriviaAnswerState();
}

class _StartTriviaAnswerState extends State<StartTriviaAnswer> {
  late double countdownValue;
  late double initialCountdownValue;
  late Timer countdownTimer;
  List<AnswerModel> recordAnswers = List.empty(growable: true);

  @override
  void initState() {
    super.initState();
    startCountdown();
    setState(() {
      countdownValue = widget.question.secondsLimit;
      initialCountdownValue = widget.question.secondsLimit;
      recordAnswers = widget.question.answers;
    });
  }

  void startCountdown() {
    countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        countdownValue--;
        if (countdownValue <= 0) {
          timer.cancel();
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
                      CachedNetworkImage(
                        imageUrl: customMsg
                            .lateGIF[random.nextInt(customMsg.lateGIF.length)],
                        imageBuilder: (context, imageProvider) =>
                            const Center(child: CircularProgressIndicator()),
                        placeholder: (context, url) =>
                            const Center(child: CircularProgressIndicator()),
                        errorWidget: (context, url, error) =>
                            const Center(child: CircularProgressIndicator()),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: Text(
                          "TIMES UP! INCORRECT!",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 30,
                            color: CustomColor.danger,
                            fontFamily: "RobotoSlab",
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Text(
                        customMsg.lateWord[
                            random.nextInt(customMsg.lateWord.length)],
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
          ).then((value) => widget.onSubmit(false, 0, recordAnswers));
        }
      });
    });
  }

  void stopCountdown() {
    if (countdownTimer.isActive) {
      countdownTimer.cancel();
    }
  }

  @override
  void dispose() {
    stopCountdown();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: Center(
          child: Text(
            "${widget.questionNo} / ${widget.triviaLength}",
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        centerTitle: true,
        title: logoFavicon(context: context),
        actions: [
          PopupMenuButton(
            icon: const Icon(
              Icons.more_vert,
              color: CupertinoColors.systemGrey,
            ),
            onSelected: (value) {
              if (value == 'Quit') {
                Navigator.pop(context);
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry>[
              const PopupMenuItem(
                value: 'Quit',
                child: Text("Quit"),
              ),
            ],
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 10, left: 10, right: 10),
              child: LinearPercentIndicator(
                barRadius: const Radius.circular(16),
                animation: false,
                lineHeight: 20.0,
                percent: countdownValue / initialCountdownValue,
                center: Text("${countdownValue.toInt()} sec"),
                progressColor: CustomColor.primary,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Text(
                widget.question.text,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: List.generate(widget.question.answers.length, (index) {
                AnswerModel answer = widget.question.answers[index];

                return Padding(
                  padding: const EdgeInsets.only(top: 8.0, left: 20, right: 20),
                  child: answerButton(
                    text: answer.text,
                    onTap: () {
                      stopCountdown();

                      setState(() {
                        recordAnswers.removeAt(index);
                        recordAnswers.add(AnswerModel(
                          text: answer.text,
                          isCorrect: answer.isCorrect,
                          isChosen: true,
                        ));
                      });

                      widget.onSubmit(
                        answer.isCorrect,
                        countdownValue,
                        recordAnswers,
                      );
                    },
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
