import 'dart:convert';

import 'package:triviazilla/src/model/question_model.dart';
import 'package:triviazilla/src/model/user_model.dart';

class TriviaModel {
  final String id;
  final String title;
  final String description;
  final UserModel? author;
  final String? imgPath;
  final String? imgURL;

  final String? category;
  final List<dynamic>? tag;
  final List<dynamic>? likedBy;
  final List<dynamic>? bookmarkBy;

  final List<QuestionModel> questions;

  // date
  final DateTime createdAt;
  final DateTime updatedAt;

  TriviaModel({
    required this.id,
    required this.title,
    required this.description,
    required this.author,
    this.imgPath,
    this.imgURL,
    this.category,
    this.tag,
    this.likedBy,
    this.bookmarkBy,
    required this.createdAt,
    required this.updatedAt,
    required this.questions,
  });

  @override
  String toString() {
    return 'TriviaModel(id: $id, title: $title, description: $description, author: $author, imgPath: $imgPath, imgURL: $imgURL, category: $category, tag: $tag, likedBy: $likedBy, bookmarkBy: $bookmarkBy, createdAt: $createdAt, updatedAt: $updatedAt, questions: $questions)';
  }

  Map<String, Object?> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'author': author!.id,
      'imgPath': imgPath,
      'imgURL': imgURL,
      'category': category,
      'tag': tag == null ? null : jsonEncode(tag),
      'likedBy': likedBy == null ? null : jsonEncode(likedBy),
      'bookmarkBy': bookmarkBy == null ? null : jsonEncode(bookmarkBy),
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'questions': questions,
    };
  }
}
