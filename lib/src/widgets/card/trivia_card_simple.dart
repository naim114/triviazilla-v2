import 'package:flutter/material.dart';
import 'package:triviazilla/src/model/trivia_model.dart';
import 'package:triviazilla/src/widgets/modal/trivia_modal.dart';

import '../../model/user_model.dart';

Widget triviaCardSimple({
  required BuildContext context,
  required UserModel user,
  required TriviaModel trivia,
}) =>
    ListTile(
      onTap: () =>
          showTriviaModal(trivia: trivia, context: context, user: user),
      title: Text(
        trivia.title,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
    );
