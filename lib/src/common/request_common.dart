part of 'package:okhttp/src/request.dart';

final class _CommonRequestBuilder extends RequestBuilder {
  _CommonRequestBuilder([Request? request]) : super(request);
}

extension _RequestBuilerCommon on RequestBuilder {
  RequestBuilder commonUrl(dynamic url) {
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
  RequestBuilder commonHeader(
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
  RequestBuilder commonAddHeader(
    String name,
    String value,
  ) {
    return apply((it) {
      it._headers.add(name, value);
    });
  }

  /// Removes all headers named [name] on this builder.
  RequestBuilder commonRemoveHeader(String name) {
    return apply((it) {
      it._headers.removeAll(name);
    });
  }

  /// Removes all headers on this builder and adds [headers].
  RequestBuilder commonHeaders(Headers headers) {
    return apply((it) {
      it._headers = Headers.Builder();
      it._headers.addAll(headers);
    });
  }

  RequestBuilder commonGet() => method("GET", null);

  RequestBuilder commonHead() => method("HEAD", null);

  RequestBuilder commonPost(RequestBody? body) => method("POST", body);

  RequestBuilder commonDelete(RequestBody? body) => method("DELETE", body);

  RequestBuilder commonPut(RequestBody? body) => method("PUT", body);

  RequestBuilder commonPatch(RequestBody? body) => method("PATCH", body);

  RequestBuilder commonMethod(
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

  RequestBuilder commonAddQueryParameter(String key, String value) {
    return apply((it) {
      it._url = it._url?.addQueryParameter(key, value);
    });
  }

  RequestBuilder commonAddQueryParameterAll(Map<String, String> parameters) {
    return apply((it) {
      if (it._url != null) {
        parameters.forEach((key, value) {
          it._url = it._url!.addQueryParameter(key, value);
        });
      }
    });
  }

  Request commonBuild() {
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
