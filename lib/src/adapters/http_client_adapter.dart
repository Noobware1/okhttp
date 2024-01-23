import 'dart:io';
import 'package:dartx/dartx.dart';
import 'package:okhttp/src/client_adapter.dart';
import 'package:okhttp/src/headers.dart';
import 'package:okhttp/src/okhttp_client.dart';
import 'package:okhttp/src/request.dart';
import 'package:okhttp/src/response.dart';
import 'package:okhttp/src/response_body/io_response_body.dart';

class HttpClientAdapter implements ClientAdapter {
  final bool _followRedirects;
  final int _maxRedirects;
  final bool _persistentConnection;
  final _inner = HttpClient();
  HttpClientAdapter({
    required bool followRedirects,
    required int maxRedirects,
    required bool persistentConnection,
  })  : _followRedirects = followRedirects,
        _maxRedirects = maxRedirects,
        _persistentConnection = persistentConnection;

  @override
  Future<Response> newCall(Request request) async {
    final httpClientRequest =
        await HttpClient().openUrl(request.method, request.url);

    httpClientRequest.followRedirects = _followRedirects;
    httpClientRequest.maxRedirects = _maxRedirects;
    httpClientRequest.persistentConnection = _persistentConnection;

    //sets headers
    request.headers.forEach((name, value) {
      httpClientRequest.headers.set(name, value);
    });

    if (request.body != null) {
      if (request.body!.contentType != null) {
        httpClientRequest.headers
            .set('Content-Type', request.body!.contentType.toString());
      }
      httpClientRequest.headers
          .set('Content-Length', request.body!.contentLength);
      request.body!.writeTo(httpClientRequest);
    }

    final httpResponse = await httpClientRequest.close();

    final headers = Headers.Builder().let((it) {
      httpResponse.headers.forEach((name, values) {
        it.add(name, values);
      });
      return it.build();
    });

    final response = Response.Builder()
        .body(IOStreamResponseBody(httpResponse, headers.get('Content-Type')))
        .request(request)
        .headers(headers)
        .statusCode(httpResponse.statusCode)
        .message(httpResponse.reasonPhrase)
        .build();

    return response;
  }

  @override
  void close({bool force = false}) {
    _inner.close(force: force);
  }
}
