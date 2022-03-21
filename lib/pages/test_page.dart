import 'package:eitango_test_flutter/constants/device.dart';
import 'package:eitango_test_flutter/model/word.dart';
import 'package:eitango_test_flutter/pages/result_page.dart';
import 'package:flutter/material.dart';

class TestPage extends StatefulWidget {
  final List<Word> words;

  const TestPage({required this.words});

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  final _formKey = GlobalKey<FormState>();
  List<TextEditingController> controllerList = [];

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
                                        // Todo: 解答を送信するapiを呼ぶ
                                        await Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    ResultPage(),
                                                fullscreenDialog: true));
                                        Navigator.pop(context);
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
