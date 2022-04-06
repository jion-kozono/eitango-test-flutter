import 'package:eitango_test_flutter/constants/device.dart';
import 'package:eitango_test_flutter/model/word.dart';
import 'package:flutter/material.dart';

class WordListPage extends StatefulWidget {
  final List<Word> words;

  const WordListPage({required this.words, Key? key}) : super(key: key);

  @override
  State<WordListPage> createState() => _WordListPageState();
}

class _WordListPageState extends State<WordListPage> {
  List<bool> isVisibleList = [];
  bool isFromWord = false;

  @override
  void initState() {
    super.initState();
    initIsVisible();
  }

  // 全て不可視化
  void initIsVisible() {
    isVisibleList = widget.words.map((word) => false).toList();
  }

  void changeIsVisibleByIndex(int index) {
    setState(() {
      isVisibleList[index] = !isVisibleList[index];
    });
  }

  void changeIsFromWord() {
    setState(() {
      initIsVisible();
      isFromWord = !isFromWord;
    });
  }

  Map<String, String> buttonText = {
    "fromWord": "単語から意味を確認",
    "fromMeaning": "意味から単語を確認"
  };

  @override
  Widget build(BuildContext context) {
    List<Word> words = widget.words;
    return Scaffold(
        appBar: AppBar(title: const Text("学習単語一覧")),
        body: Column(
          children: [
            Container(
              color: Colors.greenAccent,
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                      "${isFromWord ? buttonText["fromWord"]! : buttonText["fromMeaning"]!}しよう"),
                  ElevatedButton(
                    child: Text(!isFromWord
                        ? buttonText["fromWord"]!
                        : buttonText["fromMeaning"]!),
                    onPressed: () {
                      changeIsFromWord();
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                  itemCount: words.length,
                  padding: const EdgeInsets.only(bottom: 30),
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      key: Key(index.toString()),
                      alignment: Alignment.center,
                      margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                      padding: const EdgeInsets.all(10),
                      width: DeviceInfo.width(context) * 0.7,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "${index + 1}. ${isFromWord ? words[index].word : words[index].meaning}",
                            style: const TextStyle(fontSize: 16),
                          ),
                          Row(
                            children: [
                              Text(
                                isVisibleList[index]
                                    ? isFromWord
                                        ? words[index].meaning
                                        : words[index].word
                                    : isFromWord
                                        ? "meaning"
                                        : "word",
                                style: const TextStyle(fontSize: 14),
                              ),
                              IconButton(
                                icon: isVisibleList[index]
                                    ? const Icon(Icons.visibility)
                                    : const Icon(Icons.visibility_off),
                                onPressed: () {
                                  changeIsVisibleByIndex(index);
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  }),
            ),
          ],
        ));
  }
}
