import 'dart:async';
import 'dart:convert';
import 'package:http_parser/http_parser.dart';
import 'package:okhttp/src/byte_stream.dart';
import 'package:okhttp/src/response_body.dart';
import 'package:okhttp/src/utils/utils.dart';

abstract class StreamResponseBody extends ByteStream implements ResponseBody {
  StreamResponseBody(super.stream, String? contentTypeString)
      : contentType = contentTypeString.toMediaTypeOrNull();

  @override
  final int contentLength = -1;

  @override
  final MediaType? contentType;

  @override
  String get string => cannotAccess('string', 'bytesToString');

  @override
  List<int> get bytes => cannotAccess('bytes', 'toBytes');

  @override
  Stream<String> get charStream => toStringStream(_encoding);

  T cannotAccess<T>(String name, String alternative) => throw UnsupportedError(
      'Cannot access $name until this body is closed; try using $alternative instead');

  Encoding get _encoding => encodingForContentType(contentType);

  Future<ResponseBody> close();
}
