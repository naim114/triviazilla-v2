class AnswerModel {
  final String text;
  final bool isCorrect;

  AnswerModel({
    required this.text,
    required this.isCorrect,
  });

  @override
  String toString() {
    return 'AnswerModel(text: $text, isCorrect: $isCorrect)';
  }

  Map<String, Object?> toJson() {
    return {
      'text': text,
      'isCorrect': isCorrect,
    };
  }

  AnswerModel.fromJson(Map<String, Object?> json)
      : this(
          text: json['text']! as String,
          isCorrect: json['isCorrect']! as bool,
        );
}
