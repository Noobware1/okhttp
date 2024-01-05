import 'package:ok_http/src/connection/real_chain.dart';
import 'package:ok_http/src/interceptor.dart';
import 'package:ok_http/src/response.dart';

class ConnectInterceptor extends Interceptor {
  @override
  Future<Response> intercept(Chain chain) {
    final realchain = chain as RealInterceptorChain;
    final request = chain.request;

    return realchain.realClient.newCall(request);
  }
}
