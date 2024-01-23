import 'package:http_parser/http_parser.dart';
import 'package:okhttp/src/response_body.dart';
import 'package:okhttp/src/utils/utils.dart';

class RealResponseBody implements ResponseBody {
  RealResponseBody(this.bytes, this.contentType);

  @override
  final List<int> bytes;

  @override
  Stream<String> get charStream =>
      encodingForContentType(contentType).decoder.bind(Stream.value(bytes));

  @override
  int get contentLength => bytes.length;

  @override
  final MediaType? contentType;

  @override
  String get string => encodingForContentType(contentType).decode(bytes);

  Future<String> get bytesToString => Future.value(string);

  Future<List<int>> get toBytes => Future.value(bytes);
}
