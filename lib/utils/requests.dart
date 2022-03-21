import 'package:eitango_test_flutter/constants/url.dart';
import 'package:eitango_test_flutter/model/word.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class API {
  static Future<List<Word>> getAllWeekWords() async {
    Uri urlWeekWords = Uri.parse('$apiUrl/weekWords/');
    return await _getWords(urlWeekWords);
  }

  static Future<List<String>> getAllBookNames() async {
    Uri urlBooks = Uri.parse('$apiUrl/books/');
    var res = await http.get(urlBooks);
    if (res.statusCode == 200) {
      String responseBody = utf8.decode(res.bodyBytes);
      print(responseBody);
      var jsonResponse = json.decode(responseBody).cast<String>();
      return jsonResponse;
    } else {
      throw Exception("参考書の取得に失敗しました。");
    }
  }

  static Future<List<Word>> getTestWords(
      String bookName, int firstNum, int lastNum, bool isOnlyWeak) async {
    Uri urlTestWords = Uri.parse(
        '$apiUrl/words/$bookName?first=$firstNum&last=$lastNum&is_only_week=$isOnlyWeak');
    return await _getWords(urlTestWords);
  }

  static Future<void> postIsCorrect(isCorrectListOfDict) async {
    Uri urlIsCorrect = Uri.parse('$apiUrl/isCorrect');
    return await _reqAndRes(urlIsCorrect, "正当を正常に送信できませんでした。");
  }

  static Future<List<Word>> _getWords(Uri url) async{
    var res = await http.get(url);
    if (res.statusCode == 200) {
      String responseBody = utf8.decode(res.bodyBytes);
      var jsonResponse = json.decode(responseBody);
      List<Word> words = [];
      jsonResponse.forEach((wordJson) {
        Word word = Word.fromJson(wordJson);
        words.add(word);
      });
      return words;
    } else {
      throw Exception("テスト単語の取得に失敗しました。");
    }
  }

  static Future<T> _reqAndRes<T>(Uri url, String exception) async {
    var res = await http.get(url);
    if (res.statusCode == 200) {
      String responseBody = utf8.decode(res.bodyBytes);
      print(responseBody);
      var jsonResponse = json.decode(responseBody).cast<String>();
      return jsonResponse;
    } else {
      throw Exception(exception);
    }
  }
}
