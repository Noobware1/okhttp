OkHttp
======

HTTP is the way modern applications network. It’s how we exchange data & media. Doing HTTP
efficiently makes your stuff load faster and saves bandwidth.

OkHttp is an HTTP client that’s efficient by default:

 * HTTP/2 support allows all requests to the same host to share a socket.
 * Connection pooling reduces request latency (if HTTP/2 isn’t available).
 * Transparent GZIP shrinks download sizes.
 * Response caching avoids the network completely for repeat requests.

OkHttp perseveres when the network is troublesome: it will silently recover from common connection
problems. If your service has multiple IP addresses, OkHttp will attempt alternate addresses if the
first connect fails. This is necessary for IPv4+IPv6 and services hosted in redundant data
centers. OkHttp supports modern TLS features (TLS 1.3, ALPN, certificate pinning). It can be
configured to fall back for broad connectivity.

Using OkHttp is easy. Its request/response API is designed with fluent builders and immutability. It
supports both synchronous blocking calls and async calls with callbacks.


Get a URL
---------

```dart
import 'package:okhttp/okhttp.dart';
import 'package:okhttp/request.dart';

OkHttpClient client = OkHttpClient();

Future<String> get(String url) {
  Request request = Request.Builder().url(url).get().build();

  final response = client
      .newCall(request)
      .execute()
      .then((value) => value.body.string)
      .catchError((e, s) => 'Error: $e, StackTrace: $s');

  return response;
}
```


Post to a Server
----------------

```dart
import 'package:okhttp/okhttp.dart';
import 'package:okhttp/request.dart';

final MediaType JSON = MediaType.parse("application/json");

OkHttpClient client = OkHttpClient();

Future<String> post(String url, String json) {
  RequestBody body = RequestBody.fromString(json, JSON);
  Request request = Request.Builder().url(url).post(body).build();

  final response = client
      .newCall(request)
      .execute()
      .then((value) => value.body.string)
      .catchError((e, s) => 'Error: $e, StackTrace: $s');

  return response;
}
```

License
-------

```
Copyright 2019 Square, Inc.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

   http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```
