import 'dart:io';

import 'package:okhttp/src/connection/real_call.dart';
import 'package:okhttp/src/exchange/exchnage_codec.dart';
import 'package:okhttp/src/expections/okhttp_exception.dart';
import 'package:okhttp/src/route.dart';

class HttpCarrier implements Carrier {
  HttpCarrier(this._request, this.route);

  final HttpClientRequest _request;

  @override
  void cancel() {
    _request.abort();
  }

  @override
  void noNewExchanges() {}

  @override
  final Route route;

  @override
  void trackFailure(RealCall call, OkHttpException? e) {}
}
