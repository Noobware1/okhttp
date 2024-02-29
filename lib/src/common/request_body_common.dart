part of 'package:okhttp/src/request_body.dart';

abstract class RequestBodyType {
  static final MediaType BINARY = 'application/octet-stream'.toMediaType();

  static final MediaType TEXT = 'text/plain'.toMediaType();

  static final MediaType JSON = 'application/json'.toMediaType();

  static final MediaType HTML = 'text/html'.toMediaType();

  static final MediaType XML = 'application/xml'.toMediaType();

  static final MediaType FORM =
      'application/x-www-form-urlencoded'.toMediaType();

  /// The "mixed" subtype of "multipart" is intended for use when the body parts are independent
  /// and need to be bundled in a particular order. Any "multipart" subtypes that an implementation
  /// does not recognize must be treated as being of subtype "mixed".
  static final MediaType MULTIPART_MIXED = "multipart/mixed".toMediaType();

  /// The "multipart/alternative" type is syntactically identical to "multipart/mixed", but the
  /// semantics are different. In particular, each of the body parts is an "alternative" version of
  /// the same information.
  static final MediaType MULTIPART_ALTERNATIVE =
      "multipart/alternative".toMediaType();

  /// This type is syntactically identical to "multipart/mixed", but the semantics are different.
  /// In particular, in a digest, the default `Content-Type` value for a body part is changed from
  /// "text/plain" to "message/rfc822".
  static final MediaType MULTIPART_DIGEST = "multipart/digest".toMediaType();

  /// This type is syntactically identical to "multipart/mixed", but the semantics are different.
  /// In particular, in a parallel entity, the order of body parts is not significant.
  static final MediaType MULTIPART_PARALLEL =
      "multipart/parallel".toMediaType();

  /// The media-type multipart/form-data follows the rules of all multipart MIME data streams as
  /// outlined in RFC 2046. In forms, there are a series of fields to be supplied by the user who
  /// fills out the form. Each field has a name. Within a given form, the names are unique.
  static final MediaType MULTIPART_FORM = "multipart/form-data".toMediaType();
}

RequestBody _fromString(String content, [MediaType? contentType]) {
  final (charSet, finalContentType) = contentType.resloveWithCharSet();
  return _BytesBody(charSet.encode(content), finalContentType);
}

RequestBody _fromMap(Map<String, dynamic> map, [MediaType? contentType]) {
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
