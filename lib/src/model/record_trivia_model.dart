import 'package:triviazilla/src/model/question_model.dart';
import 'package:triviazilla/src/model/trivia_model.dart';
import 'package:triviazilla/src/model/user_model.dart';

class RecordTriviaModel {
  final String id;
  final TriviaModel trivia;
  final UserModel? answerBy;

  final List<QuestionModel> questions;

  // date
  final DateTime createdAt;
  final DateTime updatedAt;

  RecordTriviaModel({
    required this.id,
    required this.trivia,
    required this.answerBy,
    required this.questions,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  String toString() {
    return 'RecordTriviaModel(id: $id, trivia: $trivia, answerBy: $answerBy, questions: $questions, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  Map<String, Object?> toJson() {
    return {
      'id': id,
      'trivia': trivia.id,
      'answerBy': answerBy!.id,
      'questions': questions,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}
