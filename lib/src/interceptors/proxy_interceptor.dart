import 'package:okhttp/src/adapters/http_client_adapter.dart';
import 'package:okhttp/src/connection/real_chain.dart';
import 'package:okhttp/src/interceptor.dart';
import 'package:okhttp/src/response.dart';

class ProxyInterceptor implements Interceptor {
  @override
  Future<Response> intercept(Chain chain) {
    chain as RealInterceptorChain;
    final realCall = chain.call;
    final adapter = realCall.client.adapter;
    if (adapter is HttpClientAdapter) {
      final proxy = realCall.client.proxy;
      adapter.addProxy(proxy);
    }

    return chain.proceed(chain.request);
  }
}
