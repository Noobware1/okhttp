// ignore_for_file: non_constant_identifier_names

import 'package:nice_dart/nice_dart.dart';
import 'package:okhttp/src/headers.dart';
import 'package:okhttp/src/request.dart';
import 'package:okhttp/src/response_body.dart';
part 'package:okhttp/src/common/response_common.dart';

class Response {
  Response._({
    required this.request,
    required this.statusCode,
    required this.headers,
    required this.body,
    required this.message,
  });

  /// Use the `request` of the [networkResponse] field to get the wire-level request that was
  /// transmitted. In the case of follow-ups and redirects, also look at the `request` of the
  /// [priorResponse] objects, which have its own [priorResponse].
  final Request request;

  /// Returns the HTTP protocol, such as [Protocol.HTTP_1_1] or [Protocol.HTTP_1_0].
  // final Protocol protocol

  /// Returns the HTTP status message.
  final String message;

  /// Returns the HTTP status code.
  final int statusCode;

  /// Returns the TLS handshake of the connection that carried this response, or null if the
  /// response was received without TLS.
  //  final Handshake ? handshake;

  /// Returns the HTTP headers.
  final Headers headers;

  /// Returns a non-null value if this response was passed to [Callback.onResponse] or returned
  /// from [Call.execute]. Response bodies must be [closed][ResponseBody] and may
  /// be consumed only once.
  ///
  /// This always returns null on responses returned from [cacheResponse], [networkResponse],
  /// and [priorResponse].
  final ResponseBody body;

  bool get isSuccessful => commonIsSuccessful;

  String? header(String name) => commonHeader(name);

  static ResponseBuilder Builder() => _CommonBuilder();

  ResponseBuilder newBuilder() => _CommonBuilder(this);
}

sealed class ResponseBuilder {
  late Request? _request;
  late int _code;
  late String? _message;
  late HeadersBuilder _headers;
  late ResponseBody _body;
  // late Protocol? _protocol;
  // late Handshake? _handshake;
  // late   _sentRequestAtMillis: Long = 0
  // late   _receivedResponseAtMillis: Long = 0
  // late   _exchange: Exchange? = null

  ResponseBuilder([Response? response]) {
    _request = response?.request;
    _code = response?.statusCode ?? -1;
    _message = response?.message;
    _headers = response?.headers.newBuilder() ?? Headers.Builder();
    _body = response?.body ?? ResponseBody.empty;
  }

  /// Sets the header named [name] to [value]. If this request already has any headers
  /// with that name, they are all replaced.
  ResponseBuilder header(String name, String value) =>
      commonHeader(name, value);

  /// Adds a header with [name] to [value]. Prefer this method for multiply-valued
  /// headers like "Set-Cookie".
  ResponseBuilder addHeader(String name, String value) =>
      commonAddHeader(name, value);

  /// Removes all headers named [name] on this builder.
  ResponseBuilder removeHeader(String name) => commonRemoveHeader(name);

  ResponseBuilder statusCode(int statusCode) => commonStatusCode(statusCode);

  /// Removes all headers on this builder and adds [headers].
  ResponseBuilder headers(Headers headers) => commonHeaders(headers);

  ResponseBuilder request(Request request) => commonRequest(request);

  ResponseBuilder body(ResponseBody body) => commonBody(body);

  ResponseBuilder message(String message) => commonMessage(message);

  Response build() => commonBuild();
}
