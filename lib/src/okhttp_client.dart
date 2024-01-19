import 'dart:io';

import 'package:dartx/dartx.dart';
import 'package:okhttp/src/adapters/http_client_adapter.dart';
import 'package:okhttp/src/call.dart';
import 'package:okhttp/src/connection/real_call.dart';
import 'package:okhttp/src/interceptor.dart';
import 'package:okhttp/src/request.dart';
import 'package:okhttp/src/_client.dart';

class OkHttpClient {
  final List<Interceptor> interceptors;

  final List<Interceptor> networkInterceptors;

  // final Authenticator authenticator = Authenticator();
  // final CookieJar cookieJar = CookieJar();
  // final Dns dns = Dns();
  // final Proxy proxy = Proxy();
  // final ProxySelector proxySelector = ProxySelector();
  // final proxyAuthenticator = Authenticator();
  // final x509TrustManager = X509TrustManager();

  final bool retryOnConnectionFailure;
  final int callTimeoutMillis;
  final int connectTimeoutMillis;
  final int readTimeoutMillis;
  final int writeTimeoutMillis;
  final int pingIntervalMillis;
  final int minWebSocketMessageToCompress;

  final bool persistentConnection;

  final bool followRedirects;

  /// Set this property to the maximum number of redirects to follow
  /// when [followRedirects] is `true`. If this number is exceeded
  /// an error event will be added with a [RedirectException].
  ///
  /// The default value is 5.
  final int maxRedirects;

  OkHttpClient()
      : interceptors = List.unmodifiable([]),
        networkInterceptors = List.unmodifiable([]),
        retryOnConnectionFailure = false,
        callTimeoutMillis = 0,
        connectTimeoutMillis = 0,
        readTimeoutMillis = 0,
        writeTimeoutMillis = 0,
        pingIntervalMillis = 0,
        minWebSocketMessageToCompress = 0,
        persistentConnection = true,
        followRedirects = true,
        maxRedirects = 5,
        adapter = HttpClientAdapter();

  OkHttpClient._(OkHttpClientBuilder builder)
      : interceptors = builder.interceptors,
        networkInterceptors = builder.networkInterceptors,
        retryOnConnectionFailure = builder._retryOnConnectionFailure,
        callTimeoutMillis = builder._callTimeoutMillis,
        connectTimeoutMillis = builder._connectTimeoutMillis,
        readTimeoutMillis = builder._readTimeoutMillis,
        writeTimeoutMillis = builder._writeTimeoutMillis,
        pingIntervalMillis = builder._pingIntervalMillis,
        minWebSocketMessageToCompress = builder._minWebSocketMessageToCompress,
        persistentConnection = builder._persistentConnection,
        followRedirects = builder._followRedirects,
        maxRedirects = builder._maxRedirects,
        adapter = builder._adapter;

  final ClientAdapter adapter;

  Call newCall(Request request) {
    return RealCall(
      client: this,
      originalRequest: request,
    );
  }

  static OkHttpClientBuilder Builder() => _OkHttpClientBuilder(OkHttpClient());

  OkHttpClientBuilder newBuilder() => _OkHttpClientBuilder(this);

  // void close() {
  //   _realClient.close();
  // }
}

class _OkHttpClientBuilder extends OkHttpClientBuilder {
  _OkHttpClientBuilder(OkHttpClient client) : super(client);
}

sealed class OkHttpClientBuilder {
  final List<Interceptor> _interceptors = [];
  final List<Interceptor> _networkInterceptors = [];
  late bool _retryOnConnectionFailure;
  late int _callTimeoutMillis;
  late int _connectTimeoutMillis;
  late int _readTimeoutMillis;
  late int _writeTimeoutMillis;
  late int _pingIntervalMillis;
  late int _minWebSocketMessageToCompress;
  late bool _persistentConnection;
  late bool _followRedirects;
  late int _maxRedirects;
  late ClientAdapter _adapter;

  OkHttpClientBuilder(OkHttpClient client) {
    _interceptors.addAll(client.interceptors);
    _networkInterceptors.addAll(client.networkInterceptors);
    _retryOnConnectionFailure = client.retryOnConnectionFailure;
    _callTimeoutMillis = client.callTimeoutMillis;
    _connectTimeoutMillis = client.connectTimeoutMillis;
    _readTimeoutMillis = client.readTimeoutMillis;
    _writeTimeoutMillis = client.writeTimeoutMillis;
    _pingIntervalMillis = client.pingIntervalMillis;
    _minWebSocketMessageToCompress = client.minWebSocketMessageToCompress;
    _persistentConnection = client.persistentConnection;
    _followRedirects = client.followRedirects;
    _maxRedirects = client.maxRedirects;
    _adapter = client.adapter;
  }

  List<Interceptor> get interceptors => List.unmodifiable(_interceptors);

  OkHttpClientBuilder addInterceptor(Interceptor interceptor) {
    return apply((it) {
      it._interceptors.add(interceptor);
    });
  }

  List<Interceptor> get networkInterceptors =>
      List.unmodifiable(_networkInterceptors);

  OkHttpClientBuilder addNetworkInterceptor(Interceptor interceptor) {
    return apply((it) {
      it._networkInterceptors.add(interceptor);
    });
  }

  OkHttpClientBuilder retryOnConnectionFailure(bool retryOnConnectionFailure) {
    return apply((it) {
      it._retryOnConnectionFailure = retryOnConnectionFailure;
    });
  }

  OkHttpClientBuilder callTimeoutMillis(int callTimeoutMillis) {
    return apply((it) {
      it._callTimeoutMillis = callTimeoutMillis;
    });
  }

  OkHttpClientBuilder connectTimeoutMillis(int connectTimeoutMillis) {
    return apply((it) {
      it._connectTimeoutMillis = connectTimeoutMillis;
    });
  }

  OkHttpClientBuilder readTimeoutMillis(int readTimeoutMillis) {
    return apply((it) {
      it._readTimeoutMillis = readTimeoutMillis;
    });
  }

  OkHttpClientBuilder writeTimeoutMillis(int writeTimeoutMillis) {
    return apply((it) {
      it._writeTimeoutMillis = writeTimeoutMillis;
    });
  }

  OkHttpClientBuilder pingIntervalMillis(int pingIntervalMillis) {
    return apply((it) {
      it._pingIntervalMillis = pingIntervalMillis;
    });
  }

  OkHttpClientBuilder minWebSocketMessageToCompress(
      int minWebSocketMessageToCompress) {
    return apply((it) {
      it._minWebSocketMessageToCompress = minWebSocketMessageToCompress;
    });
  }

  OkHttpClientBuilder persistentConnection(bool persistentConnection) {
    return apply((it) {
      it._persistentConnection = persistentConnection;
    });
  }

  OkHttpClientBuilder followRedirects(bool followRedirects) {
    return apply((it) {
      it._followRedirects = followRedirects;
    });
  }

  OkHttpClientBuilder maxRedirects(int maxRedirects) {
    return apply((it) {
      it._maxRedirects = maxRedirects;
    });
  }

  OkHttpClientBuilder addAdapter(ClientAdapter adapter) {
    return apply((it) {
      it._adapter = adapter;
    });
  }

  OkHttpClient build() => OkHttpClient._(this);
}
