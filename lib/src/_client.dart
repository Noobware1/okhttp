// import 'dart:async';
// import 'dart:io';

// import 'package:okhttp/src/byte_stream.dart';
// import 'package:okhttp/src/headers.dart';
// import 'package:okhttp/src/okhttp_client.dart';
// import 'package:okhttp/src/request.dart';
// import 'package:okhttp/src/response.dart';
// import 'package:okhttp/src/cookie.dart' as cookie;

// abstract interface class Client {
//   Future<Response> newCall(Request request);

//   void close();
// }

// class RealClient implements Client {
//   final HttpClient _inner = HttpClient();
//   bool isClosed = false;
//   final OkHttpClient client;

//   RealClient(this.client);

//   @override
//   Future<Response> newCall(Request request) async {
//     if (isClosed) {
//       throw Exception("Client is already closed");
//     }
//     if (request is! ByteStream) {
//       throw Exception("Request must be a built before calling newCall()");
//     }
//     final httpClientRequest = await _inner.openUrl(request.method, request.url)
//       ..persistentConnection = client.persistentConnection
//       ..followRedirects = client.followRedirects
//       ..maxRedirects = client.maxRedirects
//       ..bufferOutput = client.bufferOutput;

//     //sets headers
//     request.headers.forEach((name, value) {
//       httpClientRequest.headers.set(name, value);
//     });

//     final realRequest = await (request as ByteStream).pipe(httpClientRequest) as HttpClientResponse;

//     return realRequest.toResponse(request);
//   }

//   RealClient newClient([OkHttpClient? client]) {
//     return RealClient(client ?? this.client);
//   }

//   @override
//   void close() {
//     isClosed = true;
//     _inner.close(force: true);
//   }
// }

// extension on HttpClientResponse {
//   Future<Response> toResponse(Request request) async {
//     final body = await toByteStream(this).toBytes();
//     X509Certificate? certificate;
//     try {
//       certificate = this.certificate;
//     } catch (_) {}

//     return Response(
//       bodyBytes: body,
//       statusCode: statusCode,
//       request: request,
//       contentLength: contentLength,
//       headers: headers.toHeaders(),
//       isRedirect: isRedirect,
//       persistentConnection: persistentConnection,
//       reasonPhrase: reasonPhrase,
//       certificate: certificate,
//       connectionInfo: connectionInfo,
//       cookies: cookies
//           .map((cookie) => cookie.toCookie(request.url))
//           .nonNulls
//           .toList(),
//     );
//   }
// }

// extension on Cookie {
//   cookie.Cookie? toCookie(Uri url) {
//     return cookie.Cookie.parse(url, toString());
//   }
// }

// // extension on HttpHeaders {
// //   Headers toHeaders() {
// //     final headers = Headers();
// //     forEach((name, values) {
// //       headers.add(name, values.join(','));
// //     });
// //     return headers;
// //   }
// // }
