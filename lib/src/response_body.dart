import 'package:http_parser/http_parser.dart';

abstract class ResponseBody {
  int get contentLength;

  MediaType? get contentType;

  List<int> get bytes;

  String get string;

  Stream<String> get charStream;

  Future<ResponseBody> close();
}
