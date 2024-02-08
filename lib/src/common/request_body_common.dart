part of 'package:okhttp/src/request_body.dart';

RequestBody _fromString(String content, [MediaType? contentType]) {
  final (charSet, finalContentType) = contentType.resloveWithCharSet();
  return _BytesBody(charSet.encode(content), finalContentType);
}

RequestBody _fromMap(Map<String, String> map, [MediaType? contentType]) {
  final (charSet, finalContentType) = contentType.resloveWithCharSet();
  return _BytesBody(charSet.encode(jsonEncode(map)), finalContentType);
}

RequestBody _fromBytes(List<int> bytes, [MediaType? contentType]) {
  return _BytesBody(bytes, contentType);
}

RequestBody _fromStream(Stream<List<int>> stream,
    [MediaType? contentType, int? contentLength]) {
  return _StreamBody(stream, contentType, contentLength);
}

final class _StreamBody extends RequestBody {
  const _StreamBody(this._stream, this.contentType, int? contentLength)
      : contentLength = contentLength ?? -1;

  final Stream<List<int>> _stream;

  @override
  final MediaType? contentType;

  @override
  final int contentLength;

  @override
  void writeTo(StreamSink<List<int>> sink) {
    sink.addStream(_stream);
  }
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
    if (this == null) {
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
