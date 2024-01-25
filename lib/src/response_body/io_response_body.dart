import 'dart:io';

import 'package:okhttp/src/response_body.dart';
import 'package:okhttp/src/response_body/real_response_body.dart';
import 'package:okhttp/src/response_body/stream_response_body.dart';

class IOStreamResponseBody extends StreamResponseBody {
  IOStreamResponseBody(HttpClientResponse response, String? contentTypeString)
      : detachSocketCallback = response.detachSocket,
        super(response, contentTypeString);

  final Future<Socket> Function() detachSocketCallback;
  @override
  Future<ResponseBody> close() async {
    final response = RealResponseBody(await toBytes(), contentType);
    (await detachSocketCallback()).destroy();
    return response;
  }
}
