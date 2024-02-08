// ignore_for_file: non_constant_identifier_names

import 'package:nice_dart/nice_dart.dart';
import 'package:okhttp/src/common/map.dart';
import 'package:okhttp/src/common/string.dart';
import 'package:okhttp/src/dates/dates.dart';
part 'package:okhttp/src/common/headers_common.dart';

final class Headers {
  Headers._(this._nameAndValues);

  factory Headers.fromMap(Map<String, String> map) => _fromMap(map);

  final Map<String, List<String>> _nameAndValues;

  /// Returns the last value corresponding to the specified field, or null.
  String? get(String name) => commonGet(name);

  String? operator [](String name) => commonGet(name);

  int get length => commonLength;

  /// Returns the last value corresponding to the specified field parsed as an HTTP date, or null if either the field is absent or cannot be parsed as a date.
  DateTime? getDate(String name) => commonGetDate(name);

  String name(int index) => commonName(index);

  String value(int index) => commonValue(index);

  Set<String> get names => commonNames;

  List<String>? values(String name) => commonValues(name);

  static HeadersBuilder Builder() => _CommonBuilder();

  HeadersBuilder newBuilder() => _CommonBuilder(this);

  void forEach(void Function(String name, List<String> value) action) =>
      commonforEach(action);

  @override
  String toString([bool list = false]) => commonToString(list);

  Map<String, List<String>> toMap() => commontoMap();
}

sealed class HeadersBuilder {
  final Map<String, List<String>> _namesAndValues = caseInsensitiveKeyMap();

  HeadersBuilder([Headers? headers]) {
    if (headers != null) {
      _namesAndValues.addAll(headers._nameAndValues);
    }
  }

  HeadersBuilder add(String name, dynamic value) => commonAdd(name, value);

  /// Add a header with the specified name and value. Does validation of header names, allowing
  /// non-ASCII values.
  HeadersBuilder addUnsafeNonAscii(String name, String value) =>
      commonAddUnsafeNonAscii(name, value);

  HeadersBuilder addAll(Headers headers) => commonAddAll(headers);

  HeadersBuilder set(String name, dynamic value) => commonSet(name, value);

  HeadersBuilder removeAll(String name) => commonRemoveAll(name);

  Headers build() => commonBuild();
}
