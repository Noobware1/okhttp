import 'package:nice_dart/nice_dart.dart';
import 'package:okhttp/okhttp.dart';
import 'package:okhttp/src/connection/real_chain.dart';
import 'package:okhttp/src/constants/useragent.dart';
import 'package:okhttp/src/interceptor.dart';
import 'package:okhttp/src/response.dart';

///
/// Bridges from application code to network code. First it builds a network request from a user
/// request. Then it proceeds to call the network. Finally it builds a user response from the network
/// response.
///
class BridgeInterceptor implements Interceptor {
  BridgeInterceptor(this.cookieJar);

  final CookieJar cookieJar;
  @override
  Future<Response> intercept(Chain chain) async {
    chain as RealInterceptorChain;

    final userRequest = chain.request;
    final requestBuilder = userRequest.newBuilder();
    final body = userRequest.body;
    if (body != null) {
      requestBuilder.header("Content-Type", body.contentType.toString());
    }
    final contentLength = body?.contentLength ?? -1;

    if (contentLength != -1) {
      requestBuilder.header("Content-Length", contentLength.toString());
      requestBuilder.removeHeader("Transfer-Encoding");
    } else {
      requestBuilder.header("Transfer-Encoding", "chunked");
      requestBuilder.removeHeader("Content-Length");
    }

    if (userRequest.headers["Host"] == null) {
      requestBuilder.header("Host", userRequest.url.host);
    }

    if (userRequest.headers["Connection"] == null) {
      requestBuilder.header("Connection", "Keep-Alive");
    }

    if (userRequest.headers["Accept - Encoding"] == null) {
      requestBuilder.header("Accept-Encoding", "gzip");
    }
    final cookies = cookieJar.loadForRequest(userRequest.url);
    if (cookies.isNotEmpty) {
      requestBuilder.header("Cookie", _cookieHeader(cookies));
    }

    if (userRequest.headers["User-Agent"] == null) {
      requestBuilder.header("User-Agent", USER_AGENT);
    }

    final networkRequest = requestBuilder.build();

    final networkResponse = await chain.proceed(networkRequest);

    cookieJar.receiveHeaders(networkRequest.url, networkResponse.headers);

    final response = networkResponse.newBuilder().request(userRequest).build();

    return response;
  }

  /// Returns a 'Cookie' HTTP request header with all cookies, like `a=b; c=d`.
  String _cookieHeader(List<Cookie> cookies) {
    return buildString((it) {
      cookies.forEachIndexed((index, cookie) {
        if (index > 0) it.write("; ");
        it.write("${cookie.name}=${cookie.value}");
      });
    });
  }
}

extension on CookieJar {
  void receiveHeaders(
    Uri url,
    Headers headers,
  ) {
    if (this == CookieJar.NO_COOKIES) return;

    final cookies = Cookie.parseAll(url, headers);
    if (cookies.isEmpty) return;

    return saveFromResponse(url, cookies);
  }
}
