import 'dart:io';

import 'package:flutter/material.dart';
import 'package:triviazilla/src/widgets/editor/trivia_editor.dart';

class TriviaAdd extends StatelessWidget {
  const TriviaAdd({super.key});

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
      ) {
        // TODO add function here
      },
    );
  }
}
