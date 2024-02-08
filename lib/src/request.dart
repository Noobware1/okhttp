// ignore_for_file: non_constant_identifier_names

import 'package:nice_dart/nice_dart.dart';
import 'package:okhttp/src/common/http_method.dart';
import 'package:okhttp/src/headers.dart';
import 'package:okhttp/src/request_body.dart';
part 'package:okhttp/src/common/request_common.dart';

class Request {
  Request._(RequestBuilder builder)
      : url = builder._url!,
        method = builder._method,
        headers = builder._headers.build(),
        body = builder._body;

  final Uri url;
  final String method;
  final Headers headers;
  final RequestBody? body;

  static RequestBuilder Builder() => _CommonRequestBuilder();

  RequestBuilder newBuilder() => _CommonRequestBuilder(this);

  @override
  String toString() {
    return 'Request(url: $url, method: $method, headers: ${headers.toString(true)}, body: $body)';
  }
}

sealed class RequestBuilder {
  Uri? _url;
  String _method;
  HeadersBuilder _headers;
  RequestBody? _body;

  RequestBuilder([Request? request])
      : _url = request?.url,
        _method = request?.method ?? 'GET',
        _headers = request?.headers.newBuilder() ?? Headers.Builder(),
        _body = request?.body;

  RequestBuilder url(dynamic url) => commonUrl(url);

  /// Sets the header named [name] to [value]. If this request already has any headers
  /// with that name, they are all replaced.
  RequestBuilder header(String name, String value) => commonHeader(name, value);

  /// Adds a header with [name] and [value]. Prefer this method for multiply-valued
  /// headers like "Cookie".
  ///
  /// Note that for some headers including `Content-Length` and `Content-Encoding`,
  /// OkHttp may replace [value] with a header derived from the request body.
  RequestBuilder addHeader(String name, String value) =>
      commonAddHeader(name, value);

  /// Removes all headers named [name] on this builder.
  RequestBuilder removeHeader(String name) => commonRemoveHeader(name);

  /// Removes all headers on this builder and adds [headers].
  RequestBuilder headers(Headers headers) => commonHeaders(headers);

  RequestBuilder get() => commonGet();

  RequestBuilder head() => commonHead();

  RequestBuilder post(RequestBody? body) => commonPost(body);

  RequestBuilder delete(RequestBody? body) => commonDelete(body);

  RequestBuilder put(RequestBody? body) => commonPut(body);

  RequestBuilder patch(RequestBody? body) => commonPatch(body);

  RequestBuilder method(String method, RequestBody? body) =>
      commonMethod(method, body);

  RequestBuilder addQueryParameter(String key, String value) =>
      commonAddQueryParameter(key, value);

  RequestBuilder addQueryParameterAll(Map<String, String> parameters) =>
      commonAddQueryParameterAll(parameters);

  Request build() => commonBuild();
}
