class AnswerModel {
  final String text;
  final String? imgPath;
  final String? imgURL;
  final bool isCorrect;

  AnswerModel({
    required this.text,
    this.imgPath,
    this.imgURL,
    required this.isCorrect,
  });

  @override
  String toString() {
    return 'AnswerModel(text: $text, imgPath: $imgPath, imgURL: $imgURL, isCorrect: $isCorrect)';
  }

  Map<String, Object?> toJson() {
    return {
      'text': text,
      'imgPath': imgPath,
      'imgURL': imgURL,
      'isCorrect': isCorrect,
    };
  }

  AnswerModel.fromJson(Map<String, Object?> json)
      : this(
          text: json['text']! as String,
          imgPath: json['imgPath']! as String,
          imgURL: json['imgURL']! as String,
          isCorrect: json['isCorrect']! as bool,
        );
}
