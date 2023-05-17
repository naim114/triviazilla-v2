import 'package:triviazilla/src/model/answer_model.dart';

class QuestionModel {
  final String text;
  final String? imgPath;
  final String? imgURL;
  final List<AnswerModel> answers;

  QuestionModel({
    required this.text,
    this.imgPath,
    this.imgURL,
    required this.answers,
  });

  @override
  String toString() {
    return 'QuestionModel(text: $text, imgPath: $imgPath, imgURL: $imgURL, answers: $answers)';
  }

  Map<String, Object?> toJson() {
    return {
      'text': text,
      'imgPath': imgPath,
      'imgURL': imgURL,
      'answers': answers,
    };
  }

  QuestionModel.fromJson(Map<String, Object?> json)
      : this(
          text: json['text']! as String,
          imgPath: json['imgPath']! as String,
          imgURL: json['imgURL']! as String,
          answers: json['answers']! as List<AnswerModel>,
        );
}
