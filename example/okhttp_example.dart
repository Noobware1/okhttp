import 'package:okhttp/interceptor.dart';
import 'package:okhttp/okhttp.dart';
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

  client.newCall(request).execute().then((response) {
    client.destroy();
    print(response.body.string);
  });
}


