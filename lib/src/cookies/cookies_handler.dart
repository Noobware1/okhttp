class CookieHandler {
  final Map<Uri, List<String>> _cookies = {};

  List<String>? get(Uri uri) {
    return _cookies[uri];
  }

  void put(Uri uri, Map<String, List<String>> multimap) {
    final cookies = multimap["Set-Cookie"];
    if (cookies != null) {
      _cookies[uri] = cookies;
    }
  }
}
