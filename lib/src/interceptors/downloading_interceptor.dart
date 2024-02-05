import 'dart:async';
import 'dart:io';

import 'package:nice_dart/nice_dart.dart';
import 'package:http_parser/http_parser.dart';
import 'package:okhttp/src/interceptor.dart';
import 'package:okhttp/src/response.dart';
import 'package:okhttp/src/response_body.dart';
import 'package:okhttp/src/response_body/stream_response_body.dart';

class DownloadingInterceptor implements Interceptor {
  final Function(int, int)? onProgress;
  final String savePath;
  final Duration? timeout;
  final bool deleteOnError;

  DownloadingInterceptor({
    this.onProgress,
    required this.savePath,
    this.timeout,
    this.deleteOnError = true,
  });

  @override
  Future<Response> intercept(Chain chain) async {
    final response = await chain.proceed(chain.request);

    if (response.body is! StreamResponseBody) {
      throw StateError('Response body is not a stream');
    }
    final ResponseBody body = await timeout.let(
      (it) => it != null
          ? _download(response).timeout(it, onTimeout: () async {
              throw TimeoutException('Download timeout');
            })
          : _download(response),
    );

    return response.newBuilder().body(body).build();
  }

  Future<ResponseBody> _download(Response response) async {
    final file = File(savePath)..createSync(recursive: true);
    try {
      // Shouldn't call file.writeAsBytesSync(list, flush: flush),
      // because it can write all bytes by once. Consider that the file is
      // a very big size (up to 1 Gigabytes), it will be expensive in memory.
      RandomAccessFile raf = file.openSync(mode: FileMode.write);
      int received = 0;

      final stream = response.body as StreamResponseBody;

      final total =
          (response.headers['content-length']?.toString() ?? '-1').toInt();
      final completer = Completer<ResponseBody>();

      Future<void>? asyncWrite;
      bool closed = false;
      Future<void> closeAndDelete() async {
        if (!closed) {
          closed = true;
          await asyncWrite;
          await raf.close().catchError((_) => raf);
          if (deleteOnError && file.existsSync()) {
            await file.delete().catchError((_) => file);
          }
        }
      }

      late StreamSubscription subscription;
      subscription = stream.listen(
        (data) {
          subscription.pause();
          // Write file asynchronously
          asyncWrite = raf.writeFrom(data).then((result) {
            // Notify progress
            received += data.length;
            onProgress?.call(received, total);
            raf = result;
            subscription.resume();
          }).catchError((Object e) async {
            try {
              await subscription.cancel().catchError((_) {});
              closed = true;
              await raf.close().catchError((_) => raf);
              if (deleteOnError && file.existsSync()) {
                await file.delete().catchError((_) => file);
              }
            } finally {
              completer.completeError(e);
            }
          });
        },
        onDone: () async {
          try {
            await asyncWrite;
            closed = true;
            await raf.close().catchError((_) => raf);
            await subscription.cancel();
            //have to return this beacuse the we have already consumed the response body with the download
            completer.complete(DownloadedBody(received, stream.contentType));
          } catch (e) {
            completer.completeError(e);
          }
        },
        onError: (e) async {
          try {
            await closeAndDelete();
          } finally {
            completer.completeError(e);
          }
        },
        cancelOnError: true,
      );
      return completer.future;
    } catch (e) {
      file.deleteSync();
      rethrow;
    }
  }
}

class DownloadedBody implements ResponseBody {
  DownloadedBody(this.contentLength, this.contentType);
  @override
  List<int> get bytes => throw _alreadyConsumed();

  @override
  Stream<String> get charStream => throw _alreadyConsumed();

  @override
  final int contentLength;

  @override
  final MediaType? contentType;

  @override
  String get string => throw _alreadyConsumed();

  StateError _alreadyConsumed() {
    return StateError('Response body is already consumed');
  }
}
