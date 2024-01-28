import 'package:okhttp/src/request.dart';
import 'package:okhttp/src/response.dart';

abstract class Interceptor {
  factory Interceptor.make(Future<Response> Function(Chain chain) intercept) {
    return _Interceptor(intercept);
  }

  Interceptor();

  Future<Response> intercept(Chain chain);
}

class _Interceptor implements Interceptor {
  final Future<Response> Function(Chain chain) _intercept;

  _Interceptor(this._intercept);

  @override
  Future<Response> intercept(Chain chain) {
    return _intercept(chain);
  }
}

abstract class Chain {
  final Request request;
  Chain(this.request);
  Future<Response> proceed(Request request);
}
