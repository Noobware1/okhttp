import 'package:http_parser/http_parser.dart';
part 'package:okhttp/src/common/response_body_common.dart';

abstract class ResponseBody {
  const ResponseBody();

  int get contentLength;

  MediaType? get contentType;

  List<int> get bytes;

  String get string;

  Stream<String> get charStream;

  static const ResponseBody empty = _EmptyResponseBody();
}
