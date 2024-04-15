// ignore_for_file: non_constant_identifier_names

import 'dart:io';

import 'package:nice_dart/nice_dart.dart';
import 'package:okhttp/src/adapters/http_client_adapter.dart';
import 'package:okhttp/src/call.dart';
import 'package:okhttp/src/client_adapter.dart';
import 'package:okhttp/src/connection/real_call.dart';
import 'package:okhttp/src/cookie_jar.dart';
import 'package:okhttp/src/cookies/default_cookie_jar.dart';
import 'package:okhttp/src/dns.dart';
import 'package:okhttp/src/interceptor.dart';
import 'package:okhttp/src/proxy.dart';
import 'package:okhttp/src/request.dart';

class OkHttpClient {
  final List<Interceptor> interceptors;

  final List<Interceptor> networkInterceptors;

  // final Authenticator authenticator = Authenticator();
  // final Dns dns = Dns();
  // final ProxySelector proxySelector = ProxySelector();
  // final proxyAuthenticator = Authenticator();
  // final x509TrustManager = X509TrustManager();
  final CookieJar cookieJar;
  final Proxy proxy;
  final Dns dns;
  final bool closeResponseBody;
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

  final int maxRetries;

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
        closeResponseBody = true,
        followRedirects = true,
        maxRedirects = 5,
        maxRetries = 0,
        proxy = Proxy.NO_PROXY,
        dns = Dns.SYSTEM,
        adapter = HttpClientAdapter(),
        cookieJar = ShittyCookieJar();

  OkHttpClient._(OkHttpClientBuilder builder)
      : interceptors = builder.interceptors,
        networkInterceptors = builder.networkInterceptors,
        retryOnConnectionFailure = builder._retryOnConnectionFailure,
        closeResponseBody = builder._closeResponseBody,
        callTimeoutMillis = builder._callTimeoutMillis,
        connectTimeoutMillis = builder._connectTimeoutMillis,
        readTimeoutMillis = builder._readTimeoutMillis,
        writeTimeoutMillis = builder._writeTimeoutMillis,
        pingIntervalMillis = builder._pingIntervalMillis,
        minWebSocketMessageToCompress = builder._minWebSocketMessageToCompress,
        persistentConnection = builder._persistentConnection,
        followRedirects = builder._followRedirects,
        maxRedirects = builder._maxRedirects,
        maxRetries = builder._maxRetries,
        proxy = builder._proxy,
        dns = builder._dns,
        adapter = builder._adapter,
        cookieJar = builder._cookieJar;

  final ClientAdapter adapter;

  Call newCall(Request request) {
    return RealCall(
      client: this,
      originalRequest: request,
    );
  }

  static OkHttpClientBuilder Builder() => _OkHttpClientBuilder(OkHttpClient());

  OkHttpClientBuilder newBuilder() => _OkHttpClientBuilder(this);

  void destroy() {
    adapter.close();
  }
}

class _OkHttpClientBuilder extends OkHttpClientBuilder {
  _OkHttpClientBuilder(OkHttpClient client) : super(client);
}

sealed class OkHttpClientBuilder {
  final List<Interceptor> _interceptors = [];
  final List<Interceptor> _networkInterceptors = [];
  bool _retryOnConnectionFailure;
  int _callTimeoutMillis;
  int _connectTimeoutMillis;
  int _readTimeoutMillis;
  int _writeTimeoutMillis;
  int _pingIntervalMillis;
  int _minWebSocketMessageToCompress;
  bool _persistentConnection;
  bool _followRedirects;
  bool _closeResponseBody;
  int _maxRedirects;
  int _maxRetries;
  ClientAdapter _adapter;
  Proxy _proxy;
  Dns _dns;
  CookieJar _cookieJar;

  OkHttpClientBuilder(OkHttpClient client)
      : _retryOnConnectionFailure = client.retryOnConnectionFailure,
        _closeResponseBody = client.closeResponseBody,
        _callTimeoutMillis = client.callTimeoutMillis,
        _connectTimeoutMillis = client.connectTimeoutMillis,
        _readTimeoutMillis = client.readTimeoutMillis,
        _writeTimeoutMillis = client.writeTimeoutMillis,
        _pingIntervalMillis = client.pingIntervalMillis,
        _minWebSocketMessageToCompress = client.minWebSocketMessageToCompress,
        _persistentConnection = client.persistentConnection,
        _followRedirects = client.followRedirects,
        _maxRedirects = client.maxRedirects,
        _maxRetries = client.maxRetries,
        _proxy = client.proxy,
        _dns = client.dns,
        _cookieJar = client.cookieJar,
        _adapter = client.adapter {
    _interceptors.addAll(client.interceptors);
    _networkInterceptors.addAll(client.networkInterceptors);
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

  OkHttpClientBuilder closeResponseBody(bool closeResponseBody) {
    return apply((it) {
      it._closeResponseBody = closeResponseBody;
    });
  }

  OkHttpClientBuilder callTimeoutMillis(int callTimeoutMillis) {
    return apply((it) {
      it._callTimeoutMillis = callTimeoutMillis;
    });
  }

  OkHttpClientBuilder dns(Dns dns) {
    return apply((it) {
      it._dns = dns;
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

  OkHttpClientBuilder maxRetries(int maxRetries) {
    return apply((it) {
      it._maxRetries = maxRetries;
    });
  }

  OkHttpClientBuilder addAdapter(ClientAdapter adapter) {
    return apply((it) {
      it._adapter = adapter;
    });
  }

  OkHttpClientBuilder proxy(Proxy? proxy) {
    return apply((it) {
      if (proxy != null && proxy != Proxy.NO_PROXY) {
        it._proxy = proxy;
      }
    });
  }

  OkHttpClientBuilder cookieJar(CookieJar cookieJar) {
    return apply((it) {
      it._cookieJar = cookieJar;
    });
  }

  OkHttpClient build() => OkHttpClient._(this);
}
