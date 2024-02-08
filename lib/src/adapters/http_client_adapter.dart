import 'dart:io';
import 'package:nice_dart/nice_dart.dart';
import 'package:okhttp/src/client_adapter.dart';
import 'package:okhttp/src/dns.dart';
import 'package:okhttp/src/headers.dart';
import 'package:okhttp/src/okhttp_client.dart';
import 'package:okhttp/src/proxy.dart';
import 'package:okhttp/src/request.dart';
import 'package:okhttp/src/response.dart';
import 'package:okhttp/src/response_body/io_response_body.dart';
import 'package:socks5_proxy/socks_client.dart';

// pretty bad implementation, but it works
class HttpClientAdapter implements ClientAdapter {
  final _inner = HttpClient();

  HttpClientAdapter();

  @override
  Future<Response> newCall(OkHttpClient client, Request request) async {
    final httpClientRequest =
        await HttpClient().openUrl(request.method, request.url);

    httpClientRequest.followRedirects = client.followRedirects;
    httpClientRequest.maxRedirects = client.maxRedirects;
    httpClientRequest.persistentConnection = client.persistentConnection;

    addProxy(client.proxy);

    //sets headers
    request.headers.forEach((name, value) {
      httpClientRequest.headers.set(name, value);
    });

    if (request.body != null) {
      if (request.body!.contentType != null) {
        httpClientRequest.headers
            .set('Content-Type', request.body!.contentType.toString());
      }
      httpClientRequest.headers
          .set('Content-Length', request.body!.contentLength);
      request.body!.writeTo(httpClientRequest);
    }

    final httpResponse = await httpClientRequest.close();

    final headers = Headers.Builder().let((it) {
      httpResponse.headers.forEach((name, values) {
        it.add(name, values);
      });
      return it.build();
    });

    final response = Response.Builder()
        .body(IOStreamResponseBody(httpResponse, headers.get('Content-Type')))
        .request(request)
        .headers(headers)
        .statusCode(httpResponse.statusCode)
        .message(httpResponse.reasonPhrase)
        .build();

    return response;
  }

  @override
  void close({bool force = false}) {
    _inner.close(force: force);
  }

  void addProxy(Proxy proxy) {
    if (proxy == Proxy.NO_PROXY) return;
    if (proxy.type == ProxyType.SOCKS) {
      SocksTCPClient.assignToHttpClient(_inner, [proxy.toProxySettings()]);
    }
    if (proxy.type == ProxyType.HTTP) {
      _inner.findProxy = (uri) {
        return 'PROXY ${proxy.address!}:${proxy.address!.port}';
      };
      if (proxy.userName != null && proxy.password != null) {
        _inner.authenticate = (url, scheme, realm) async {
          _inner.addCredentials(url, realm!,
              HttpClientBasicCredentials(proxy.userName!, proxy.password!));
          return true;
        };
      }
    }
    if (proxy.type == ProxyType.DIRECT) {
      _inner.findProxy = (uri) {
        return 'DIRECT ${proxy.address!}:${proxy.address!.port}';
      };
    }
  }
}

extension on Proxy {
  ProxySettings toProxySettings() {
    return ProxySettings(address!.address!, address!.port,
        password: password, username: userName);
  }
}
