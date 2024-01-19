import 'dart:async';
import 'dart:convert';
import 'package:dartx/dartx.dart';
import 'package:http_parser/http_parser.dart';
import 'package:okhttp/src/utils/utils.dart';

abstract class RequestBody {
  const RequestBody();

  int get contentLength;

  MediaType? get contentType;

  void writeTo(StreamSink<List<int>> sink);

  factory RequestBody.fromString(String content, [MediaType? contentType]) {
    final (charSet, finalContentType) = contentType.resloveWithCharSet();
    return _BytesBody(charSet.encode(content), finalContentType);
  }

  factory RequestBody.fromMap(Map<String, String> map,
      [MediaType? contentType]) {
    final (charSet, finalContentType) = contentType.resloveWithCharSet();
    return _BytesBody(charSet.encode(jsonEncode(map)), finalContentType);
  }

  factory RequestBody.fromBytes(List<int> bytes, [MediaType? contentType]) {
    return _BytesBody(bytes, contentType);
  }

  static const empty = _BytesBody([], null);
}

final class _BytesBody extends RequestBody {
  const _BytesBody(this._bytes, this.contentType);

  final List<int> _bytes;

  @override
  final MediaType? contentType;

  @override
  int get contentLength => _bytes.length;

  @override
  void writeTo(StreamSink<List<int>> sink) {
    sink.add(_bytes);
  }
}

extension on MediaType? {
  (Encoding, MediaType?) resloveWithCharSet() {
    if (isNull) {
      return (utf8, this);
    }
    final Encoding charSet;

    if (this!.parameters.containsKey('charset')) {
      charSet = requiredEncodingForCharset(this!.parameters['charset']!);
    } else {
      charSet = utf8;
    }

    return (charSet, MediaType.parse('$this; charset=${charSet.name}'));
  }
}
