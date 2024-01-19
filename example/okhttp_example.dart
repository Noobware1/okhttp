import 'dart:convert';

import 'package:okhttp/src/interceptors/http_logging_interceptor.dart';
import 'package:okhttp/src/json_body.dart';
import 'package:okhttp/src/okhttp_client.dart';
import 'package:okhttp/src/request.dart';

void main(List<String> args) {
  final body =
      JsonBody.Builder().add('title', 'foo').add('body', 'bar').build();

  final request = Request.Builder()
      .url('https://jsonplaceholder.typicode.com/posts')
      .post(body)
      .build();

  final client = OkHttpClient.Builder()
      .addInterceptor(LoggingInterceptor(
          level: LogLevel.HEADERS, logger: Logger(color: Color.red)))
      .build();

  final Stopwatch stopwatch = Stopwatch()..start();
  client.newCall(request).execute().then((response) {
    print(jsonDecode(response.body.string).runtimeType);
    print('THE END: ${stopwatch.elapsedMilliseconds}');
  });

  // final dio = Dio()
  //   ..interceptors.add(
  //       LogInterceptor(logPrint: (obj) => Logger(color: Color.red).log(obj)));
  // final Stopwatch stopwatch = Stopwatch()..start();
  // dio.post('https://jsonplaceholder.typicode.com/posts', data: {
  //   'title': 'foo',
  //   'body': 'bar',
  //   'userId': 1,
  // }).then((response) {
  //   print(response.data.runtimeType);
  //   print('THE END: ${stopwatch.elapsedMilliseconds}');
  // });
}
