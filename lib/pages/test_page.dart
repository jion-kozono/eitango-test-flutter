import 'package:eitango_test_flutter/components/mySnackBar.dart';
import 'package:eitango_test_flutter/model/word.dart';
import 'package:eitango_test_flutter/pages/result_page.dart';
import 'package:eitango_test_flutter/utils/requests.dart';
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
  int score = 0;

  Future<void> postIsCorrect() async {
    List<Map<String, dynamic>> isCorrectListOfDict = [];
    widget.words.asMap().forEach((int index, Word word) {
      String inputWord = controllerList[index].text;
      int isCorrectToUpdate = 0;
      if (inputWord == word.word) {
        isCorrectToUpdate = 1;
        score += 1;
      } else {
        isCorrectToUpdate = -1;
        wrongWords.add({
          "あなたの答え": inputWord,
          "英単語": word.word,
          "意味": word.meaning,
          "No.": word.wordNum.toString(),
        });
      }
      isCorrectListOfDict.add({
        "id": word.id,
        "is_correct": isCorrectToUpdate,
      });
    });
    await API.postIsCorrect(isCorrectListOfDict);
  }

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < widget.words.length; i++) {
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
                children: widget.words.map((word) {
                  int index = widget.words.indexOf(word);
                  Widget wordFields = Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${index + 1}. ${word.meaning} (No.${word.wordNum})",
                        style: const TextStyle(fontSize: 16),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          key: Key(index.toString()),
                          controller: controllerList[index],
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          )),
                        ),
                      ),
                      index == widget.words.length - 1
                          ? Center(
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10.0),
                                child: ElevatedButton(
                                    onPressed: () async {
                                      if (_formKey.currentState!.validate()) {
                                        try {
                                          postIsCorrect();
                                          await Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) => ResultPage(
                                                      wrongWords: wrongWords,
                                                      scoreText:
                                                          "${score.toString()}/${widget.words.length.toString()}"),
                                                  fullscreenDialog: true));
                                          Navigator.pop(context);
                                        } catch (e) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(mySnackBar(
                                                  context,
                                                  e.toString().replaceAll(
                                                      "Exception: ", "")));
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
