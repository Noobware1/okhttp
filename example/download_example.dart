import 'package:okhttp/src/interceptors/downloading_interceptor.dart';
import 'package:okhttp/src/okhttp_client.dart';
import 'package:okhttp/src/request.dart';

void main(List<String> args) {
  final downloader = DownloadingInterceptor(
      savePath: 'output.png',
      deleteOnError: true,
      onProgress: (recevied, total) {
        print('Progress: $recevied/$total');
      },
      timeout: Duration(minutes: 5));

  final client =
      OkHttpClient.Builder().addNetworkInterceptor(downloader).build();

  final request =
      Request.Builder().url('https://i.imgur.com/2vQtZBb.png').get().build();

  client.newCall(request).execute().then((response) {
    print(
        'Downloaded ${response.body.contentLength} bytes to ${downloader.savePath} successfully!');
  });
}
