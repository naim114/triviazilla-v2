import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:triviazilla/src/model/user_model.dart';
import 'package:triviazilla/src/services/trivia_services.dart';
import 'package:triviazilla/src/widgets/editor/trivia_editor.dart';

class TriviaAdd extends StatelessWidget {
  final UserModel user;
  const TriviaAdd({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return TriviaEditor(
      onPost: (
        File? coverImageFile,
        String title,
        String description,
        String? category,
        List<String>? tags,
        List<Map<String, dynamic>> question,
      ) async {
        print("Adding trivia");
        Fluttertoast.showToast(msg: "Adding Trivia...");

        final result = await TriviaServices().add(
          title: title,
          description: description,
          author: user,
          question: question,
          coverImageFile: coverImageFile,
          category: category,
          tags: tags,
        );

        if (result) {
          Fluttertoast.showToast(msg: "Trivia added!");
        }
      },
    );
  }
}
