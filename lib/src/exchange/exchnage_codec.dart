import 'package:okhttp/request.dart';
import 'package:okhttp/src/connection/real_call.dart';
import 'package:okhttp/src/expections/okhttp_exception.dart';
import 'package:okhttp/src/headers.dart';
import 'package:okhttp/src/response.dart';
import 'package:okhttp/src/route.dart';

/// Encodes HTTP requests and decodes HTTP responses.
abstract class ExchangeCodec {
  /// The connection or CONNECT tunnel that owns this codec.
  abstract final Carrier carrier;

  /// Returns an output stream where the request body can be streamed.
  Stream<List<int>> createRequestBody(
    Request request,
    int contentLength,
  );

  /// This should update the HTTP engine's sentRequestMillis field.
  void writeRequestHeaders(Request request);

  /// Flush the request to the underlying socket.
  void flushRequest();

  /// Flush the request to the underlying socket and signal no more bytes will be transmitted.
  void finishRequest();

  /// Parses bytes of a response header from an HTTP transport.
  ///
  /// @param expectContinue true to return null if this is an intermediate response with a "100"
  /// response code. Otherwise this method never returns null.
  ResponseBuilder readResponseHeaders(bool expectContinue);

  void reportedContentLength(Response response);

  void openResponseBodySource(Response response);

  /// Returns the trailers after the HTTP response. May be empty.
  Headers trailers();

  /// Cancel this stream. Resources held by this stream will be cleaned up, though not synchronously.
  /// That may happen later by the connection pool thread.
  void cancel();

  /// The timeout to use while discarding a stream of input data. Since this is used for connection
  /// reuse, this timeout should be significantly less than the time it takes to establish a new
  /// connection.
  static const DISCARD_STREAM_TIMEOUT_MILLIS = 100;
}

/// Carries an exchange. This is usually a connection, but it could also be a connect plan for
/// CONNECT tunnels. Note that CONNECT tunnels are significantly less capable than connections.
abstract class Carrier {
  abstract final Route route;

  void trackFailure(RealCall call, OkHttpException? e);

  void noNewExchanges();

  void cancel();
}
