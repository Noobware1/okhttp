import 'dart:async';
import 'dart:convert';

import 'package:http_parser/http_parser.dart';
import 'package:okhttp/src/utils/utils.dart';

part 'package:okhttp/src/common/request_body_common.dart';

abstract class RequestBody {
  const RequestBody();

  int get contentLength;

  MediaType? get contentType;

  void writeTo(StreamSink<List<int>> sink);

  factory RequestBody.fromString(String content, [MediaType? contentType]) =>
      _fromString(content, contentType);

  factory RequestBody.fromMap(Map<String, dynamic> map,
          [MediaType? contentType]) =>
      _fromMap(map, contentType);

  factory RequestBody.fromBytes(List<int> bytes, [MediaType? contentType]) =>
      _fromBytes(bytes, contentType);

  factory RequestBody.fromStream(Stream<List<int>> stream,
          [MediaType? contentType, int? contentLength]) =>
      _fromStream(stream, contentType, contentLength);

  static const RequestBody empty = _BytesBody([], null);
}
