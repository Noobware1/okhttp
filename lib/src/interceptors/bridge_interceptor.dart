import 'package:okhttp/src/connection/real_chain.dart';
import 'package:okhttp/src/constants/useragent.dart';
import 'package:okhttp/src/interceptor.dart';
import 'package:okhttp/src/interceptors/retry_followup_interceptor.dart';
import 'package:okhttp/src/response.dart';

///
/// Bridges from application code to network code. First it builds a network request from a user
/// request. Then it proceeds to call the network. Finally it builds a user response from the network
/// response.
///
class BridgeInterceptor implements Interceptor {
  BridgeInterceptor();

  @override
  Future<Response> intercept(Chain chain) async {
    chain as RealInterceptorChain;

    final userRequest = chain.request;
    final requestBuilder = userRequest.newBuilder();
    final body = userRequest.body;
    if (body != null) {
      requestBuilder.addHeader("Content-Type", body.contentType.toString());
    }
    final contentLength = body?.contentLength ?? -1;

    if (contentLength != -1) {
      requestBuilder.addHeader("Content-Length", contentLength.toString());
      requestBuilder.removeHeader("Transfer-Encoding");
    } else {
      requestBuilder.addHeader("Transfer-Encoding", "chunked");
      requestBuilder.removeHeader("Content-Length");
    }

    if (userRequest.headers["Host"] == null) {
      requestBuilder.addHeader("Host", userRequest.url.host);
    }

    if (userRequest.headers["Connection"] == null) {
      requestBuilder.addHeader("Connection", "Keep-Alive");
    }

    // If we add an "Accept-Encoding: gzip" header field we're responsible for also decompressing
    // the transfer stream.
    if (userRequest.headers["Accept - Encoding"] == null) {
      requestBuilder.addHeader("Accept-Encoding", "gzip");
    }
//     val cookies = cookieJar.loadForRequest(userRequest.url)
//     if (cookies.isNotEmpty()) {
//       requestBuilder.header("Cookie", cookieHeader(cookies))
//     }
    if (userRequest.headers["User-Agent"] == null) {
      requestBuilder.addHeader("User-Agent", USER_AGENT);
    }

    final networkRequest = requestBuilder.build();
    final networkResponse = await chain.proceed(networkRequest);
    final response = networkResponse.newBuilder().request(userRequest).build();

    return response;
  }
}



//   /** Returns a 'Cookie' HTTP request header with all cookies, like `a=b; c=d`. */
//   private fun cookieHeader(cookies: List<Cookie>): String = buildString {
//     cookies.forEachIndexed { index, cookie ->
//       if (index > 0) append("; ")
//       append(cookie.name).append('=').append(cookie.value)
//     }
//   }
// }