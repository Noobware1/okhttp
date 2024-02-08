part of 'package:okhttp/src/response.dart';

extension on Response {
  bool get commonIsSuccessful => statusCode >= 200 && statusCode <= 299;

  String? commonHeader(String name) => headers[name];
}

class _CommonBuilder extends ResponseBuilder {
  _CommonBuilder([Response? response]) : super(response);
}

extension on ResponseBuilder {
  ResponseBuilder commonHeader(
    String name,
    String value,
  ) {
    return apply((it) {
      it._headers.set(name, value);
    });
  }

  /// Adds a header with [name] to [value]. Prefer this method for multiply-valued
  /// headers like "Set-Cookie".
  ResponseBuilder commonAddHeader(
    String name,
    String value,
  ) {
    return apply((it) {
      it._headers.add(name, value);
    });
  }

  /// Removes all headers named [name] on this builder.
  ResponseBuilder commonRemoveHeader(String name) {
    return apply((it) {
      it._headers.removeAll(name);
    });
  }

  ResponseBuilder commonStatusCode(int statusCode) {
    return apply((it) {
      it._code = statusCode;
    });
  }

  /// Removes all headers on this builder and adds [headers].
  ResponseBuilder commonHeaders(Headers headers) {
    return apply((it) {
      it._headers = headers.newBuilder();
    });
  }

  ResponseBuilder commonRequest(Request request) {
    return apply((it) {
      it._request = request;
    });
  }

  ResponseBuilder commonBody(ResponseBody body) {
    return apply((it) {
      it._body = body;
    });
  }

  ResponseBuilder commonMessage(String message) {
    return apply((it) {
      it._message = message;
    });
  }

  Response commonBuild() {
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
