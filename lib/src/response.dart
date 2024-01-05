import 'dart:convert';
import 'dart:io' as io;

import 'package:ok_http/src/cookie.dart';
import 'package:ok_http/src/headers.dart';
import 'package:ok_http/src/request.dart';
import 'package:ok_http/src/utils/utils.dart';

class Response {
  final int statusCode;
  final List<int> bodyBytes;
  final int contentLength;
  final Headers headers;
  final bool isRedirect;
  final bool persistentConnection;
  final String reasonPhrase;
  final Request request;
  final io.X509Certificate? certificate;
  final io.HttpConnectionInfo? connectionInfo;
  final List<Cookie> cookies;

  Encoding get encoding => encodingForHeaders(headers);

  String get text => encoding.decode(bodyBytes);

  Response({
    required this.request,
    required this.statusCode,
    required this.bodyBytes,
    required this.contentLength,
    required this.headers,
    required this.isRedirect,
    required this.persistentConnection,
    required this.reasonPhrase,
    required this.cookies,
    this.certificate,
    this.connectionInfo,
  });

  ResponseBuilder Builder() {
    return _ResponseBuilder(this);
  }
}

sealed class ResponseBuilder {
  ResponseBuilder(this._response);

  final Response _response;

  late int statusCode = _response.statusCode;
  late List<int> bodyBytes = _response.bodyBytes;
  late Headers headers = _response.headers;
  late bool isRedirect = _response.isRedirect;
  late bool persistentConnection = _response.persistentConnection;
  late String reasonPhrase = _response.reasonPhrase;
  late Request request = _response.request;
  late io.X509Certificate? certificate = _response.certificate;
  late io.HttpConnectionInfo? connectionInfo = _response.connectionInfo;
  late List<Cookie> cookies = _response.cookies;
  late int contentLength = _response.contentLength;

  Response build() {
    return Response(
      statusCode: statusCode,
      bodyBytes: bodyBytes,
      contentLength: contentLength,
      headers: headers,
      isRedirect: isRedirect,
      persistentConnection: persistentConnection,
      reasonPhrase: reasonPhrase,
      request: request,
      certificate: certificate,
      connectionInfo: connectionInfo,
      cookies: cookies,
    );
  }
}

class _ResponseBuilder extends ResponseBuilder {
  _ResponseBuilder(super.response);
}
