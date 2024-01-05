import 'package:ok_http/client.dart';
import 'package:ok_http/src/request.dart';

void main() {
  final client = OkHttpClient();
  final request = Request(url: 'https://www.google.com', method: 'GET');

  client.newCall(request).execute().then((response) {
    print(response.text);
  });
}
