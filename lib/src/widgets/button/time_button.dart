import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget timeButton({
  required double secondsLimit,
  required void Function()? onPressed,
}) =>
    ElevatedButton(
      style: ElevatedButton.styleFrom(shape: const StadiumBorder()),
      onPressed: onPressed,
      child: Text.rich(
        TextSpan(
          children: [
            const WidgetSpan(
              child: Icon(
                CupertinoIcons.clock,
                size: 19,
                color: Colors.white,
              ),
            ),
            TextSpan(
              text: ' ${secondsLimit.round()} sec',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
