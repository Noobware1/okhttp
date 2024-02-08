import 'package:okhttp/src/connection/real_chain.dart';
import 'package:okhttp/src/interceptor.dart';
import 'package:okhttp/src/response.dart';

class ConnectInterceptor implements Interceptor {
  @override
  Future<Response> intercept(Chain chain) async {
    final realchain = chain as RealInterceptorChain;
    final request = chain.request;
    return realchain.adapter.newCall(chain.call.client, request);
  }
}
