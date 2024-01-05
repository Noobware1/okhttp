import 'package:ok_http/src/request.dart';
import 'package:ok_http/src/response.dart';

abstract class Interceptor {
  Future<Response> intercept(Chain chain);
}

abstract class Chain {
  final Request request;
  Chain(this.request);
  Future<Response> proceed(Request request);
}

// class Connection {}
