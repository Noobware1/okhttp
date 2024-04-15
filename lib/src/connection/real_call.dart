import 'package:async/async.dart';
import 'package:okhttp/interceptor.dart';
import 'package:okhttp/src/call.dart';
import 'package:okhttp/src/connection/real_chain.dart';
import 'package:okhttp/src/expections/okhttp_exception.dart';
import 'package:okhttp/src/interceptor.dart';
import 'package:okhttp/src/interceptors/bridge_interceptor.dart';
import 'package:okhttp/src/interceptors/connect_interceptor.dart';
import 'package:okhttp/src/interceptors/response_body_interceptor.dart';
import 'package:okhttp/src/okhttp_client.dart';
import 'package:okhttp/src/request.dart';
import 'package:okhttp/src/response.dart';

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
    interceptors.add(RetryAndFollowUpInterceptor(client));
    interceptors.add(BridgeInterceptor(client.cookieJar));
    interceptors.addAll(client.networkInterceptors);
    interceptors.add(ConnectInterceptor());

    final chain = RealInterceptorChain(
      index: 0,
      request: originalRequest,
      adapter: client.adapter,
      interceptors: interceptors,
      call: this,
    );

    try {
      return await chain.proceed(originalRequest);
    } catch (e, s) {
      throw OkHttpException(
        e.toString(),
        error: e is Exception ? e : null,
        stackTrace: s,
        reasonPhrase: null,
        statusCode: null,
        uri: null,
      );
    }
  }

  bool retryAfterFailure() {
    return true;
  }

  @override
  void cancel() {
    _isCanceled = true;
    _cancelableCall?.cancel();
  }

  @override
  Call clone() {
    return RealCall(
      client: client,
      originalRequest: originalRequest,
    );
  }

  CancelableOperation<Response>? _cancelableCall;

  @override
  Future<Response> execute() async {
    _isExecuted = true;
    _cancelableCall = CancelableOperation<Response>.fromFuture(
      getResponseWithInterceptorChain(),
    );

    return await _cancelableCall?.valueOrCancellation() ??
        (throw OkHttpException(
          'Canceled',
          error: null,
          stackTrace: null,
          reasonPhrase: null,
          statusCode: null,
          uri: null,
        ));
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
