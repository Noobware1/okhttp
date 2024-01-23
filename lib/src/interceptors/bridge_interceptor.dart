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
  BridgeInterceptor();

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

    if (userRequest.headers["User-Agent"] == null) {
      requestBuilder.header("User-Agent", USER_AGENT);
    }

    final networkRequest = requestBuilder.build();
    final networkResponse = await chain.proceed(networkRequest);
    final response = networkResponse.newBuilder().request(userRequest).build();

    return response;
  }
}
