import 'package:okhttp/src/adapters/http_client_adapter.dart';
import 'package:okhttp/src/interceptor.dart';
import 'package:okhttp/src/okhttp_client.dart';
import 'package:okhttp/src/request.dart';
import 'package:okhttp/src/response.dart';
import 'package:okhttp/src/_client.dart';

class RealInterceptorChain extends Chain {
  final int index;
  final List<Interceptor> interceptors;
  final ClientAdapter adapter;

  RealInterceptorChain({
    required this.index,
    required Request request,
    required this.adapter,
    required this.interceptors,
  }) : super(request);

  RealInterceptorChain copy({
    required int index,
    ClientAdapter? adapter,
    Request? request,
  }) {
    return RealInterceptorChain(
      index: index,
      request: request ?? this.request,
      adapter: adapter ?? this.adapter,
      interceptors: interceptors,
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
