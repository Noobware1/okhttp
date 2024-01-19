import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http_parser/http_parser.dart';
import 'package:okhttp/src/byte_stream.dart';
import 'package:okhttp/src/request.dart';
import 'package:okhttp/src/response.dart';
import 'package:okhttp/src/utils/utils.dart';

class ResponseBody extends ByteStream {
  ResponseBody(super.stream);
}


// class RealResponseBody implements ResponseBody {
//   final Future<Socket> Function() detachSocket;

//   RealResponseBody({
//     required this.detachSocket,
//     required this.bytes,
//     required String? contentTypeString,
//   }) : contentType = contentTypeString.toMediaTypeOrNull();

//   @override
//   final List<int> bytes;

//   @override
//   void close() {
//     detachSocket().then((socket) => socket.destroy());
//   }

//   @override
//   int get contentLength => bytes.length;

//   @override
//   final MediaType? contentType;

//   @override
//   String get string => encodingForContentType(contentType).decode(bytes);
// }
