// ignore_for_file: non_constant_identifier_names

import 'package:dartx/dartx.dart';
import 'package:okhttp/src/common/http_method.dart';
import 'package:okhttp/src/headers.dart';
import 'package:okhttp/src/request_body.dart';

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

  static RequestBuilder Builder() => _RequestBuilder();

  RequestBuilder newBuilder() => _RequestBuilder(this);

  @override
  String toString() {
    return 'Request(url: $url, method: $method, headers: ${headers.toList().mapList((e) => '${e.first}: ${e.second}')}, body: $body)';
  }
}

final class _RequestBuilder extends RequestBuilder {
  _RequestBuilder([Request? request]) : super(request);
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

  RequestBuilder url(dynamic url) {
    return apply((it) {
      if (url is Uri) {
        it._url = url;
      } else if (url is String) {
        it._url = Uri.parse(url);
      } else {
        throw ArgumentError.value(url, 'url', 'must be a Uri or a String');
      }
    });
  }

  /// Sets the header named [name] to [value]. If this request already has any headers
  /// with that name, they are all replaced.
  RequestBuilder header(
    String name,
    String value,
  ) {
    return apply((it) {
      it._headers.set(name, value);
    });
  }

  /// Adds a header with [name] and [value]. Prefer this method for multiply-valued
  /// headers like "Cookie".
  ///
  /// Note that for some headers including `Content-Length` and `Content-Encoding`,
  /// OkHttp may replace [value] with a header derived from the request body.
  RequestBuilder addHeader(
    String name,
    String value,
  ) {
    return apply((it) {
      it._headers.add(name, value);
    });
  }

  /// Removes all headers named [name] on this builder.
  RequestBuilder removeHeader(String name) {
    return apply((it) {
      it._headers.removeAll(name);
    });
  }

  /// Removes all headers on this builder and adds [headers].
  RequestBuilder headers(Headers headers) {
    return apply((it) {
      it._headers = Headers.Builder();
      it._headers.addAll(headers);
    });
  }

  RequestBuilder get() => method("GET", null);

  RequestBuilder head() => method("HEAD", null);

  RequestBuilder post(RequestBody? body) => method("POST", body);

  RequestBuilder delete(RequestBody? body) => method("DELETE", body);

  RequestBuilder put(RequestBody? body) => method("PUT", body);

  RequestBuilder patch(RequestBody? body) => method("PATCH", body);

  RequestBuilder method(
    String method,
    RequestBody? body,
  ) {
    return apply((it) {
      assert(method.isNotEmpty, "method.isEmpty == true");
      if (body == null && HttpMethod.requiresRequestBody(method)) {
        body = RequestBody.empty;
      } else if (body != null) {
        assert(HttpMethod.permitsRequestBody(method),
            "method $method must not have a request body.");
      }
      it._method = method;
      it._body = body;
    });
  }

  RequestBuilder addQueryParameter(String key, String value) {
    return apply((it) {
      it._url = it._url?.addQueryParameter(key, value);
    });
  }

  RequestBuilder addQueryParameterAll(Map<String, String> parameters) {
    return apply((it) {
      if (it._url != null) {
        parameters.forEach((key, value) {
          it._url = it._url!.addQueryParameter(key, value);
        });
      }
    });
  }

  Request build() {
    assert(_url != null, {'url == null'});
    return Request._(this);
  }
}

extension on Uri {
  Uri addQueryParameter(String key, String value) {
    var queryParameters = Map<String, String>.from(this.queryParameters);
    queryParameters[key] = value;

    return replace(queryParameters: queryParameters);
  }
}
