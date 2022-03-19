class Word {
  late String id;
  late String word;
  late String meaning;
  late String bookName;
  late int wordNum;
  late IsCorrect isCorrect;

  Word(
      {required this.id,
      required this.word,
      required this.meaning,
      required this.bookName,
      required this.wordNum,
      required this.isCorrect});
}

enum IsCorrect {
  correct,
  wrong,
}

extension IsCorrectExt on IsCorrect {
  int? get num {
    switch (this) {
      case IsCorrect.correct:
        return 1;
      case IsCorrect.wrong:
        return -1;
    }
  }
}
