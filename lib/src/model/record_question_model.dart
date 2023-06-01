import 'package:triviazilla/src/model/record_answer_model.dart';

class RecordQuestionModel {
  final String text;
  final List<RecordAnswerModel> answers;
  final double secondsLimit;
  final double timeLeft;

  RecordQuestionModel({
    required this.text,
    required this.answers,
    required this.timeLeft,
    required this.secondsLimit,
  });

  @override
  String toString() {
    return 'RecordQuestionModel(text: $text, secondsLimit: $secondsLimit, timeLeft: $timeLeft, answers: $answers)';
  }

  Map<String, Object?> toJson() {
    return {
      'text': text,
      'secondsLimit': secondsLimit,
      'answers': answers,
      'timeLeft': timeLeft,
    };
  }

  factory RecordQuestionModel.fromJson(Map<String, Object?> json) {
    List<RecordAnswerModel> answers =
        (json['answers']! as List<dynamic>).map((json) {
      return RecordAnswerModel.fromJson(json as Map<String, dynamic>);
    }).toList();

    return RecordQuestionModel(
      text: json['text']! as String,
      secondsLimit: json['secondsLimit'] as double,
      answers: answers,
      timeLeft: json['timeLeft'] as double,
    );
  }
}
