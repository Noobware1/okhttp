// import 'package:nice_dart/nice_dart.dart';

// class HttpUrl {
//   /// Either "http" or "https".
//   final String scheme;

//   /// The decoded username, or an empty string if none is present.
//   ///
//   /// | URL                              | `username()` |
//   /// | :------------------------------- | :----------- |
//   /// | `http://host/`                   | `""`         |
//   /// | `http://username@host/`          | `"username"` |
//   /// | `http://username:password@host/` | `"username"` |
//   /// | `http://a%20b:c%20d@host/`       | `"a b"`      |
//   final String username;

//   /// Returns the decoded password, or an empty string if none is present.
//   ///
//   /// | URL                              | `password()` |
//   /// | :------------------------------- | :----------- |
//   /// | `http://host/`                   | `""`         |
//   /// | `http://username@host/`          | `""`         |
//   /// | `http://username:password@host/` | `"password"` |
//   /// | `http://a%20b:c%20d@host/`       | `"c d"`      |
//   final String password;

//   /// The host address suitable for use with [InetAddress.getAllByName]. May be:
//   ///
//   ///  * A regular host name, like `android.com`.
//   ///
//   ///  * An IPv4 address, like `127.0.0.1`.
//   ///
//   ///  * An IPv6 address, like `::1`. Note that there are no square braces.
//   ///
//   ///  * An encoded IDN, like `xn--n3h.net`.
//   ///
//   /// | URL                   | `host()`        |
//   /// | :-------------------- | :-------------- |
//   /// | `http://android.com/` | `"android.com"` |
//   /// | `http://127.0.0.1/`   | `"127.0.0.1"`   |
//   /// | `http://[::1]/`       | `"::1"`         |
//   /// | `http://xn--n3h.net/` | `"xn--n3h.net"` |
//   final String host;

//   /// The explicitly-specified port if one was provided, or the default port for this URL's scheme.
//   /// For example, this returns 8443 for `https://square.com:8443/` and 443 for
//   /// `https://square.com/`. The result is in `[1..65535]`.
//   ///
//   /// | URL                 | `port()` |
//   /// | :------------------ | :------- |
//   /// | `http://host/`      | `80`     |
//   /// | `http://host:8000/` | `8000`   |
//   /// | `https://host/`     | `443`    |
//   final int port;

//   /// A list of path segments like `["a", "b", "c"]` for the URL `http://host/a/b/c`. This list is
//   /// never empty though it may contain a single empty string.
//   ///
//   /// | URL                      | `pathSegments()`    |
//   /// | :----------------------- | :------------------ |
//   /// | `http://host/`           | `[""]`              |
//   /// | `http://host/a/b/c"`     | `["a", "b", "c"]`   |
//   /// | `http://host/a/b%20c/d"` | `["a", "b c", "d"]` |
//   final List<String> pathSegments;

//   /// Alternating, decoded query names and values, or null for no query. Names may be empty or
//   /// non-empty, but never null. Values are null if the name has no corresponding '=' separator, or
//   /// empty, or non-empty.
//   final Map<String, String> queryParameters;

//   /// This URL's fragment, like `"abc"` for `http://host/#abc`. This is null if the URL has no
//   /// fragment.
//   ///
//   /// | URL                    | `fragment()` |
//   /// | :--------------------- | :----------- |
//   /// | `http://host/`         | null         |
//   /// | `http://host/#`        | `""`         |
//   /// | `http://host/#abc`     | `"abc"`      |
//   /// | `http://host/#abc|def` | `"abc|def"`  |
//   final String? fragment;

//   /// Canonical URL.
//   final String url;

//   HttpUrl(
//       {required this.scheme,
//       required this.username,
//       required this.password,
//       required this.host,
//       required this.port,
//       required this.pathSegments,
//       required this.queryParameters,
//       required this.fragment,
//       required this.url});

//   bool get isHttps => scheme == "https";

// }

// class HttpUrlBuilder {
//   String? _scheme;
//   String _encodedUsername = "";
//   String _encodedPassword = "";
//   String? _host;
//   int _port = -1;
//   List<String> _encodedPathSegments = const [];
//   Map<String, String> _encodedQueryNamesAndValues = {};
//   String? _encodedFragment;

//   /**
//    * @param scheme either "http" or "https".
//    */
//   HttpUrlBuilder scheme(String scheme) {
//     return apply((it) {
//       it._scheme = scheme;
//     });
//   }

//   HttpUrlBuilder username(String username) {
//     return apply((it) {

//     });
//   }

//   HttpUrlBuilder encodedUsername(String encodedUsername) {
//     return apply((it) {});
//   }

//   HttpUrlBuilder password(String password) {
//     return apply((it) {});
//   }

//   HttpUrlBuilder encodedPassword(String encodedPassword) {
//     return apply((it) {});
//   }

//   /**
//    * @param host either a regular hostname, International Domain Name, IPv4 address, or IPv6
//    * address.
//    */

//   HttpUrlBuilder host(String host) {
//     return apply((it) {});
//   }

//   HttpUrlBuilder port(String port) {
//     return apply((it) {});
//   }

//   HttpUrlBuilder addPathSegment(String pathSegment) {
//     return apply((it) {});
//   }
//   /**
//    * Adds a set of path segments separated by a slash (either `\` or `/`). If `pathSegments`
//    * starts with a slash, the resulting URL will have empty path segment.
//    */

//   HttpUrlBuilder addPathSegments(String pathSegments) {
//     return apply((it) {});
//   }

//   HttpUrlBuilder addEncodedPathSegment(String encodedPathSegment) {
//     return apply((it) {});
//   }

//   /**
//    * Adds a set of encoded path segments separated by a slash (either `\` or `/`). If
//    * `encodedPathSegments` starts with a slash, the resulting URL will have empty path segment.
//    */

//   HttpUrlBuilder addEncodedPathSegments(String encodedPathSegments) {
//     return apply((it) {});
//   }

//   HttpUrlBuilder setPathSegment(int index, String pathSegment) {
//     return apply((it) {});
//   }

//   HttpUrlBuilder setEncodedPathSegment(int index, String encodedPathSegment) {
//     return apply((it) {});
//   }

//   HttpUrlBuilder removePathSegment(int index) {
//     return apply((it) {});
//   }

//   HttpUrlBuilder encodedPath(String encodedPath) {
//     return apply((it) {});
//   }

//   HttpUrlBuilder query(String? query) {
//     return apply((it) {});
//   }

//   HttpUrlBuilder encodedQuery(String? encodedQuery) {
//     return apply((it) {});
//   }

//   /** Encodes the query parameter using UTF-8 and adds it to this URL's query string. */
//   HttpUrlBuilder addQueryParameter(String name, String? value) {
//     return apply((it) {});
//   }

//   /** Adds the pre-encoded query parameter to this URL's query string. */
//   HttpUrlBuilder addEncodedQueryParameter(
//       String encodedName, String? encodedValue) {
//     return apply((it) {});
//   }

//   HttpUrlBuilder setQueryParameter(String name, String? value) {
//     return apply((it) {});
//   }

//   HttpUrlBuilder setEncodedQueryParameter(
//       String encodedName, String? encodedValue) {
//     return apply((it) {});
//   }

//   HttpUrlBuilder removeAllQueryParameters(String name) {
//     return apply((it) {});
//   }

//   HttpUrlBuilder removeAllEncodedQueryParameters(String encodedName) {
//     return apply((it) {});
//   }

//   HttpUrlBuilder fragment(String? fragment) {
//     return apply((it) {});
//   }

//   HttpUrlBuilder encodedFragment(String? encodedFragment) {
//     return apply((it) {});
//   }
// }
