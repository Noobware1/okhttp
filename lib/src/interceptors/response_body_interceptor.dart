import 'package:okhttp/src/interceptor.dart';
import 'package:okhttp/src/response.dart';
import 'package:okhttp/src/stream_response_body.dart';

class ResponseBodyInterceptor implements Interceptor {
  @override
  Future<Response> intercept(Chain chain) async {
    final response = await chain.proceed(chain.request);
    if (response.body is StreamResponseBody) {
      return response.newBuilder().body(await response.body.close()).build();
    }
    return response;
  }
}
