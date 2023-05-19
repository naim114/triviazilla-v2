import 'package:flutter/material.dart';
import 'package:triviazilla/src/services/helpers.dart';

Widget categoryCard({
  required BuildContext context,
  required String text,
  Color color = CustomColor.primary,
  required void Function()? onTap,
}) =>
    GestureDetector(
      onTap: onTap,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.4,
        height: MediaQuery.of(context).size.height * 0.1,
        margin: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Center(
          child: Text(
            text,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
