import 'package:okhttp/interceptor.dart';
import 'package:okhttp/okhttp.dart';
import 'package:okhttp/request.dart';

void main(List<String> args) {
  final body = RequestBody.fromMap({
    'title': 'foo',
    'body': 'bar',
  });

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
    print(response.headers);
  });
}
