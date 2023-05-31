import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../services/helpers.dart';

Widget listTileAnswer({
  required bool isCorrect,
}) =>
    Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: ListTile(
        leading: isCorrect
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
          "What is the man that killed rhino?",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: CustomColor.neutral1,
          ),
        ),
        subtitle: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text.rich(
              TextSpan(
                style: TextStyle(color: CustomColor.neutral1),
                children: [
                  TextSpan(
                      text: "Your answer: ",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  TextSpan(text: "21"),
                ],
              ),
            ),
            Text.rich(
              TextSpan(
                style: TextStyle(color: CustomColor.neutral1),
                children: [
                  TextSpan(
                      text: "Correct answer: ",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  TextSpan(text: "21"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
