class AnswerModel {
  final String text;
  final bool isCorrect;
  final bool isChosen;

  AnswerModel({
    required this.text,
    required this.isCorrect,
    required this.isChosen,
  });

  @override
  String toString() {
    return 'AnswerModel(text: $text, isCorrect: $isCorrect, isChosem: $isChosen)';
  }

  Map<String, dynamic> toMap() {
    return {
      'text': text,
      'isCorrect': isCorrect,
      'isChosen': isChosen,
    };
  }

  factory AnswerModel.fromJson(Map<String, Object?> json) {
    return AnswerModel(
      text: json['text']! as String,
      isCorrect: json['isCorrect']! as bool,
      isChosen: json['isChosen']! as bool,
    );
  }
}
