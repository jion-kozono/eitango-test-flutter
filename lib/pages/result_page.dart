import 'package:eitango_test_flutter/constants/device.dart';
import 'package:flutter/material.dart';

class ResultPage extends StatelessWidget {
  const ResultPage({Key? key}) : super(key: key);
  final bool isPerfect = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("Your Score!")),
        body: Padding(
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
                    isPerfect ? "全問正解!!" : "1/2点",
                    style: TextStyle(fontSize: 20),
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
                          children: const [
                            TableRow(
                                decoration: BoxDecoration(color: Colors.grey),
                                children: [
                                  Padding(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 8.0),
                                    child: Center(child: Text("あなたの答え")),
                                  ),
                                  Padding(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 8.0),
                                    child: Center(child: Text("英単語")),
                                  ),
                                  Padding(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 8.0),
                                    child: Center(child: Text("意味")),
                                  ),
                                  Padding(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 8.0),
                                    child: Center(child: Text("No.")),
                                  ),
                                ]),
                            TableRow(children: [
                              Padding(
                                padding:
                                EdgeInsets.symmetric(vertical: 8.0),
                                child: Center(child: Text("apples")),
                              ),Padding(
                                padding:
                                EdgeInsets.symmetric(vertical: 8.0),
                                child: Center(child: Text("apple")),
                              ),Padding(
                                padding:
                                EdgeInsets.symmetric(vertical: 8.0),
                                child: Center(child: Text("りんご")),
                              ),Padding(
                                padding:
                                EdgeInsets.symmetric(vertical: 8.0),
                                child: Center(child: Text("1")),
                              ),
                            ]),
                          ],
                        ),
                      ),
                      const Text("間違えた問題は繰り返し復讐しましょう。")
                    ])
                  : Container()
            ],
          )),
        ));
  }
}
