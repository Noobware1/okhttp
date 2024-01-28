
import 'package:okhttp/src/request.dart';
import 'package:okhttp/src/response.dart';

abstract class ClientAdapter {
  ClientAdapter();

  Future<Response> newCall(Request request);

  // ClientAdapter createAdapter();

  void close({bool force = false});
}
