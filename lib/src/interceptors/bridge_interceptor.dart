import 'package:ok_http/src/connection/real_chain.dart';
import 'package:ok_http/src/constants/useragent.dart';
import 'package:ok_http/src/interceptor.dart';
import 'package:ok_http/src/interceptors/retry_followup_interceptor.dart';
import 'package:ok_http/src/response.dart';

///
/// Bridges from application code to network code. First it builds a network request from a user
/// request. Then it proceeds to call the network. Finally it builds a user response from the network
/// response.
///
class BridgeInterceptor extends Interceptor {
  BridgeInterceptor();

  @override
  Future<Response> intercept(Chain chain) async {
    chain as RealInterceptorChain;

    final userRequest = chain.request;

    final body = userRequest.body;
    if (body != null) {
      userRequest.headers.add("Content-Type", body.contentType.toString());
    }
    final contentLength = body?.contentLength ?? -1;

    if (contentLength != -1) {
      userRequest.headers.add("Content-Length", contentLength.toString());
      userRequest.headers.remove("Transfer-Encoding");
    } else {
      userRequest.headers.add("Transfer-Encoding", "chunked");
      userRequest.headers.remove("Content-Length");
    }

    // if (userRequest.headers["Host"] == null) {
    //   userRequest.headers.add("Host", userRequest.url.host);
    // }

    if (userRequest.headers["Connection"] == null) {
      userRequest.headers.add("Connection", "Keep-Alive");
    }

    // If we add an "Accept-Encoding: gzip" header field we're responsible for also decompressing
    // the transfer stream.
    if (userRequest.headers["Accept-Encoding"] == null) {
      userRequest.headers.add("Accept-Encoding", "gzip");
    }
//     val cookies = cookieJar.loadForRequest(userRequest.url)
//     if (cookies.isNotEmpty()) {
//       requestBuilder.header("Cookie", cookieHeader(cookies))
//     }
    if (userRequest.headers["User-Agent"] == null) {
      userRequest.headers.add("User-Agent", USER_AGENT);
    }

    final networkRequest = userRequest.build();
    final networkResponse = await chain.proceed(networkRequest);
    final responseBuilder = networkResponse.Builder();
    responseBuilder.request = networkRequest;

    return responseBuilder.build();
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