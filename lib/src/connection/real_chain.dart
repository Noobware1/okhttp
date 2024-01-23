import 'package:okhttp/src/client_adapter.dart';
import 'package:okhttp/src/connection/real_call.dart';
import 'package:okhttp/src/interceptor.dart';
import 'package:okhttp/src/request.dart';
import 'package:okhttp/src/response.dart';

class RealInterceptorChain extends Chain {
  final int index;
  final RealCall call;
  final List<Interceptor> interceptors;
  final ClientAdapter adapter;

  RealInterceptorChain({
    required this.index,
    required Request request,
    required this.adapter,
    required this.interceptors,
    required this.call,
  }) : super(request);

  RealInterceptorChain copy({
    required int index,
    ClientAdapter? adapter,
    Request? request,
    RealCall? call,
  }) {
    return RealInterceptorChain(
      index: index,
      request: request ?? this.request,
      adapter: adapter ?? this.adapter,
      interceptors: interceptors,
      call: call ?? this.call,
    );
  }

  @override
  Future<Response> proceed(Request request) {
    assert(index < interceptors.length);

    final next = copy(
      index: index + 1,
      request: request,
      adapter: adapter,
    );

    final interceptor = interceptors[index];

    final response = interceptor.intercept(next);

    return response;
  }
}
