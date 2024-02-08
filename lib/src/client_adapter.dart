import 'package:okhttp/src/okhttp_client.dart';
import 'package:okhttp/src/request.dart';
import 'package:okhttp/src/response.dart';

abstract class ClientAdapter {
  ClientAdapter();

  Future<Response> newCall(OkHttpClient client, Request request);

  // ClientAdapter createAdapter();

  void close({bool force = false});
}
