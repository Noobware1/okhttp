// ignore_for_file: constant_identifier_names

import 'package:nice_dart/nice_dart.dart';
import 'package:http_parser/http_parser.dart';
import 'package:okhttp/src/dates/date_fromatter.dart';
import 'package:okhttp/src/headers.dart';
import 'package:okhttp/src/interceptor.dart';
import 'package:okhttp/src/response.dart';

class Logger {
  static const _format = DateFromat('yyyy-MM-dd HH:mm:ss a');
  final Color color;
  const Logger({
    this.color = Color.green,
  });

  void log(Object? obj) {
    _print(DateFormatter(DateTime.now()).format(_format));
    _print('INFO: ${obj.toString()}');
  }

  void _print(Object? obj) {
    print('$color${obj?.toString()}${Color.reset}');
  }
}

class LoggingInterceptor implements Interceptor {
  final LogLevel level;

  late final Logger logger;

  LoggingInterceptor({
    this.logger = const Logger(),
    this.level = LogLevel.BASIC,
  });

  void logHeader(Headers headers, int i) {
    logger.log("${headers.name(i)}: ${headers.value(i)}");
  }

  bool bodyHasUnknownEncoding(Headers headers) {
    final contentEncoding = headers["Content-Encoding"];
    if (contentEncoding == null) return false;

    return !contentEncoding.equals("identity", ignoreCase: true) &&
        !contentEncoding.equals("gzip", ignoreCase: true);
  }

  bool bodyIsStreaming(Response response) {
    try {
      final contentType = MediaType.parse(response.headers["Content-Type"]!);

      return contentType.type == "text" &&
          contentType.subtype == "event-stream";
    } catch (e) {
      return false;
    }
  }

  @override
  Future<Response> intercept(Chain chain) async {
    final request = chain.request;
    if (level == LogLevel.NONE) {
      return chain.proceed(request);
    }

    final logBody = level == LogLevel.BODY;
    final logHeaders = logBody || level == LogLevel.HEADERS;

    final requestBody = request.body;

    var requestStartMessage = "--> ${request.method} ${request.url}";
    if (!logHeaders && requestBody != null) {
      requestStartMessage += " (${requestBody.contentLength}-byte body)";
    }
    logger.log(requestStartMessage);

    if (logHeaders) {
      var headers = request.headers;

      if (requestBody != null) {
        // Request body headers are only present when installed as a network interceptor. When not
        // already present, force them to be included (if available) so their values are known.
        if (headers["Content-Type"] == null) {
          logger.log("Content-Type: ${requestBody.contentType}");

          if (headers["Content-Length"] == null) {
            logger.log("Content-Length: ${requestBody.contentLength}");
          }
        }
      }

      for (var i = 0; i < headers.length; i++) {
        logHeader(headers, i);
      }

      if (!logBody || requestBody == null) {
        logger.log("--> END ${request.method}");
      } else if (bodyHasUnknownEncoding(request.headers)) {
        logger.log("--> END ${request.method} (encoded body omitted)");
      } else {
        logger.log("");

        logger.log(requestBody.toString());
        logger.log(
            "--> END ${request.method} (${requestBody.contentLength}-byte body)");
      }
    }

    final stopWatch = Stopwatch()..start();
    final Response response;

    try {
      response = await chain.proceed(request);
    } catch (e) {
      logger.log("<-- HTTP FAILED: $e");
      rethrow;
    }

    int tookMs = stopWatch.elapsedMilliseconds - DateTime.now().millisecond;

    final contentLength = response.body.contentLength;
    final bodySize =
        (contentLength != -1) ? "$contentLength-byte" : "unknown-length";

    logger.log(
        "<-- ${response.statusCode}${(response.message.isEmpty) ? "" : ' ${response.message}'} ${response.request.url} (${tookMs}ms${(!logHeaders) ? ", $bodySize body" : ""})");

    if (logHeaders) {
      final headers = response.headers;
      for (var i = 0; i < headers.length; i++) {
        logHeader(headers, i);
      }

      if (!logBody) {
        logger.log("<-- END HTTP");
      } else if (bodyHasUnknownEncoding(headers)) {
        logger.log("<-- END HTTP (encoded body omitted)");
      } else if (bodyIsStreaming(response)) {
        logger.log("<-- END HTTP (streaming body omitted)");
      } else {
        final totalMs =
            stopWatch.elapsedMilliseconds - DateTime.now().millisecond;

        logger.log("");
        logger.log(response.body.string);
        logger.log(
            "<-- END HTTP (${totalMs}ms, ${response.body.bytes.length}-byte body)");
      }
    }
    stopWatch.stop();
    return response;
  }
}

enum Color {
  black("\x1B[30m"),
  red("\x1B[31m"),
  green("\x1B[32m"),
  yellow("\x1B[33m"),
  blue("\x1B[34m"),
  magenta("\x1B[35m"),
  cyan(" \x1B[36m"),
  white("\x1B[37m"),
  reset("\x1B[0m");

  const Color(this.value);

  final String value;

  @override
  String toString() => value;
}

enum LogLevel {
  BASIC,
  HEADERS,
  BODY,
  NONE;
}
