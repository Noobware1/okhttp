// ignore_for_file: non_constant_identifier_names

import 'dart:async';
import 'dart:convert';

import 'package:dartx/dartx.dart';
import 'package:http_parser/http_parser.dart';
import 'package:okhttp/src/request_body.dart';

final class JsonBody extends RequestBody {
  const JsonBody._(this._map, this._charset);

  final Map<String, String> _map;
  final Encoding _charset;

  @override
  int get contentLength => toString().length;

  @override
  void writeTo(StreamSink<List<int>> sink) {
    sink.add(_charset.encode(toString()));
  }

  static JsonBodyBuilder Builder([Encoding? encoding]) =>
      _JsonBodyBuilder(encoding);

  @override
  String toString() {
    return jsonEncode(_map);
  }

  @override
  MediaType get contentType =>
      MediaType.parse('application/json; charset=${_charset.name}');
}

final class _JsonBodyBuilder extends JsonBodyBuilder {
  _JsonBodyBuilder([Encoding? encoding]) : super(encoding);
}

sealed class JsonBodyBuilder {
  Encoding? encoding;
  JsonBodyBuilder([Encoding? encoding]);

  final _map = <String, String>{};

  JsonBodyBuilder add(String name, String value) {
    return apply((it) {
      it._map[name] = value;
    });
  }

  JsonBodyBuilder addAll(Map<String, String> map) {
    return apply((it) {
      it._map.addAll(map);
    });
  }

  JsonBody build() => JsonBody._(_map, encoding ?? utf8);
}
