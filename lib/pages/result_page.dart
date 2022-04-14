import 'package:eitango_test_flutter/constants/device.dart';
import 'package:flutter/material.dart';

class ResultPage extends StatefulWidget {
  const ResultPage(
      {required this.wrongWords, required this.scoreText, Key? key})
      : super(key: key);
  final List<Map<String, dynamic>> wrongWords;
  final String scoreText;

  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  @override
  Widget build(BuildContext context) {
    bool isPerfect = widget.wrongWords.isEmpty;

    return Scaffold(
        appBar: AppBar(title: const Text("Your Score!")),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Center(
                child: Column(
              children: [
                Container(
                    margin: const EdgeInsets.symmetric(vertical: 16.0),
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    decoration: BoxDecoration(
                      color: isPerfect ? Colors.greenAccent : Colors.redAccent,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    width: DeviceInfo.width(context) * 3 / 4,
                    child: Center(
                        child: Text(
                      isPerfect ? "全問正解!!" : widget.scoreText,
                      style: const TextStyle(fontSize: 20),
                    ))),
                !isPerfect
                    ? Column(children: [
                        const Text(
                          "間違えた単語",
                          style: TextStyle(fontSize: 20),
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.fromLTRB(14.0, 20.0, 14.0, 30.0),
                          child: Table(
                              border: TableBorder.all(),
                              children: wrongTableRows(widget.wrongWords)),
                        ),
                        const Text("間違えた問題は繰り返し復讐しましょう。"),
                        const SizedBox(
                          height: 20,
                        )
                      ])
                    : Container()
              ],
            )),
          ),
        ));
  }
}

List<TableRow> wrongTableRows(List<Map<String, dynamic>> wrongWords) {
  List<TableRow> wrongTableRowList = [
    const TableRow(decoration: BoxDecoration(color: Colors.grey), children: [
      Padding(
        padding: EdgeInsets.symmetric(vertical: 8.0),
        child: Center(child: Text("あなたの答え")),
      ),
      Padding(
        padding: EdgeInsets.symmetric(vertical: 8.0),
        child: Center(child: Text("問")),
      ),
      Padding(
        padding: EdgeInsets.symmetric(vertical: 8.0),
        child: Center(child: Text("答")),
      ),
      Padding(
        padding: EdgeInsets.symmetric(vertical: 8.0),
        child: Center(child: Text("英単語")),
      ),
    ])
  ];
  wrongWords.asMap().forEach((int index, wrongWord) {
    wrongTableRowList.add(TableRow(children: [
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Center(child: Text(wrongWord["あなたの答え"])),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Center(child: Text(wrongWord["問"])),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Center(child: Text(wrongWord["答"])),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Center(child: Text(wrongWord["英単語"])),
      ),
    ]));
  });
  return wrongTableRowList;
}
