import 'package:nice_dart/nice_dart.dart';
import 'package:okhttp/okhttp.dart';

class ShittyCookieJar implements CookieJar {
  final Map<Uri, Map<String, List<Cookie>>> _cookies = {};

  @override
  List<Cookie> loadForRequest(Uri url) {
    final cookiesHeaders = (_cookies.get(url)?.let((it) {
      return it.map((key, value) =>
          MapEntry(key, value.where((cookie) => !cookie.isExpired())));
    })).orEmpty();
    final List<Cookie> cookies = [];
    cookiesHeaders.forEach((key, value) {
      if (("Cookie".equals(key, ignoreCase: true) ||
              "Cookie2".equals(key, ignoreCase: true)) &&
          value.isNotEmpty) {
        cookies.addAll(value);
      }
    });
    return cookies;
  }

  @override
  void saveFromResponse(Uri url, List<Cookie> cookies) {
    _cookies[url] = {"Set-Cookie": cookies};
  }
}

extension on Cookie {
  bool isExpired() {
    // Convert expiration time from milliseconds since epoch to DateTime object
    DateTime expirationDateTime =
        DateTime.fromMillisecondsSinceEpoch(expiresAt, isUtc: true);

    // Get the current time
    DateTime currentDateTime = DateTime.now().toUtc();

    // Compare the current time with the expiration time
    return currentDateTime.isAfter(expirationDateTime);
  }
}
