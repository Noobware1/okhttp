// ignore_for_file: constant_identifier_names

import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:nice_dart/nice_dart.dart';
import 'package:okhttp/src/dns.dart';

extension on ByteData {
  Int8List toList(int offset) {
    return buffer.asInt8List().sublist(offset);
  }
}

class DnsRecordCodec {
  static const int TYPE_A = 0x0001;
  static const int TYPE_AAAA = 0x001c;

  static const _SERVFAIL = 2;
  static const _NXDOMAIN = 3;

  static Uint8List encodeQuery(String host, int type) {
    ByteData byteData = ByteData(512); // Adjust the size based on your needs
    int offset = 0;

    byteData.setInt16(offset, 0); // query id
    offset += 2;
    byteData.setInt16(offset, 256); // flags with recursion
    offset += 2;
    byteData.setInt16(offset, 1); // question count
    offset += 2;
    byteData.setInt16(offset, 0); // answerCount
    offset += 2;
    byteData.setInt16(offset, 0); // authorityResourceCount
    offset += 2;
    byteData.setInt16(offset, 0); // additional
    offset += 2;

    List<String> labels =
        host.split('.').dropLastWhile((label) => label.isEmpty).toList();
    for (String label in labels) {
      int utf8ByteCount = utf8.encode(label).length;
      assert(utf8ByteCount == label.length, "non-ascii hostname: $host");
      byteData.setInt8(offset, utf8ByteCount);
      offset++;
      List<int> labelBytes = utf8.encode(label);
      for (int byte in labelBytes) {
        byteData.setInt8(offset, byte);
        offset++;
      }
    }

    byteData.setInt8(offset, 0); // end
    offset++;

    byteData.setInt16(offset, type);
    offset += 2;
    byteData.setInt16(offset, 1); // CLASS_IN
    offset += 2;

    Uint8List result = byteData.buffer.asUint8List(0, offset);

    return result;
  }

  static List<InternetAddress> decodeAnswers(
      String hostname, Uint8List byteString) {
    List<InternetAddress> result = [];

    var buf = ByteData.view(byteString.buffer);
    int offset = 2; // query id

    int flags = buf.getInt16(offset) & 0xffff;
    offset += 2;
    assert(
        (flags >> 15) != 0); // require(flags shr 15 != 0) { "not a response" }

    int responseCode = flags & 0xf;

    if (responseCode == _NXDOMAIN) {
      throw UnknownHostException("$hostname: NXDOMAIN");
    } else if (responseCode == _SERVFAIL) {
      throw UnknownHostException("$hostname: SERVFAIL");
    }
    final questionCount = buf.getInt16(offset).toInt() & 0xffff;
    offset += 2;
    final answerCount = buf.getInt16(offset).toInt() & 0xffff;
    offset += 2;

    offset += 4; // authority record count and additional record count

    for (int i = 0; i < questionCount; i++) {
      offset = skipName(buf, offset); // name
      offset += 4; // type and class
    }

    for (int i = 0; i < answerCount; i++) {
      offset = skipName(buf, offset); // name
      final type = buf.getInt16(offset).toInt() & 0xffff;
      offset += 2;
      offset += 2; // class

      buf.getInt16(offset) & 0xffffffff; // ttl
      offset += 4;
      final length = buf.getInt16(offset).toInt() & 0xffff;
      offset += 2;

      if (type == TYPE_A || type == TYPE_AAAA) {
        final bytes = Uint8List(length);
        for (var pos = 0; pos < bytes.length; pos++) {
          bytes[pos] = buf.getInt8(offset);
          offset++;
        }

        result.add(InternetAddress.fromRawAddress(bytes));
      } else {
        offset += length;
      }
    }

    return result;
  }

  static int skipName(ByteData source, int offset) {
    int length = source.getInt8(offset);

    offset += 1;
    if (length < 0) {
      offset += 1; // compressed name pointer, first two bits are 1
      // drop second byte of compression offset
    } else {
      while (length > 0) {
        offset += length;
        length = source.getInt8(offset);

        offset += 1;
      }
    }
    return offset;
  }
}
