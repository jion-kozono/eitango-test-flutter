import 'package:eitango_test_flutter/components/my_snack_bar.dart';
import 'package:eitango_test_flutter/model/word.dart';
import 'package:eitango_test_flutter/pages/result_page.dart';
import 'package:eitango_test_flutter/utils/requests.dart';
import 'package:eitango_test_flutter/utils/split_example.dart';
import 'package:flutter/material.dart';

class TestPage extends StatefulWidget {
  final List<Word> words;

  const TestPage({required this.words, Key? key}) : super(key: key);

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  final _formKey = GlobalKey<FormState>();
  List<TextEditingController> controllerList = [];
  List<Map<String, dynamic>> wrongWords = [];
  List<Map<String, String>> questionAndAnswerList = [];
  int score = 0;

  String _getQuestion(String translation, String meaning) {
    return translation == "" ? meaning : translation;
  }

  String _getAnswer(String example, String word) {
    return example == "" ? word : example;
  }

  Future<void> postIsCorrect() async {
    List<Map<String, dynamic>> isCorrectListOfDict = [];
    questionAndAnswerList.forEach((qAndA) {
      Word word =
          widget.words.where((Word word) => word.id == qAndA["word_id"]).first;
      int index = questionAndAnswerList.indexOf(qAndA);
      String inputWord = controllerList[index].text;
      int isCorrectToUpdate = 0;
      if (inputWord == qAndA["answer"]) {
        isCorrectToUpdate = 1;
        score += 1;
      } else {
        isCorrectToUpdate = -1;
        wrongWords.add({
          "あなたの答え": inputWord,
          "答": qAndA["answer"],
          "問": qAndA["question"],
          "英単語": word.word,
        });
      }
      isCorrectListOfDict.add({
        "id": word.id,
        "is_correct": isCorrectToUpdate,
      });
    });
    await API.postIsCorrect(isCorrectListOfDict);
  }

  void _getQuestionsAndAnswers() {
    for (int i = 0; i < widget.words.length; i++) {
      Word word = widget.words[i];
      List<Map<String, String>> exampleAndTranslationList =
          Utils.getListFromExample(word.example, word.translation);
      for (int j = 0; j < exampleAndTranslationList.length; j++) {
        String question = _getQuestion(
            exampleAndTranslationList[j]["translation"]!, word.meaning);
        String answer =
            _getAnswer(exampleAndTranslationList[j]["example"]!, word.meaning);
        Map<String, String> questionAndAnswer = {
          "word_id": word.id,
          "question": question,
          "answer": answer,
        };
        questionAndAnswerList.add(questionAndAnswer);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _getQuestionsAndAnswers();
    for (int i = 0; i < questionAndAnswerList.length; i++) {
      controllerList.add(TextEditingController());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("テスト")),
      body: SingleChildScrollView(
        child: Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: questionAndAnswerList.isEmpty
                    ? [Container()]
                    : questionAndAnswerList.map((qAndA) {
                        Word word = widget.words
                            .where((Word word) => word.id == qAndA["word_id"])
                            .first;
                        int index = questionAndAnswerList.indexOf(qAndA);
                        Widget wordFields = Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${index + 1}. ${qAndA["question"]} (No.${word.wordNum})",
                              style: const TextStyle(fontSize: 16),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                key: Key(index.toString()),
                                controller: controllerList[index],
                                enableSuggestions: false,
                                keyboardType: TextInputType.visiblePassword,
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                )),
                              ),
                            ),
                            index == questionAndAnswerList.length - 1
                                ? Center(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10.0),
                                      child: ElevatedButton(
                                          onPressed: () async {
                                            if (_formKey.currentState!
                                                .validate()) {
                                              try {
                                                postIsCorrect();
                                                await Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            ResultPage(
                                                                wrongWords:
                                                                    wrongWords,
                                                                scoreText:
                                                                    "${score.toString()}/${questionAndAnswerList.length.toString()}"),
                                                        fullscreenDialog:
                                                            true));
                                                Navigator.pop(context);
                                              } catch (e) {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(mySnackBar(
                                                        context,
                                                        e.toString().replaceAll(
                                                            "Exception: ",
                                                            "")));
                                              }
                                            }
                                          },
                                          child: const Text("解答を送信")),
                                    ),
                                  )
                                : Container(),
                          ],
                        );
                        return wordFields;
                      }).toList(),
              ),
            )),
      ),
    );
  }
}
