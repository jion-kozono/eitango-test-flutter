class Utils {
  Utils._() {
    throw AssertionError("private Constructor");
  }

  static List<Map<String, String>> getListFromExample(
      String example, String translation) {
    List<String> exampleList = example.split('\n');
    List<String> translationList = translation.split('\n');
    List<Map<String, String>> returnList = [];

    for (int i = 0; i < exampleList.length; i++) {
      Map<String, String> dict = {
        "example": exampleList[i],
        "translation": translationList[i]
      };
      returnList.add(dict);
    }
    return returnList;
  }
}
