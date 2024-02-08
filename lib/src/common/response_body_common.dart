part of 'package:okhttp/src/response_body.dart';

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
