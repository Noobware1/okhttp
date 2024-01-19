import 'package:okhttp/src/call.dart';
import 'package:okhttp/src/connection/real_chain.dart';
import 'package:okhttp/src/interceptor.dart';
import 'package:okhttp/src/interceptors/bridge_interceptor.dart';
import 'package:okhttp/src/interceptors/connect_interceptor.dart';
import 'package:okhttp/src/interceptors/response_body_interceptor.dart';
import 'package:okhttp/src/okhttp_client.dart';
import 'package:okhttp/src/request.dart';
import 'package:okhttp/src/response.dart';
import 'package:okhttp/src/_client.dart';

class RealCall implements Call {
  RealCall({
    required this.client,
    required this.originalRequest,
  });

  final OkHttpClient client;

  Future<Response> getResponseWithInterceptorChain() async {
    final interceptors = <Interceptor>[];

    interceptors.addAll(client.interceptors);
    interceptors.add(ResponseBodyInterceptor());
    interceptors.add(BridgeInterceptor());
    interceptors.addAll(client.networkInterceptors);
    interceptors.add(ConnectInterceptor());

    final chain = RealInterceptorChain(
      index: 0,
      request: originalRequest,
      adapter: client.adapter,
      interceptors: interceptors,
    );

    try {
      return await chain.proceed(originalRequest);
    } catch (e) {
      print(e);
      throw Exception("Error");
    } finally {
      client.adapter.close();
    }
  }

  @override
  void cancel() {
    _isCanceled = true;
    client.adapter.close();
  }

  @override
  Call clone() {
    return RealCall(
      client: client,
      originalRequest: originalRequest,
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
    );
  }

  @override
  Duration get timeout => throw UnimplementedError();

  @override
  final Request originalRequest;
}
