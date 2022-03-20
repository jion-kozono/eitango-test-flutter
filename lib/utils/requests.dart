import 'package:eitango_test_flutter/constants/url.dart';
import 'package:eitango_test_flutter/model/word.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class API {
  static Future<List<Word>> getAllWeekWords() async {
    Uri urlWeekWords = Uri.parse('$apiUrl/weekWords/');
    return await _reqAndRes<List<Word>>(urlWeekWords, "苦手単語の取得に失敗しました。");
  }

  static Future<List<String>> getAllBookNames() async {
    Uri urlBooks = Uri.parse('$apiUrl/books/');
    var res = await _reqAndRes<List<String>>(urlBooks, "参考書の取得に失敗しました。");
    return res;
  }

  static Future<void> getTestWords(
      String bookName, int firstNum, int lastNum, bool isOnlyWeak) async {
    Uri urlTestWords =
    Uri.parse('$apiUrl/words/$bookName?first=$firstNum&last=$lastNum&is_only_week=$isOnlyWeak');
    return await _reqAndRes(urlTestWords, "テスト単語の取得に失敗しました。");
  }

  static Future<void> postIsCorrect(isCorrectListOfDict) async {
    Uri urlIsCorrect = Uri.parse('$apiUrl/isCorrect');
    return await _reqAndRes(urlIsCorrect, "正当を正常に送信できませんでした。");
  }

  static Future<T> _reqAndRes<T>(Uri url, String exception) async {
    var res = await http.get(url);
    print(url);
    if(res.statusCode == 200) {
      String responseBody = utf8.decode(res.bodyBytes);
      var jsonResponse = json.decode(responseBody).cast<String>();
      return jsonResponse;
    }else {
      throw Exception(exception);
    }
  }
}


