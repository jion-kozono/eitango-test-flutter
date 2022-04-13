import 'package:eitango_test_flutter/constants/device.dart';
import 'package:eitango_test_flutter/model/word.dart';
import 'package:eitango_test_flutter/utils/split_example.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;

class WordListPage extends StatefulWidget {
  final List<Word> words;

  const WordListPage({required this.words, Key? key}) : super(key: key);

  @override
  State<WordListPage> createState() => _WordListPageState();
}

class _WordListPageState extends State<WordListPage> {
  late FlutterTts flutterTts;
  List<bool> isVisibleList = [];
  bool isFromWord = false;
  String? engine;

  bool get isIOS => !kIsWeb && Platform.isIOS;
  bool get isAndroid => !kIsWeb && Platform.isAndroid;
  bool get isWeb => kIsWeb;

  @override
  void initState() {
    super.initState();
    initTts();
    _initIsVisible();
  }

  Future _setAwaitOptions() async {
    await flutterTts.awaitSpeakCompletion(true);
  }

  Future _getDefaultEngine() async {
    await flutterTts.getDefaultEngine;
  }

  initTts() {
    flutterTts = FlutterTts();
    _setAwaitOptions();
    if (isAndroid) {
      _getDefaultEngine();
    }
  }

  // 全て不可視化
  void _initIsVisible() {
    isVisibleList = widget.words.map((word) => false).toList();
  }

  void _changeIsVisibleByIndex(int index) {
    setState(() {
      isVisibleList[index] = !isVisibleList[index];
    });
  }

  void _changeIsFromWord() {
    setState(() {
      _initIsVisible();
      isFromWord = !isFromWord;
    });
  }

  Future<void> _speakWord(String word) async {
    await flutterTts.setLanguage("en-US");
    await flutterTts.setSpeechRate(0.7);
    await flutterTts.setVolume(1.0);
    await flutterTts.setPitch(1.0);
    await flutterTts.speak(word);
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
                      _changeIsFromWord();
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
                    List<Map<String, String>> exampleAndTranslationList =
                        words[index].example != ""
                            ? Utils.getListFromExample(
                                words[index].example, words[index].translation)
                            : [];
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
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                flex: 4,
                                child: Text(
                                  "${index + 1}. ${isFromWord ? words[index].word : words[index].meaning}",
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ),
                              Flexible(
                                flex: 3,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Flexible(
                                      flex: 3,
                                      child: Text(
                                        isVisibleList[index]
                                            ? isFromWord
                                                ? words[index].meaning
                                                : words[index].word
                                            : isFromWord
                                                ? "meaning"
                                                : "word",
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                    ),
                                    Flexible(
                                      flex: 1,
                                      child: IconButton(
                                        icon: isVisibleList[index]
                                            ? const Icon(Icons.visibility)
                                            : const Icon(Icons.visibility_off),
                                        onPressed: () {
                                          _changeIsVisibleByIndex(index);
                                        },
                                      ),
                                    ),
                                    Flexible(
                                      flex: 1,
                                      child: IconButton(
                                        icon: const Icon(Icons.play_arrow),
                                        onPressed: () async {
                                          await _speakWord(words[index].word);
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          exampleAndTranslationList.isNotEmpty
                              ? ExpansionTile(
                                  title: const Text('Example'),
                                  tilePadding: EdgeInsets.zero,
                                  children: exampleAndTranslationList
                                      .map(
                                        (e) => Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Flexible(
                                                flex: 8,
                                                child: Text(
                                                    e["example"] as String)),
                                            Flexible(
                                              flex: 2,
                                              child: IconButton(
                                                icon: const Icon(
                                                    Icons.play_arrow),
                                                onPressed: () async {
                                                  await _speakWord(
                                                      e["example"] as String);
                                                },
                                              ),
                                            ),
                                            Flexible(
                                                flex: 1, child: Container()),
                                            Flexible(
                                                flex: 6,
                                                child: Text(
                                                  e["translation"] as String,
                                                ))
                                          ],
                                        ),
                                      )
                                      .toList())
                              : Container(),
                        ],
                      ),
                    );
                  }),
            ),
          ],
        ));
  }
}
