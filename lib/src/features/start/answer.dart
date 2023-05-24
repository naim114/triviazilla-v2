import 'dart:async';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:shimmer/shimmer.dart';
import 'package:triviazilla/src/services/helpers.dart';
import 'package:triviazilla/src/widgets/image/logo_favicon.dart';

import '../../widgets/button/answer_button.dart';

class StartTriviaAnswer extends StatefulWidget {
  const StartTriviaAnswer({
    super.key,
    required this.questionNo,
    required this.triviaLength,
    required this.onSubmit,
  });
  final Function(bool) onSubmit;
  final int questionNo;
  final int triviaLength;

  @override
  State<StartTriviaAnswer> createState() => _StartTriviaAnswerState();
}

class _StartTriviaAnswerState extends State<StartTriviaAnswer> {
  int countdownValue = 10;
  int initialCountdownValue = 10;
  late Timer countdownTimer;

  @override
  void initState() {
    super.initState();
    startCountdown();
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
                      Image.network(
                        customMsg
                            .lateGIF[random.nextInt(customMsg.lateGIF.length)],
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
          ).then((value) => widget.onSubmit(false));
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
              padding: const EdgeInsets.only(bottom: 15, left: 20, right: 20),
              child: CachedNetworkImage(
                imageUrl:
                    'https://dummyimage.com/600x400/000/fff&text=wu+tang+foreverrr',
                fit: BoxFit.cover,
                imageBuilder: (context, imageProvider) => Container(
                  height: MediaQuery.of(context).size.height * 0.30,
                  width: MediaQuery.of(context).size.width * 0.80,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: imageProvider, fit: BoxFit.cover),
                  ),
                ),
                placeholder: (context, url) => Shimmer.fromColors(
                  baseColor: CupertinoColors.systemGrey,
                  highlightColor: CupertinoColors.systemGrey2,
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.30,
                    width: MediaQuery.of(context).size.width * 0.80,
                  ),
                ),
                errorWidget: (context, url, error) => Container(
                  height: MediaQuery.of(context).size.height * 0.30,
                  width: MediaQuery.of(context).size.width * 0.80,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/images/noimage.png'),
                        fit: BoxFit.cover),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Text(
                "What is the most rhinosaurus of all color?",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, left: 20, right: 20),
                  child: answerButton(
                    text: "asdasd",
                    onTap: () {
                      bool result = false; // TODO change this
                      stopCountdown();
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
                                  Image.network(
                                    result
                                        ? customMsg.trueGIF[random
                                            .nextInt(customMsg.trueGIF.length)]
                                        : customMsg.falseGIF[random.nextInt(
                                            customMsg.falseGIF.length)],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10),
                                    child: Text(
                                      // "Correct",
                                      result ? "CORRECT!" : "INCORRECT!",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 30,
                                        color: result
                                            ? Colors.green
                                            : CustomColor.danger,
                                        fontFamily: "RobotoSlab",
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  Text(
                                    result
                                        ? customMsg.trueWord[random
                                            .nextInt(customMsg.trueWord.length)]
                                        : customMsg.falseWord[random.nextInt(
                                            customMsg.falseWord.length)],
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
                      ).then((value) => widget.onSubmit(result));
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
