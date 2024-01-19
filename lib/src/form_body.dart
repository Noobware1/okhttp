// ignore_for_file: non_constant_identifier_names

import 'dart:async';
import 'dart:convert';

import 'package:dartx/dartx.dart';
import 'package:http_parser/http_parser.dart';
import 'package:okhttp/src/common/stream_sink.dart';
import 'package:okhttp/src/common/string.dart';
import 'package:okhttp/src/request_body.dart';

final class FormBody extends RequestBody {
  FormBody._(this._encodedNames, this._encodedValues);
  final List<String> _encodedNames;
  final List<String> _encodedValues;

  @override
  int get contentLength => toString().length;

  String name(int index) {
    return _encodedNames[index].percentDecode();
  }

  String value(int index) {
    return _encodedValues[index].percentDecode();
  }

  @override
  void writeTo(StreamSink<List<int>> sink) {
    for (var i = 0; i < _encodedNames.length; i++) {
      if (i > 0) sink.writeCharCode('&'.code);
      sink.writeUtf8(_encodedNames[i]);
      sink.writeCharCode('='.code);
      sink.writeUtf8(_encodedValues[i]);
    }
  }

  static FormBodyBuilder Builder([Encoding? encoding]) =>
      _FormBodyBuilder(encoding);

  @override
  String toString() {
    final StringSink buffer = StringBuffer();

    for (var i = 0; i < _encodedNames.length; i++) {
      if (i > 0) buffer.writeCharCode('&'.code);
      buffer.write(_encodedNames[i]);
      buffer.writeCharCode('='.code);
      buffer.write(_encodedValues[i]);
    }
    return buffer.toString();
  }

  @override
  MediaType get contentType =>
      MediaType.parse('application/x-www-form-urlencoded');
}

final class _FormBodyBuilder extends FormBodyBuilder {
  _FormBodyBuilder([Encoding? encoding]) : super(encoding);
}

sealed class FormBodyBuilder {
  Encoding? encoding;
  FormBodyBuilder([Encoding? encoding]);

  final List<String> _names = [];
  final List<String> _values = [];

  FormBodyBuilder add(String name, String value) {
    return apply((it) {
      it._names.add(name.canonicalizeWithCharset(charset: encoding));
      it._values.add(value.canonicalizeWithCharset(charset: encoding));
    });
  }

  FormBodyBuilder addEncoded(String name, String value) {
    return apply((it) {
      it._names.add(name.canonicalizeWithCharset(
          charset: encoding, alreadyEncoded: true));
      it._values.add(value.canonicalizeWithCharset(
          charset: encoding, alreadyEncoded: true));
    });
  }

  FormBody build() => FormBody._(_names, _values);
}
