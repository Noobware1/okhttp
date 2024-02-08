// ignore_for_file: constant_identifier_names

import 'package:okhttp/src/cookie.dart';

/// Provides **policy** and **persistence** for HTTP cookies.
///
/// As policy, implementations of this interface are responsible for selecting which cookies to
/// accept and which to reject. A reasonable policy is to reject all cookies, though that may
/// interfere with session-based authentication schemes that require cookies.
///
/// As persistence, implementations of this interface must also provide storage of cookies. Simple
/// implementations may store cookies in memory; sophisticated ones may use the file system or
/// database to hold accepted cookies. The [cookie storage model][rfc_6265_53] specifies policies for
/// updating and expiring cookies.
///
/// [rfc_6265_53]: https://tools.ietf.org/html/rfc6265#section-5.3
///
abstract class CookieJar {
  /// Saves [cookies] from an HTTP response to this store according to this jar's policy.
  ///
  /// Note that this method may be called a second time for a single HTTP response if the response
  /// includes a trailer. For this obscure HTTP feature, [cookies] contains only the trailer's
  /// cookies.

  void saveFromResponse(Uri url, List<Cookie> cookies);

  /// Load cookies from the jar for an HTTP request to [url]. This method returns a possibly
  /// empty list of cookies for the network request.
  ///
  /// Simple implementations will return the accepted cookies that have not yet expired and that
  /// [match][Cookie.matches] [url].
  List<Cookie> loadForRequest(Uri url);

  /// A cookie jar that never accepts any cookies.
  static const CookieJar NO_COOKIES = _NoCookies();
}

class _NoCookies implements CookieJar {
  const _NoCookies();

  @override
  void saveFromResponse(Uri url, List<Cookie> cookies) {
    return;
  }

  @override
  List<Cookie> loadForRequest(Uri url) {
    return List.empty(growable: true);
  }
}
