import 'package:triviazilla/src/model/answer_model.dart';

class QuestionModel {
  final String text;
  final List<AnswerModel> answers;
  final double secondsLimit;
  final double timeLeft;

  QuestionModel({
    required this.text,
    required this.answers,
    required this.secondsLimit,
    required this.timeLeft,
  });

  @override
  String toString() {
    return 'QuestionModel(text: $text, secondsLimit: $secondsLimit, answers: $answers, timeLeft: $timeLeft)';
  }

  Map<String, dynamic> toMap() {
    return {
      'text': text,
      'secondsLimit': secondsLimit,
      'answers': answers.map((a) => a.toMap()).toList(),
      'timeLeft': timeLeft,
    };
  }

  factory QuestionModel.fromJson(Map<String, Object?> json) {
    List<AnswerModel> answers = (json['answers']! as List<dynamic>).map((json) {
      return AnswerModel.fromJson(json as Map<String, dynamic>);
    }).toList();

    return QuestionModel(
      text: json['text']! as String,
      secondsLimit: json['secondsLimit'] as double,
      answers: answers,
      timeLeft: json['timeLeft'] as double,
    );
  }
}
