import 'package:flutter/material.dart';

Widget answerButton({
  required String text,
  required void Function()? onTap,
  bool? isCorrect,
}) =>
    Container(
      decoration: BoxDecoration(
        color: Colors.orange,
        borderRadius: BorderRadius.circular(10),
      ),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Center(
            child: Column(
              children: [
                Text(
                  text,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                isCorrect == null
                    ? const SizedBox()
                    : Text(
                        "(${isCorrect ? 'Correct' : 'Incorrect'})",
                        style: TextStyle(
                          color: isCorrect ? Colors.green : Colors.red,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
