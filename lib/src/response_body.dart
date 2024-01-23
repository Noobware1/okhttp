import 'package:http_parser/http_parser.dart';

abstract class ResponseBody {
  const ResponseBody();

  int get contentLength;

  MediaType? get contentType;

  List<int> get bytes;

  String get string;

  Stream<String> get charStream;

  static const empty = _EmptyResponseBody();
}

class _EmptyResponseBody implements ResponseBody {
  const _EmptyResponseBody();
  @override
  List<int> get bytes => [];

  @override
  int get contentLength => -1;

  @override
  MediaType? get contentType => null;

  @override
  String get string => '';

  @override
  Stream<String> get charStream => Stream.empty();
}
