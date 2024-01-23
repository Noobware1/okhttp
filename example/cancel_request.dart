import 'package:okhttp/interceptor.dart';
import 'package:okhttp/okhttp.dart';
import 'package:okhttp/request.dart';
import 'package:okhttp/response.dart';

void main(List<String> args) async {
  final client =
      OkHttpClient.Builder().addNetworkInterceptor(DelayResponse()).build();

  final request = Request.Builder()
      .url('https://jsonplaceholder.typicode.com/posts')
      .get()
      .build();

  final call = client.newCall(request);

  var value = call.execute();
  call.cancel();
  print(await value);
}

class DelayResponse implements Interceptor {
  @override
  Future<Response> intercept(Chain chain) {
    return Future.delayed(Duration(seconds: 10), () {
      return chain.proceed(chain.request);
    });
  }
}
