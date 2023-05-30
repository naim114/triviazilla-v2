import 'package:flutter/cupertino.dart';
import 'package:triviazilla/src/model/trivia_model.dart';

import '../../model/user_model.dart';
import '../../services/helpers.dart';
import '../card/trivia_card.dart';

Widget triviaRow({
  required BuildContext mainContext,
  required BuildContext context,
  required List<TriviaModel> trivias,
  required UserModel user,
  String title = "My Trivia",
  IconData icon = CupertinoIcons.person_alt_circle,
}) =>
    Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 20, left: 20, bottom: 5),
          child: Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: getColorByBackground(context),
                  ),
                ),
                const WidgetSpan(child: SizedBox(width: 5)),
                WidgetSpan(
                    child: Icon(
                  icon,
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
              Row(
                children: List.generate(
                  trivias.length,
                  (index) => triviaCard(
                    context: context,
                    mainContext: mainContext,
                    trivia: trivias[index],
                    user: user,
                  ),
                ),
              ),
              const SizedBox(width: 10),
            ],
          ),
        ),
      ],
    );
