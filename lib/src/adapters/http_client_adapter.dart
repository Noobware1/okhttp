import 'dart:io';
import 'package:dartx/dartx.dart';
import 'package:okhttp/src/byte_stream.dart';
import 'package:okhttp/src/headers.dart';
import 'package:okhttp/src/request.dart';
import 'package:okhttp/src/response.dart';
import 'package:okhttp/src/stream_response_body.dart';

class HttpClientAdapter implements ClientAdapter {
  final _inner = HttpClient();

  @override
  ClientAdapter createAdapter() {
    return HttpClientAdapter();
  }

  @override
  Future<Response> newCall(Request request) async {
    final httpClientRequest =
        await HttpClient().openUrl(request.method, request.url);

    //sets headers
    request.headers.forEach((name, value) {
      httpClientRequest.headers.add(name, value);
    });

    if (request.body.isNotNull) {
      if (request.body!.contentType.isNotNull) {
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
        .body(StreamResponseBody(
            ByteStream(httpResponse), headers.get('Content-Type')))
        .request(request)
        .headers(headers)
        .statusCode(httpResponse.statusCode)
        .message(httpResponse.reasonPhrase)
        .build();

    return response;
  }

  @override
  void close({bool force = false}) {
    // _inner.close(force: force);
  }
}

abstract class ClientAdapter {
  Future<Response> newCall(Request request);

  ClientAdapter createAdapter();

  void close({bool force = false});
}
