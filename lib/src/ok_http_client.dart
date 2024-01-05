import 'dart:io';

import 'package:ok_http/src/call.dart';
import 'package:ok_http/src/connection/real_call.dart';
import 'package:ok_http/src/interceptor.dart';
import 'package:ok_http/src/request.dart';
import 'package:ok_http/src/_client.dart';

class OkHttpClient {
  List<Interceptor> get interceptors => List.unmodifiable(_interceptors);

  final List<Interceptor> _interceptors = [];

  List<Interceptor> get networkInterceptors =>
      List.unmodifiable(_networkInterceptors);

  final List<Interceptor> _networkInterceptors = [];

  // final Authenticator authenticator = Authenticator();
  // final CookieJar cookieJar = CookieJar();
  // final Dns dns = Dns();
  // final Proxy proxy = Proxy();
  // final ProxySelector proxySelector = ProxySelector();
  // final proxyAuthenticator = Authenticator();
  // final x509TrustManager = X509TrustManager();

  bool retryOnConnectionFailure = false;
  int callTimeoutMillis = 0;
  int connectTimeoutMillis = 0;
  int readTimeoutMillis = 0;
  int writeTimeoutMillis = 0;
  int pingIntervalMillis = 0;
  int minWebSocketMessageToCompress = 0;

  bool persistentConnection = true;

  final bool followRedirects = true;

  /// Set this property to the maximum number of redirects to follow
  /// when [followRedirects] is `true`. If this number is exceeded
  /// an error event will be added with a [RedirectException].
  ///
  /// The default value is 5.
  int maxRedirects = 5;

  /// Gets or sets if the [Request] should buffer output.
  ///
  /// Default value is `true`.
  ///
  /// __Note__: Disabling buffering of the output can result in very poor
  /// performance, when writing many small chunks.
  bool bufferOutput = true;

  OkHttpClient();

  late final RealClient _realClient = RealClient(this);

  Call newCall(Request request) {
    return RealCall(
      client: this,
      originalRequest: request,
      realClient: _realClient,
    );
  }

  void addInterceptor(Interceptor interceptor) {
    _interceptors.add(interceptor);
  }

  void addNetworkInterceptor(Interceptor interceptor) {
    _networkInterceptors.add(interceptor);
  }

  void close() {
    _realClient.close();
  }
}

// class X509TrustManager {}

// class ProxySelector {}

// class Proxy {}

// class Dns {}

// class CookieJar {}

// class Authenticator {}
