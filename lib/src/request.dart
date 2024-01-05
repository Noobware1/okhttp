import 'package:ok_http/src/byte_stream.dart';
import 'package:ok_http/src/cookie.dart';
import 'package:ok_http/src/headers.dart';
import 'package:ok_http/src/request_body.dart';

class Request {
  Request({
    required String url,
    this.method = 'GET',
  }) : _url = Uri.parse(url);

  Request.uri(
    Uri uri, {
    this.method = 'GET',
  }) : _url = uri;

  Uri _url;

  void addQueryParameter(String key, String value) {
    _url = _url.addQueryParameter(key, value);
  }

  void addQueryParameterAll(Map<String, String> parameters) {
    parameters.forEach((key, value) {
      _url = _url.addQueryParameter(key, value);
    });
  }

  Uri get url => _url;

  final String method;

  final Headers headers = Headers();

  RequestBody? body;

  /// Cookies to present to the server (in the 'cookie' header).
  List<Cookie> get cookies => [];

  Request build() {
    return _Request(this);
  }

  Request resetBuild() {
    if (this is! _Request) {
      throw Exception('Request is not built yet.');
    }
    return (this as _Request).resetBuild();
  }

  @override
  String toString() {
    return 'Request{url: $url, method: $method, headers: $headers, body: $body}';
  }
}

class _Request extends ByteStream implements Request {
  _Request(this._request)
      : super(ByteStream.fromBytes(_request.body?.toBytes() ?? []));

  final Request _request;

  @override
  late final Uri _url = _request._url;

  @override
  late final RequestBody? body = _request.body;

  @override
  void addQueryParameter(String key, String value) {
    throw _RebuildRequestException();
  }

  @override
  void addQueryParameterAll(Map<String, String> parameters) {
    throw _RebuildRequestException();
  }

  Request resetBuild() {
    return _request;
  }

  @override
  Request build() {
    throw _RebuildRequestException();
  }

  @override
  late final List<Cookie> cookies = _request.cookies;

  @override
  late final Headers headers = _request.headers;

  @override
  late final String method = _request.method;

  @override
  late final Uri url = _request.url;

  @override
  set _url(Uri url) {
    throw _RebuildRequestException();
  }

  @override
  set body(RequestBody? body) {
    throw _RebuildRequestException();
  }

  @override
  set contentLength(int contentLength) {
    throw _RebuildRequestException();
  }
}

class _RebuildRequestException implements Exception {
  const _RebuildRequestException();

  @override
  String toString() {
    return 'RebuildRequestException: A built request is immutable and cannot be rebuilt.';
  }
}

extension on Uri {
  Uri addQueryParameter(String key, String value) {
    var queryParameters = Map<String, String>.from(this.queryParameters);
    queryParameters[key] = value;

    return replace(queryParameters: queryParameters);
  }
}
