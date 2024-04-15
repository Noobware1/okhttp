import 'package:okhttp/src/connection/real_chain.dart';
import 'package:okhttp/src/interceptor.dart';
import 'package:okhttp/src/okhttp_client.dart';
import 'package:okhttp/src/response.dart';

class RetryAndFollowUpInterceptor implements Interceptor {
  final OkHttpClient _client;
  RetryAndFollowUpInterceptor(this._client);

  @override
  Future<Response> intercept(Chain chain) async {
    final realChain = chain as RealInterceptorChain;
    final realCall = realChain.call;
    var request = realChain.request;

    var i = 0;
    for (;;) {
      if (realCall.isCanceled) {
        throw Exception('Canceled');
      }
      Response? response;
      try {
        response = await realChain.proceed(request);
      } catch (_) {
        if (i == _client.maxRetries) rethrow;
      }

      if (response != null) {
        if (i == _client.maxRetries) return response;
      }

      i++;
      print('Retrying request for the $i time');
    }
  }
}
