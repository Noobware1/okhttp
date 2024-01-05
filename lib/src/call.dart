import 'package:ok_http/src/request.dart';
import 'package:ok_http/src/response.dart';

/// A call is a request that has been prepared for execution. A call can be canceled. As this object
/// represents a single request/response pair (stream), it cannot be executed twice.

abstract interface class Call {
  /// Returns the original request that initiated this call.
  Request get originalRequest;

  /// Invokes the request immediately, and blocks until the response can be processed or is in error.
  ///
  /// To avoid leaking resources callers should close the [Response] which in turn will close the
  /// underlying [ResponseBody].
  ///
  /// ```java
  /// // ensure the response (and underlying response body) is closed
  /// try (Response response = client.newCall(request).execute()) {
  ///   ...
  /// }
  /// ```
  ///
  /// The caller may read the response body with the response's [Response.body] method. To avoid
  /// leaking resources callers must [close the response body][ResponseBody] or the response.
  ///
  /// Note that transport-layer success (receiving a HTTP response code, headers and body) does not
  /// necessarily indicate application-layer success: `response` may still indicate an unhappy HTTP
  /// response code like 404 or 500.
  ///
  /// @throws IOException if the request could not be executed due to cancellation, a connectivity
  ///     problem or timeout. Because networks can fail during an exchange, it is possible that the
  ///     remote server accepted the request before the failure.
  /// @throws IllegalStateException when the call has already been executed.

  Future<Response> execute();

  /// Cancels the request, if possible. Requests that are already complete cannot be canceled.
  void cancel();

  /// Returns true if this call has been either [executed][execute] or [enqueued][enqueue]. It is an
  /// error to execute a call more than once.
  bool get isExecuted;

  bool get isCanceled;

  /// Returns a timeout that spans the entire call: resolving DNS, connecting, writing the request
  /// body, server processing, and reading the response body. If the call requires redirects or
  /// retries all must complete within one timeout period.
  ///
  /// Configure the client's default timeout with [OkHttpClient.Builder.callTimeout].

  Duration get timeout;

  /// Create a new, identical call to this one which can be enqueued or executed even if this call
  /// has already been.

  Call clone();

  Call newCall(Request request);
}

typedef Callback = void Function({
  required OnFailure onFailure,
  required OnResponse onResponse,
});

typedef OnFailure = void Function(Call call, Exception e);

typedef OnResponse = void Function(Call call, Response response);
