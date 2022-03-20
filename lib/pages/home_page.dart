import 'package:eitango_test_flutter/components/word_name_form_field.dart';
import 'package:eitango_test_flutter/constants/device.dart';
import 'package:eitango_test_flutter/model/word.dart';
import 'package:eitango_test_flutter/pages/test_page.dart';
import 'package:eitango_test_flutter/utils/requests.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _formKey = GlobalKey<FormState>();
  int initialValue = 1;
  String bookName = "";
  bool isCheckedWeek = false;
  late TextEditingController firstNumController =
      TextEditingController(text: "$initialValue");
  late TextEditingController lastNumController =
      TextEditingController(text: "${initialValue + 20}");

  List<Word> words = [];

  Future<List<String>> getAllBookNames() async {
    List<String> bookNameList = await API.getAllBookNames();
    bookName = bookNameList[0];
    bookNameList.add("hogeghohg");
    return bookNameList;
  }

  Future<List<Word>> getTestWords() async {
    return [
      Word(
          id: "ID:1",
          word: "apple",
          meaning: "りんご",
          bookName: "参考書1",
          wordNum: 1,
          isCorrect: IsCorrect.correct),
      Word(
          id: "ID:2",
          word: "grape",
          meaning: "ぶどう",
          bookName: "参考書1",
          wordNum: 2,
          isCorrect: IsCorrect.correct),
      Word(
          id: "ID:2",
          word: "grape",
          meaning: "ぶどう",
          bookName: "参考書1",
          wordNum: 2,
          isCorrect: IsCorrect.correct),
      Word(
          id: "ID:2",
          word: "grape",
          meaning: "ぶどう",
          bookName: "参考書1",
          wordNum: 2,
          isCorrect: IsCorrect.correct),
      Word(
          id: "ID:2",
          word: "grape",
          meaning: "ぶどう",
          bookName: "参考書1",
          wordNum: 2,
          isCorrect: IsCorrect.correct),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: FutureBuilder(
          future: getAllBookNames(),
          builder:
              (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
            List<String>? bookNameList = snapshot.data;
            if (snapshot.connectionState == ConnectionState.waiting ||
                !snapshot.hasData) {
              return const CircularProgressIndicator();
            } else {
              return Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => TestPage(words: words)));
                      },
                      child: const Text("全ての苦手単語をテストする"),
                    ),
                  ),
                  const Text(
                    "テスト情報を入力してください",
                    style: TextStyle(fontSize: 18),
                  ),
                  Form(
                    key: _formKey,
                    child: Container(
                      margin: const EdgeInsets.only(top: 16),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          DropdownButtonFormField(
                            decoration: const InputDecoration(
                              labelText: "単語帳名",
                            ),
                            value: bookName,
                            icon: const Icon(Icons.arrow_drop_down),
                            onChanged: (String? newValue) {
                              bookName = newValue!;
                            },
                            items: bookNameList!
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                  alignment: AlignmentDirectional.centerStart,
                                  value: value,
                                  child: SingleChildScrollView(
                                    child: Container(
                                        constraints: BoxConstraints(
                                          maxWidth:
                                              DeviceInfo.width(context) * 0.8,
                                        ),
                                        child: Text(value)),
                                  ));
                            }).toList(),
                          ),
                          wordNumFormField(
                              true, firstNumController, lastNumController),
                          wordNumFormField(
                              false, lastNumController, firstNumController),
                          Row(
                            children: [
                              Checkbox(
                                  value: isCheckedWeek,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      isCheckedWeek = value!;
                                    });
                                  }),
                              const Text("苦手だけ(間違ったままの問題が出題されます。)")
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10.0),
                            child: ElevatedButton(
                                onPressed: () async {
                                  if (_formKey.currentState!.validate()) {
                                    words = await getTestWords();
                                    print(words);
                                    if (words.length > 0) {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  TestPage(words: words)));
                                    }
                                  }
                                },
                                child: const Text("テストを作成")),
                          ),
                        ],
                      ),
                    ),
                  ),
                ]),
              );
            }
          },
        ),
      ),
    );
  }
}
