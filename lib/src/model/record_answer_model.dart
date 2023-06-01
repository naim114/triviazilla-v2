class RecordAnswerModel {
  final String text;
  final bool isCorrect;
  final bool isChosen;

  RecordAnswerModel({
    required this.text,
    required this.isCorrect,
    required this.isChosen,
  });

  @override
  String toString() {
    return 'RecordAnswerModel(text: $text, isCorrect: $isCorrect. isChosen: $isChosen)';
  }

  Map<String, Object?> toJson() {
    return {
      'text': text,
      'isCorrect': isCorrect,
      'isChosen': isChosen,
    };
  }

  factory RecordAnswerModel.fromJson(Map<String, Object?> json) {
    return RecordAnswerModel(
      text: json['text']! as String,
      isCorrect: json['isCorrect']! as bool,
      isChosen: json['isChosen']! as bool,
    );
  }
}
