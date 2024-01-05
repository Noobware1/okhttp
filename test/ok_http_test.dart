import 'package:ok_http/client.dart';
import 'package:ok_http/request.dart';

OkHttpClient client = OkHttpClient();

Future<String> run(String url) {
  Request request = Request(url: url);

  final response = client
      .newCall(request)
      .execute()
      .then((value) => value.text)
      .catchError((e, s) => 'Error: $e, StackTrace: $s');

  return response;
}
