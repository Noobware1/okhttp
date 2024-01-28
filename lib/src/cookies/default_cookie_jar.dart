// import 'package:okhttp/okhttp.dart';
// import 'package:okhttp/src/cookie.dart';
// import 'package:okhttp/src/cookie_jar.dart';

// class DefaultCookieJar implements CookieJar {
//   @override
//   List<Cookie> loadForRequest(Uri url) {

//      }

//   @override
//   void saveFromResponse(Uri url, List<Cookie> cookies) {
//     final cookieStrings = [];
//     for (var cookie in cookies) {
//       cookieStrings.add(cookieToString(cookie, true));
//     }
//     final multimap = {"Set-Cookie" : cookieStrings};
//     try {
//       cookieHandler.put(url, multimap);
//     } catch (e) {
//    Logger(color: Color.red).log("Saving cookies failed for ${url.resolve('/...')}");
//     }
//     }
//   }

// }
