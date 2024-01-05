import 'dart:convert';

import 'package:http_parser/http_parser.dart';
import 'package:ok_http/src/request_body.dart';

class JsonBody extends RequestBody {
  JsonBody() : super(MediaType.parse('application/json'));

  final _map = <String, dynamic>{};

  @override
  int get contentLength => jsonEncode(_map).length;

  @override
  String toString() {
    return jsonEncode(_map);
  }

  void add(String key, dynamic value) {
    _map[key] = value;
  }

  void addAll(Map<String, dynamic> map) {
    _map.addAll(map);
  }

  Iterable get values => _map.values;

  Iterable<String> get keys => _map.keys;
}

void main(List<String> args) {
  final a = JsonBody();
  a.add('hello', 'btye');
  a.contentType = MediaType.parse('application/json; charset=iso_8859-1');
  print(a.toString());
  print(a.contentType);
}
