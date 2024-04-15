// ignore_for_file: prefer_initializing_formals

import 'dart:async';

import 'package:okhttp/src/exchange/exchnage_codec.dart';
import 'package:okhttp/src/exchange/http/http_carrier.dart';
import 'package:okhttp/src/headers.dart';
import 'package:okhttp/src/request.dart';
import 'package:okhttp/src/response.dart';

class HttpExchangeCodec implements ExchangeCodec {
  HttpExchangeCodec({
    required HttpCarrier carrier,
  }) : carrier = carrier;

  @override
  void cancel() {
    carrier.cancel();
  }

  @override
  final Carrier carrier;

  @override
  Stream<List<int>> createRequestBody(Request request, int contentLength) {
    final sink = StreamController<List<int>>();
    request.body?.writeTo(sink);
    return sink.stream;
  }

  @override
  void finishRequest() {
    // TODO: implement finishRequest
  }

  @override
  void flushRequest() {
    // TODO: implement flushRequest
  }

  @override
  void openResponseBodySource(Response response) {
    // TODO: implement openResponseBodySource
  }

  @override
  ResponseBuilder readResponseHeaders(bool expectContinue) {
    // TODO: implement readResponseHeaders
    throw UnimplementedError();
  }

  @override
  void reportedContentLength(Response response) {
    // TODO: implement reportedContentLength
  }

  @override
  Headers trailers() {
    // TODO: implement trailers
    throw UnimplementedError();
  }

  @override
  void writeRequestHeaders(Request request) {
    // TODO: implement writeRequestHeaders
  }
}
