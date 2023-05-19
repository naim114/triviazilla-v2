import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../services/helpers.dart';
import '../../widgets/card/trivia_card.dart';

Widget myTrivia({
  required BuildContext context,
}) =>
    Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 20, left: 20, bottom: 5),
          child: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: "My Trivia",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: getColorByBackground(context),
                  ),
                ),
                const WidgetSpan(child: SizedBox(width: 5)),
                const WidgetSpan(
                    child: Icon(
                  CupertinoIcons.person_alt_circle,
                  size: 18,
                )),
              ],
            ),
          ),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              const SizedBox(width: 10),
              triviaCard(context: context),
              const SizedBox(width: 10),
            ],
          ),
        ),
      ],
    );
