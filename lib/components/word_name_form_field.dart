import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Widget wordNumFormField(bool isFirst, TextEditingController mainController,
    TextEditingController controllerToCompare) {
  int subtractNum = isFirst ? 1 : 2;

  return TextFormField(
    controller: mainController,
    decoration: InputDecoration(
      labelText: isFirst ? "最初の単語番号" : "最後の単語番号",
      suffixIcon: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              mainController.text = "${int.parse(mainController.text) + 1}";
            },
          ),
          IconButton(
            icon: const Icon(Icons.remove),
            onPressed: () {
              mainController.text = int.parse(mainController.text) > subtractNum
                  ? "${int.parse(mainController.text) - subtractNum}"
                  : "$subtractNum";
            },
          ),
        ],
      ),
    ),
    validator: (value) {
      // 最初の単語番号と最後の単語番号を比較して最初の単語番号の方が大きい場合
      if (!isFirst &&
          int.parse(mainController.text) <=
              int.parse(controllerToCompare.text)) {
        return '最後の単語番号の方が大きい必要があります';
      }
      return null;
    },
    keyboardType: TextInputType.number,
    inputFormatters: <TextInputFormatter>[
      FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
    ],
  );
}
