import 'package:flutter/material.dart';
import '../../widgets/card/category_card.dart';

Widget categoriesHome({
  required BuildContext context,
}) =>
    Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 20, left: 20, bottom: 5),
          child: Text(
            'Categories',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              const SizedBox(width: 10),
              categoryCard(
                context: context,
                text: 'History',
                onTap: () {},
              ),
              const SizedBox(width: 10),
            ],
          ),
        ),
      ],
    );
