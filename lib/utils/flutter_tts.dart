import 'package:flutter_tts/flutter_tts.dart';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;

class FlutterTTS {
  static late FlutterTts flutterTts;
  String? engine;

  static bool get isIOS => !kIsWeb && Platform.isIOS;
  static bool get isAndroid => !kIsWeb && Platform.isAndroid;
  static bool get isWeb => kIsWeb;

  static Future _setAwaitOptions() async {
    await flutterTts.awaitSpeakCompletion(true);
  }

  static Future _getDefaultEngine() async {
    await flutterTts.getDefaultEngine;
  }

  static initTts() {
    flutterTts = FlutterTts();
    _setAwaitOptions();
    if (isAndroid) {
      _getDefaultEngine();
    }
  }

  static Future<void> speakWord(String word) async {
    await flutterTts.setLanguage("en-US");
    await flutterTts.setSpeechRate(0.5);
    await flutterTts.setVolume(1.0);
    await flutterTts.setPitch(1.0);
    await flutterTts.speak(word);
  }
}
