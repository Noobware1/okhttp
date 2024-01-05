import 'package:ok_http/src/call.dart';
import 'package:ok_http/src/connection/real_chain.dart';
import 'package:ok_http/src/interceptor.dart';
import 'package:ok_http/src/interceptors/bridge_interceptor.dart';
import 'package:ok_http/src/interceptors/connect_interceptor.dart';
import 'package:ok_http/src/ok_http_client.dart';
import 'package:ok_http/src/request.dart';
import 'package:ok_http/src/response.dart';
import 'package:ok_http/src/_client.dart';

class RealCall implements Call {
  RealCall({
    required this.client,
    required this.originalRequest,
    required this.realClient,
  });

  final RealClient realClient;

  final OkHttpClient client;

  // RealChain copyWith(int index) {
  //   return RealChain(index: index, request: request, client: client);
  // }

  Future<Response> getResponseWithInterceptorChain() async {
    final interceptors = <Interceptor>[];

    interceptors.addAll(client.interceptors);
    interceptors.add(BridgeInterceptor());
    interceptors.addAll(client.networkInterceptors);
    interceptors.add(ConnectInterceptor());

    final chain = RealInterceptorChain(
      index: 0,
      request: originalRequest,
      realClient: realClient,
      interceptors: interceptors,
    );

    try {
      return await chain.proceed(originalRequest);
    } catch (e) {
      print(e);
      throw Exception("Error");
    } finally {
      realClient.close();
    }
  }

  @override
  void cancel() {
    _isCanceled = true;
    realClient.close();
  }

  @override
  Call clone() {
    return RealCall(
      client: client,
      originalRequest: originalRequest,
      realClient: realClient,
    );
  }

  @override
  Future<Response> execute() {
    _isExecuted = true;
    return getResponseWithInterceptorChain();
  }

  @override
  bool get isCanceled => _isCanceled;

  bool _isCanceled = false;

  @override
  bool get isExecuted => _isExecuted;

  bool _isExecuted = false;

  @override
  Call newCall(Request request) {
    return RealCall(
      client: client,
      originalRequest: request,
      realClient: realClient,
    );
  }

  @override
  Duration get timeout => throw UnimplementedError();

  @override
  final Request originalRequest;
}
