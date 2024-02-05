// ignore_for_file: non_constant_identifier_names

import 'package:nice_dart/nice_dart.dart';
import 'package:okhttp/src/headers.dart';
import 'package:okhttp/src/request.dart';
import 'package:okhttp/src/response_body.dart';

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

  String? header(String name) => headers.get(name);

  static ResponseBuilder Builder() => _ResponseBuilder();

  ResponseBuilder newBuilder() => _ResponseBuilder(this);
}

class _ResponseBuilder extends ResponseBuilder {
  _ResponseBuilder([Response? response]) : super(response);
}

sealed class ResponseBuilder {
  late Request? _request;
  // late Protocol? _protocol;
  late int _code;
  late String? _message;
  //  late Handshake? _handshake;
  late HeadersBuilder _headers;
  late ResponseBody _body;
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
  ResponseBuilder header(
    String name,
    String value,
  ) {
    return apply((it) {
      it._headers.set(name, value);
    });
  }

  /// Adds a header with [name] to [value]. Prefer this method for multiply-valued
  /// headers like "Set-Cookie".
  ResponseBuilder addHeader(
    String name,
    String value,
  ) {
    return apply((it) {
      it._headers.add(name, value);
    });
  }

  /// Removes all headers named [name] on this builder.
  ResponseBuilder removeHeader(String name) {
    return apply((it) {
      it._headers.removeAll(name);
    });
  }

  ResponseBuilder statusCode(int statusCode) {
    return apply((it) {
      it._code = statusCode;
    });
  }

  /// Removes all headers on this builder and adds [headers].
  ResponseBuilder headers(Headers headers) {
    return apply((it) {
      it._headers = headers.newBuilder();
    });
  }

  ResponseBuilder request(Request request) {
    return apply((it) {
      it._request = request;
    });
  }

  ResponseBuilder body(ResponseBody body) {
    return apply((it) {
      it._body = body;
    });
  }

  ResponseBuilder message(String message) {
    return apply((it) {
      it._message = message;
    });
  }

  Response build() {
    assert(_request != null, "request == null");
    assert(_code >= 0, "code < 0: $_code");

    return Response._(
      request: _request!,
      statusCode: _code,
      headers: _headers.build(),
      body: _body,
      message: _message ?? '',
    );
  }
}
