import 'package:ok_http/src/interceptor.dart';
import 'package:ok_http/src/request.dart';
import 'package:ok_http/src/response.dart';
import 'package:ok_http/src/_client.dart';

class RealInterceptorChain extends Chain {
  final int index;
  final List<Interceptor> interceptors;
  final Client realClient;

  RealInterceptorChain({
    required this.index,
    required Request request,
    required this.realClient,
    required this.interceptors,
  }) : super(request);

  RealInterceptorChain copy({
    required int index,
    Client? realClient,
    Request? request,
  }) {
    return RealInterceptorChain(
      index: index,
      request: request ?? this.request,
      realClient: realClient ?? this.realClient,
      interceptors: interceptors,
    );
  }

  @override
  Future<Response> proceed(Request request) {
    assert(index < interceptors.length);

    final next = copy(
      index: index + 1,
      request: request,
      realClient: realClient,
    );

    final interceptor = interceptors[index];

    final response = interceptor.intercept(next);

    return response;
  }
}
