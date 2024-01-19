import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:http_parser/http_parser.dart';
import 'package:okhttp/src/byte_stream.dart';
import 'package:okhttp/src/response_body.dart';
import 'package:okhttp/src/utils/utils.dart';

final class StreamResponseBody implements ResponseBody {
  final ByteStream _byteStream;

  StreamResponseBody(this._byteStream, String? contentTypeString)
      : contentType = contentTypeString.toMediaTypeOrNull();

  @override
  final int contentLength = -1;

  @override
  final MediaType? contentType;

  @override
  String get string => cannotAccess('string', 'bytesToString');

  @override
  List<int> get bytes => cannotAccess('bytes', 'toBytes');

  Future<String> get bytesToString => _byteStream.bytesToString(_encoding);

  Future<List<int>> get toBytes => _byteStream.toBytes();

  @override
  Stream<String> get charStream => _byteStream.toStringStream(_encoding);

  T cannotAccess<T>(String name, String alternative) => throw UnsupportedError(
      'Cannot access $name until this body is closed; try using $alternative instead');

  Encoding get _encoding => encodingForContentType(contentType);

  @override
  Future<ResponseBody> close() async {
    return RealResponseBody(await toBytes, contentType);
  }
}

class RealResponseBody implements ResponseBody {
  RealResponseBody(this.bytes, this.contentType);

  @override
  final List<int> bytes;

  @override
  Stream<String> get charStream =>
      encodingForContentType(contentType).decoder.bind(Stream.value(bytes));

  @override
  Future<ResponseBody> close() {
    return Future.value(this);
  }

  @override
  int get contentLength => bytes.length;

  @override
  final MediaType? contentType;

  @override
  String get string => encodingForContentType(contentType).decode(bytes);

  Future<String> get bytesToString => Future.value(string);

  Future<List<int>> get toBytes => Future.value(bytes);
}
