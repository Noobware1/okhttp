import 'dart:convert';

import 'package:http_parser/http_parser.dart';
import 'package:ok_http/src/utils/utils.dart';

abstract class RequestBody {
  RequestBody(MediaType contentType)
      : _contentType = contentType.change(parameters: {'charset': utf8.name});

  MediaType _contentType;

  MediaType get contentType => _contentType.change(parameters: {
        'charset': _encoding.name,
      });

  Encoding get encoding => _encoding;

  Encoding _encoding = utf8;

  set contentType(MediaType contentType) {
    if (contentType.parameters.containsKey('charset')) {
      _encoding =
          requiredEncodingForCharset(contentType.parameters['charset']!);
      _contentType = contentType;
    }
  }

  factory RequestBody.fromString(String content, MediaType contentType) {
    return _StringBody(content, contentType);
  }

  /// Returns the number of bytes in that will returned by [bytes], or [byteStream], or -1 if
  /// unknown.
  int get contentLength;

  // void writeTo(StringSink sink);

  List<int> toBytes() {
    return _encoding.encode(toString());
  }
}

class _StringBody extends RequestBody {
  final String content;
  _StringBody(
    this.content,
    super.contentType,
  );

  @override
  int get contentLength => content.length;

  @override
  String toString() {
    return content;
  }
}
