class Word {
  late String id;
  late String word;
  late String meaning;
  late String example;
  late String translation;
  late String bookName;
  late int wordNum;
  late bool isCorrect;

  Word(
      {required this.id,
      required this.word,
      required this.meaning,
      required this.example,
      required this.translation,
      required this.bookName,
      required this.wordNum,
      required this.isCorrect});

  Word.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    word = json['word'];
    meaning = json['meaning'];
    example = json['example'];
    translation = json['translation'];
    bookName = json['book_name'];
    wordNum = json['word_num'];
    isCorrect = json['is_correct'] == 1 ? true : false;
  }
}
