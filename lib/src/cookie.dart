// ignore_for_file: non_constant_identifier_names

import 'package:dartx/dartx.dart'
    hide OrEmptyIterable, OrEmptyMap, NullableStringExtensions;
import 'package:okhttp/src/common/host_name_commons.dart';
import 'package:okhttp/src/common/long.dart';
import 'package:okhttp/src/common/regex.dart';
import 'package:okhttp/src/common/string.dart';
import 'package:okhttp/src/common/url_common.dart';
import 'package:okhttp/src/dates/dates.dart';
import 'package:okhttp/src/headers.dart';
import 'package:okhttp/src/utils/utils.dart';

class Cookie {
  const Cookie._({
    required this.name,
    required this.value,
    required this.expiresAt,
    required this.domain,
    required this.path,
    required this.secure,
    required this.httpOnly,
    required this.persistent,
    required this.hostOnly,
    required this.sameSite,
  });

  final String name;

  final String value;

  ///
  /// Returns the time that this cookie expires, in the same format as `DateTime.now().millisecondsSinceEpoch`.
  /// This is December 31, 9999 if the cookie is not [persistent], in which case it will expire at the
  /// end of the current session.
  ///
  /// This may return a value less than the current time, in which case the cookie is already
  /// expired. Webservers may return expired cookies as a mechanism to delete previously set cookies
  /// that may or may not themselves be expired.
  ///

  final int expiresAt;

  ///
  /// Returns the cookie's domain. If [hostOnly] returns true this is the only domain that matches
  /// this cookie; otherwise it matches this domain and all subdomains.
  ///
  final String domain;

  ///
  /// Returns this cookie's path. This cookie matches URLs prefixed with path segments that match
  /// this path's segments. For example, if this path is `/foo` this cookie matches requests to
  /// `/foo` and `/foo/bar`, but not `/` or `/football`.
  ///
  final String path;

  /// Returns true if this cookie should be limited to only HTTPS requests. ///
  final bool secure;

  ///
  /// Returns true if this cookie should be limited to only HTTP APIs. In web browsers this prevents
  /// the cookie from being accessible to scripts.
  ///
  final bool httpOnly;

  /// Returns true if this cookie does not expire at the end of the current session.
  final bool persistent; // True if 'expires' or 'max-age' is present.

  ///
  /// Returns true if this cookie's domain should be interpreted as a single host name, or false if
  /// it should be interpreted as a pattern. This flag will be false if its `Set-Cookie` header
  /// included a `domain` attribute.
  ///
  /// For example, suppose the cookie's domain is `example.com`. If this flag is true it matches
  /// **only** `example.com`. If this flag is false it matches `example.com` and all subdomains
  /// including `api.example.com`, `www.example.com`, and `beta.api.example.com`.
  ///
  final bool hostOnly; // True unless 'domain' is present.

  ///
  /// Returns a string describing whether this cookie is sent for cross-site calls.
  ///
  /// Two URLs are on the same site if they share a [top private domain][HttpUrl.topPrivateDomain].
  /// Otherwise, they are cross-site URLs.
  ///
  /// When a URL is requested, it may be in the context of another URL.
  ///
  ///  * **Embedded resources like images and iframes** in browsers use the context as the page in
  ///    the address bar and the subject is the URL of an embedded resource.
  ///
  ///  * **Potentially-destructive navigations such as HTTP POST calls** use the context as the page
  ///    originating the navigation, and the subject is the page being navigated to.
  ///
  /// The values of this attribute determine whether this cookie is sent for cross-site calls:
  ///
  ///  - "Strict": the cookie is omitted when the subject URL is an embedded resource or a
  ///    potentially-destructive navigation.
  ///
  ///  - "Lax": the cookie is omitted when the subject URL is an embedded resource. It is sent for
  ///    potentially-destructive navigation. This is the default value.
  ///
  ///  - "None": the cookie is always sent. The "Secure" attribute must also be set when setting this
  ///    value.
  ///

  final String? sameSite;

  bool matches(Uri url) {
    final domainMatch =
        (hostOnly) ? url.host == domain : _domainMatch(url.host, domain);

    if (!domainMatch) return false;

    if (!pathMatch(url, path)) return false;

    return !secure || url.isHttps;
  }

  static CookieBuilder Builder() => _CookieBuilder();

  CookieBuilder newBuilder() => _CookieBuilder(this);

  @override
  bool operator ==(Object other) {
    return other is Cookie &&
        other.name == name &&
        other.value == value &&
        other.expiresAt == expiresAt &&
        other.domain == domain &&
        other.path == path &&
        other.secure == secure &&
        other.httpOnly == httpOnly &&
        other.persistent == persistent &&
        other.hostOnly == hostOnly &&
        other.sameSite == sameSite;
  }

  @override
  int get hashCode {
    var result = 17;
    result = 31 * result + name.hashCode;
    result = 31 * result + value.hashCode;
    result = 31 * result + expiresAt.hashCode;
    result = 31 * result + domain.hashCode;
    result = 31 * result + path.hashCode;
    result = 31 * result + secure.hashCode;
    result = 31 * result + httpOnly.hashCode;
    result = 31 * result + persistent.hashCode;
    result = 31 * result + hostOnly.hashCode;
    result = 31 * result + sameSite.hashCode;
    return result;
  }

  ///  * forObsoleteRfc2965 true to include a leading `.` on the domain pattern. This is
  ///  necessary for `example.com` to match `www.example.com` under RFC 2965. This extra dot is
  ///    ignored by more recent specifications.
  @override
  String toString([bool forObsoleteRfc2965 = false]) {
    var result = '$name=$value';
    if (persistent) {
      if (expiresAt == -9223372036854775808) {
        result += '; max-age=0';
      } else {
        result +=
            '; expires=${DateTime.fromMillisecondsSinceEpoch(expiresAt).toHttpDateString()}';
      }
    }
    if (!hostOnly) {
      result += '; domain=';
      if (forObsoleteRfc2965) result += '.';

      result += domain;
    }

    result += '; path=$path';

    if (secure) result += '; secure';

    if (httpOnly) result += '; httponly';

    if (sameSite != null) result += '; samesite=$sameSite';

    return result;
  }

  static bool _domainMatch(String urlHost, String domain) {
    if (urlHost == domain) {
      return true; // As in 'example.com' matching 'example.com'.
    }

    return urlHost.endsWith(domain) &&
        urlHost[urlHost.length - domain.length - 1] == '.' &&
        !urlHost.canParseAsIpAddress;
  }

  bool pathMatch(Uri url, String path) {
    final urlPath = url.path;
    if (urlPath == path) return true; // As in '/foo' matching '/foo'.

    if (urlPath.startsWith(path)) {
      if (path.endsWith("/")) return true; // As in '/' matching '/foo'.
      if (urlPath[path.length] == '/') {
        return true; // As in '/foo' matching '/foo/bar'.
      }
    }

    return false;
  }

  static List<Cookie> parseAll(Uri url, Headers headers) {
    final cookies = headers.values("Set-Cookie")?.let((it) {
      List<Cookie>? cookies;
      for (var i = 0; i < it.length; i++) {
        try {
          final cookie = parse(url, it[i]);
          cookies ??= [];
          cookies.add(cookie!);
        } catch (e) {
          continue;
        }
      }
      if (cookies != null) return List<Cookie>.of(cookies, growable: false);
      return List<Cookie>.empty(growable: true);
    });
    return cookies.orEmpty();
  }

  static Cookie? parse(Uri url, String setCookie) {
    return _parse(DateTime.now().millisecondsSinceEpoch, url, setCookie);
  }

  static Cookie? _parse(int currentTimeMillis, Uri url, String setCookie) {
    final cookiePairEnd = setCookie.delimiterOffset(delimiters: ';');

    final pairEqualsSign =
        setCookie.delimiterOffset(delimiters: '=', end: cookiePairEnd);

    if (pairEqualsSign == cookiePairEnd) return null;

    final cookieName = setCookie.trimSubstring(0, pairEqualsSign);

    if (cookieName.isEmpty || cookieName.indexOfControlOrNonAscii != -1) {
      return null;
    }
    final cookieValue =
        setCookie.trimSubstring(pairEqualsSign + 1, cookiePairEnd);
    if (cookieValue.indexOfControlOrNonAscii != -1) return null;

    int expiresAt = MAX_DATE;
    int deltaSeconds = -1;
    String? domain;
    String? path;
    bool secureOnly = false;
    bool httpOnly = false;
    bool hostOnly = true;
    bool persistent = false;
    String? sameSite;

    var pos = cookiePairEnd + 1;
    final limit = setCookie.length;
    while (pos < limit) {
      final attributePairEnd =
          setCookie.delimiterOffset(delimiters: ';', start: pos, end: limit);

      final attributeEqualsSign = setCookie.delimiterOffset(
          delimiters: '=', start: pos, end: attributePairEnd);

      final attributeName = setCookie.trimSubstring(pos, attributeEqualsSign);
      final attributeValue = (attributeEqualsSign < attributePairEnd)
          ? setCookie.trimSubstring(attributeEqualsSign + 1, attributePairEnd)
          : "";

      switch (attributeName.toLowerCase()) {
        case 'expires':
          try {
            expiresAt = parseExpires(attributeValue, 0, attributeValue.length);

            persistent = true;
          } catch (_, s) {
            print('$_\n$s');
            // Ignore this attribute, it isn't recognizable as a date.
          }

          break;
        case 'max-age':
          try {
            deltaSeconds = parseMaxAge(attributeValue);
            persistent = true;
          } catch (_) {
            // Ignore this attribute, it isn't recognizable as a max age.
          }

          break;
        case 'domain':
          try {
            domain = parseDomain(attributeValue);
            hostOnly = false;
          } catch (_) {
            // Ignore this attribute, it isn't recognizable as a domain.
          }
          break;
        case 'path':
          path = attributeValue;
          break;
        case 'secure':
          secureOnly = true;
          break;
        case 'httponly':
          httpOnly = true;
          break;
        case 'samesite':
          sameSite = attributeValue;
          break;
        default:
          pos = attributePairEnd + 1;
          break;
      }

      pos = attributePairEnd + 1;
    }

    // If 'Max-Age' is present, it takes precedence over 'Expires', regardless of the order the two
    // attributes are declared in the cookie string.
    if (deltaSeconds == Long.MIN_VALUE) {
      expiresAt = Long.MIN_VALUE;
    } else if (deltaSeconds != -1) {
      final deltaMilliseconds = (deltaSeconds <= Long.MAX_VALUE / 1000)
          ? deltaSeconds * 1000
          : Long.MAX_VALUE;
      expiresAt = currentTimeMillis + deltaMilliseconds;
      if (expiresAt < currentTimeMillis || expiresAt > MAX_DATE) {
        expiresAt = MAX_DATE; // Handle overflow & limit the date range.
      }
    }

    // If the domain is present, it must domain match. Otherwise we have a host-only cookie.
    final urlHost = url.host;
    if (domain == null) {
      domain = urlHost;
    } else if (!_domainMatch(urlHost, domain)) {
      return null; // No domain match? This is either incompetence or malice!
    }

    // will try to implement this later
    // // If the domain is a suffix of the url host, it must not be a public suffix.
    // if (urlHost.length != domain.length &&
    //   PublicSuffixDatabase.get().getEffectiveTldPlusOne(domain) == null) {
    //   return null
    // }

    // If the path is absent or didn't start with '/', use the default path. It's a string like
    // '/foo/bar' for a URL like 'http://example.com/foo/bar/baz'. It always starts with '/'.
    if (path == null || !path.startsWith("/")) {
      final encodedPath = url.encodedPath;
      final lastSlash = encodedPath.lastIndexOf('/');
      path = (lastSlash != 0) ? encodedPath.substring(0, lastSlash) : "/";
    }

    return Cookie._(
      name: cookieName,
      value: cookieValue,
      expiresAt: expiresAt,
      domain: domain,
      path: path,
      secure: secureOnly,
      httpOnly: httpOnly,
      persistent: persistent,
      hostOnly: hostOnly,
      sameSite: sameSite,
    );
  }

  /// Parse a date as specified in RFC 6265, section 5.1.1.
  static int parseExpires(String s, int pos, int limit) {
    pos = dateCharacterOffset(s, pos, limit, false);

    var hour = -1;
    var minute = -1;
    var second = -1;
    var dayOfMonth = -1;
    var month = -1;
    var year = -1;
    final matcher = BetterRegex.fromRegex(_TIME_PATTERN).matcher(s);

    while (pos < limit) {
      final end = dateCharacterOffset(s, pos + 1, limit, true);
      matcher.region(pos, end);
      if (hour == -1 && matcher.usePattern(_TIME_PATTERN).matches()) {
        hour = matcher.group(1).toInt();
        minute = matcher.group(2).toInt();
        second = matcher.group(3).toInt();
      } else if (dayOfMonth == -1 &&
          matcher.usePattern(_DAY_OF_MONTH_PATTERN).matches()) {
        dayOfMonth = matcher.group(1).toInt();
      } else if (month == -1 && matcher.usePattern(_MONTH_PATTERN).matches()) {
        final monthString = matcher.group(1).toLowerCase();
        month = _MONTH_PATTERN.pattern.indexOf(monthString) ~/ 4;
      } else if (year == -1 && matcher.usePattern(_YEAR_PATTERN).matches()) {
        year = matcher.group(1).toInt();
      }
      pos = dateCharacterOffset(s, end + 1, limit, false);
    }
    // Convert two-digit years into four-digit years. 99 becomes 1999, 15 becomes 2015.
    if (year >= 77 && year <= 98) year += 1900;
    if (year >= 77 && year <= 145) year += 2000;

    // If any partial is omitted or out of range, return -1. The date is impossible. Note that leap
    // seconds are not supported by this syntax.
    assert(year >= 1601);
    assert(month != -1);
    assert(dayOfMonth >= 1 && dayOfMonth <= 31);
    assert(hour >= 0 && hour <= 23);
    assert(minute >= 0 && minute <= 59);
    assert(second >= 0 && second <= 59);

    return DateTime(
      year,
      month - 1,
      dayOfMonth,
      hour,
      minute,
      second,
      0,
    ).millisecondsSinceEpoch;
  }

  /// Returns the index of the next date character in `input`, or if `invert` the index
  /// of the next non-date character in `input`.
  static int dateCharacterOffset(
      String input, int pos, int limit, bool invert) {
    for (int i = pos; i < limit; i++) {
      int c = input.codeUnitAt(i);
      bool dateCharacter = (c < ' '.code && c != '\t'.code ||
          c >= '\u007f'.codeUnitAt(0) ||
          c >= '0'.code && c <= '9'.code ||
          c >= 'a'.code && c <= 'z'.code ||
          c >= 'A'.code && c <= 'Z'.code ||
          c == ':'.code);
      if (dateCharacter != invert) return i;
    }
    return limit;
  }

  /// Returns the positive value if [s] is positive, or [Long.MIN_VALUE] if it is either 0 or
  /// negative. If the value is positive but out of range, this returns [Long.MAX_VALUE].
  static int parseMaxAge(String s) {
    try {
      final parsed = s.toInt();
      return (parsed <= 0) ? Long.MIN_VALUE : parsed;
    } catch (e) {
      // Check if the value is an integer (positive or negative) that's too big for a long.
      if (RegExp("-?\\d+").hasMatch(s)) {
        return (s.startsWith("-")) ? Long.MIN_VALUE : Long.MAX_VALUE;
      }
      rethrow;
    }
  }

  /// Returns a domain string like `example.com` for an input domain like `EXAMPLE.COM`
  /// or `.example.com`.

  static String parseDomain(String s) {
    assert(!s.endsWith("."));
    // throw UnimplementedError();
    return s;
    // return s.removePrefix(".").toCanonicalHost();
  }
}

class _CookieBuilder extends CookieBuilder {
  _CookieBuilder([Cookie? cookie]) : super(cookie);
}

sealed class CookieBuilder {
  late String? _name;
  late String? _value;
  late int _expiresAt;
  late String? _domain;
  late String _path;
  late bool _secure;
  late bool _httpOnly;
  late bool _persistent;
  late bool _hostOnly;
  late String? _sameSite;

  CookieBuilder([Cookie? cookie]) {
    _name = cookie?.name;
    _value = cookie?.value;
    _expiresAt = cookie?.expiresAt ?? MAX_DATE;
    _domain = cookie?.domain;
    _path = cookie?.path ?? "/";
    _secure = cookie?.secure ?? false;
    _httpOnly = cookie?.httpOnly ?? false;
    _persistent = cookie?.persistent ?? false;
    _hostOnly = cookie?.hostOnly ?? false;
    _sameSite = cookie?.sameSite;
  }

  CookieBuilder name(String name) {
    return apply((it) {
      assert(name.trim() == name, "name is not trimmed");
      it._name = name;
    });
  }

  CookieBuilder value(String value) {
    return apply((it) {
      assert(value.trim() == value, "value is not trimmed");
      it._value = value;
    });
  }

  CookieBuilder expiresAt(int expiresAt) {
    return apply((it) {
      if (expiresAt <= 0) expiresAt = Long.MIN_VALUE;
      if (expiresAt > MAX_DATE) expiresAt = MAX_DATE;
      it._expiresAt = expiresAt;
      it._persistent = true;
    });
  }

  CookieBuilder domain(String domain) => _setDomain(domain, false);

  /// Set the host-only domain for this cookie. The cookie will match [domain] but none of
  /// its subdomains.
  CookieBuilder hostOnlyDomain(String domain) => _setDomain(domain, true);

  CookieBuilder _setDomain(String domain, bool hostOnly) {
    return apply((it) {
      it._domain = domain;
      it._persistent = true;
    });
  }

  CookieBuilder path(String path) {
    return apply((it) {
      it._path = path;
    });
  }

  CookieBuilder secure() {
    return apply((it) {
      it._secure = true;
    });
  }

  CookieBuilder httpOnly() {
    return apply((it) {
      it._httpOnly = true;
    });
  }

  CookieBuilder sameSite(String sameSite) {
    return apply((it) {
      assert(sameSite.trim() == sameSite, "sameSite is not trimmed");
      it._sameSite = sameSite;
    });
  }

  Cookie build() {
    assert(_name != null, {"name == null"});
    assert(_value != null, {"value == null"});
    assert(_domain != null, {"domain == null"});
    return Cookie._(
      name: _name!,
      value: _value!,
      expiresAt: _expiresAt,
      domain: _domain!,
      path: _path,
      secure: _secure,
      httpOnly: _httpOnly,
      persistent: _persistent,
      hostOnly: _hostOnly,
      sameSite: _sameSite,
    );
  }
}

final _YEAR_PATTERN = RegExp("(\\d{2,4})[^\\d]*");

final _MONTH_PATTERN = RegExp(
    "(jan|feb|mar|apr|may|jun|jul|aug|sep|oct|nov|dec)",
    caseSensitive: false);

final _DAY_OF_MONTH_PATTERN = RegExp("(\\d{1,2})[^\\d]*");

final _TIME_PATTERN = RegExp("(\\d{1,2}):(\\d{1,2}):(\\d{1,2})[^\\d]*");
