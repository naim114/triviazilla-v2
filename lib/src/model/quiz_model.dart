import 'dart:convert';

import 'package:triviazilla/src/model/question_model.dart';
import 'package:triviazilla/src/model/user_model.dart';

class QuizModel {
  final String id;
  final String title;
  final String description;
  final UserModel? author;
  final String? imgPath;
  final String? imgURL;

  final String? category;
  final List<dynamic>? likedBy;
  final List<dynamic>? bookmarkBy;

  final List<QuestionModel> questions;

  // date
  final DateTime createdAt;
  final DateTime updatedAt;

  QuizModel({
    required this.id,
    required this.title,
    required this.description,
    required this.author,
    this.imgPath,
    this.imgURL,
    this.category,
    this.likedBy,
    this.bookmarkBy,
    required this.createdAt,
    required this.updatedAt,
    required this.questions,
  });

  @override
  String toString() {
    return 'QuizModel(id: $id, title: $title, description: $description, author: $author, imgPath: $imgPath, imgURL: $imgURL, category: $category, likedBy: $likedBy, bookmarkBy: $bookmarkBy, createdAt: $createdAt, updatedAt: $updatedAt, questions: $questions)';
  }

  Map<String, Object?> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'author': author,
      'imgPath': imgPath,
      'imgURL': imgURL,
      'category': category,
      'likedBy': likedBy == null ? null : jsonEncode(likedBy),
      'bookmarkBy': bookmarkBy == null ? null : jsonEncode(bookmarkBy),
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'questions': questions,
    };
  }
}
