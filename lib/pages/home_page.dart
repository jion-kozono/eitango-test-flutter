import 'package:eitango_test_flutter/components/mySnackBar.dart';
import 'package:eitango_test_flutter/components/word_name_form_field.dart';
import 'package:eitango_test_flutter/constants/device.dart';
import 'package:eitango_test_flutter/model/word.dart';
import 'package:eitango_test_flutter/pages/test_page.dart';
import 'package:eitango_test_flutter/pages/word_list_page.dart';
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
  bool isCheckedWeak = false;
  bool isDisabled = false;
  late TextEditingController firstNumController =
      TextEditingController(text: "$initialValue");
  late TextEditingController lastNumController =
      TextEditingController(text: "${initialValue + 20}");

  List<Word> words = [];

  void changeIsCheckedWeak() {
    isCheckedWeak = !isCheckedWeak;
  }

  void changeButtonStatus() {
    setState(() {
      isDisabled = !isDisabled;
    });
  }

  Future<List<String>> getAllBookNames() async {
    List<String> bookNameList = await API.getAllBookNames();
    bookName = bookNameList[0];
    return bookNameList;
  }

  Future<void> onSubmitForm(bool isTest) async {
    if (_formKey.currentState!.validate()) {
      changeButtonStatus();
      words = await API.getTestWords(
          bookName,
          int.parse(firstNumController.text),
          int.parse(lastNumController.text),
          isCheckedWeak);
      if (words.isNotEmpty) {
        await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => isTest
                    ? TestPage(words: words)
                    : WordListPage(words: words)));
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(mySnackBar(context, "範囲内に単語は見つかりません"));
      }
      changeButtonStatus();
    }
  }

  Future<void> onPressedToGetWeekWords(bool isTest) async {
    changeButtonStatus();
    words = await API.getAllWeekWords();
    if (words.isNotEmpty) {
      await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => isTest
                  ? TestPage(words: words)
                  : WordListPage(words: words)));
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(mySnackBar(context, "苦手単語は見つかりません"));
    }
    changeButtonStatus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: FutureBuilder(
        future: getAllBookNames(),
        builder: (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
          List<String>? bookNameList = snapshot.data;
          if (snapshot.connectionState == ConnectionState.waiting ||
              !snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return SingleChildScrollView(
              reverse: true,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      const Text(
                        "単語範囲を入力してください",
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
                                    .map<DropdownMenuItem<String>>(
                                        (String value) {
                                  return DropdownMenuItem<String>(
                                      alignment:
                                          AlignmentDirectional.centerStart,
                                      value: value,
                                      child: SingleChildScrollView(
                                        child: Container(
                                            constraints: BoxConstraints(
                                              maxWidth:
                                                  DeviceInfo.width(context) *
                                                      0.8,
                                            ),
                                            child: Text(value)),
                                      ));
                                }).toList(),
                              ),
                              wordNumFormField(
                                  true, firstNumController, lastNumController),
                              wordNumFormField(
                                  false, lastNumController, firstNumController),
                              IsWeakCheckField(
                                isCheckedWeek: isCheckedWeak,
                                changeIsCheckedWeak: changeIsCheckedWeak,
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10.0),
                                    child: ElevatedButton(
                                        onPressed: isDisabled
                                            ? null
                                            : () async {
                                                await onSubmitForm(false);
                                              },
                                        child: const Text("単語を学習")),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10.0),
                                    child: ElevatedButton(
                                        onPressed: isDisabled
                                            ? null
                                            : () async {
                                                await onSubmitForm(true);
                                              },
                                        child: const Text("テストを作成")),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 10.0),
                            child: ElevatedButton(
                              onPressed: isDisabled
                                  ? null
                                  : () async {
                                      await onPressedToGetWeekWords(false);
                                    },
                              child: const Text("全苦手単語を学習"),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 10.0),
                            child: ElevatedButton(
                              onPressed: isDisabled
                                  ? null
                                  : () async {
                                      await onPressedToGetWeekWords(true);
                                    },
                              child: const Text("全苦手単語をテスト"),
                            ),
                          ),
                        ],
                      ),
                    ]),
              ),
            );
          }
        },
      ),
    );
  }
}

class IsWeakCheckField extends StatefulWidget {
  const IsWeakCheckField(
      {required this.isCheckedWeek,
      required this.changeIsCheckedWeak,
      Key? key})
      : super(key: key);
  final bool isCheckedWeek;
  final Function changeIsCheckedWeak;

  @override
  State<IsWeakCheckField> createState() => _IsWeakCheckFieldState();
}

class _IsWeakCheckFieldState extends State<IsWeakCheckField> {
  bool isCheckedWeak = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      isCheckedWeak = widget.isCheckedWeek;
    });
  }

  @override
  void dispose() {
    super.dispose();
    isCheckedWeak = widget.isCheckedWeek;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: Row(
        children: [
          Checkbox(
              value: isCheckedWeak,
              onChanged: (bool? value) {
                widget.changeIsCheckedWeak();
                setState(() {
                  isCheckedWeak = value!;
                });
              }),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [Text("苦手だけ"), Text("(間違ったままの問題が出題されます)")],
          ),
        ],
      ),
    );
  }
}
