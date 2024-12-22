class Utils {
  static String URLEncode(String input) {
    String encoded = '';
    for (var char in input.split("")) {
      if (char == ' ') {
        encoded += "%20";
      } else if (char == '/') {
        encoded += "%2F";
      } else {
        encoded += char;
      }
    }
    return encoded;
  }
}
