
import 'package:eitango_test_flutter/components/word_name_form_field.dart';
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
  bool isCheckedWeek = false;
  late TextEditingController bookNameController;
  late TextEditingController firstNumController;
  late TextEditingController lastNumController;

  late List<String> bookNameList;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    firstNumController = TextEditingController(text: "$initialValue");
    lastNumController = TextEditingController(text: "${initialValue + 20}");
    bookNameList = ["参考書1", "参考書2"];
    bookNameController = TextEditingController(text: bookNameList[0]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: ElevatedButton(
                    onPressed: () {},
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
                        TextFormField(
                          controller: bookNameController,
                          onFieldSubmitted: (String? newValue) {
                            bookNameController.text = bookNameList.contains(newValue)
                                ? newValue!
                                : bookNameList[0];
                          },
                          decoration: InputDecoration(
                            labelText: "単語帳名",
                            suffixIcon: DropdownButton(
                              icon: const Icon(Icons.arrow_drop_down),
                              onChanged: (String? newValue) {
                                setState(() {
                                  bookNameController.text = newValue!;
                                });
                              },

                              items: bookNameList.map<
                                  DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                        wordNumFormField(true, firstNumController, lastNumController),
                        wordNumFormField(false, lastNumController, firstNumController),
                        Row(
                          children: [
                            Checkbox(value: isCheckedWeek, onChanged: (bool? value) {
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
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Processing Data')),
                                  );
                                }
                              }, child: const Text("テストを作成")),
                        ),
                      ],
                    ),
                  ),
                ),
              ]),
            ),
          ),
        ));
  }
}