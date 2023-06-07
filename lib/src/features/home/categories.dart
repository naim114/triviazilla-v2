import 'package:flutter/material.dart';
import 'package:triviazilla/src/model/user_model.dart';
import '../../model/trivia_model.dart';
import '../../services/trivia_services.dart';
import '../../widgets/card/category_card.dart';

Widget categoriesHome({
  required BuildContext context,
  required BuildContext mainContext,
  required Map<String, List<TriviaModel>> categories,
  required UserModel user,
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
              Row(
                children: categories.entries.map((e) {
                  if (e.key == "") {
                    return const SizedBox();
                  }

                  return categoryCard(
                    context: mainContext,
                    text: e.key.toUpperCase(),
                    onTap: () async {
                      await TriviaServices().search(
                        context: mainContext,
                        user: user,
                        query: e.key,
                      );
                    },
                  );
                }).toList(),
              ),
              const SizedBox(width: 10),
            ],
          ),
        ),
      ],
    );
