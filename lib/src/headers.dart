// ignore_for_file: non_constant_identifier_names

import 'package:dartx/dartx.dart';
import 'package:okhttp/src/dates/dates.dart';

final class Headers {
  Headers._(this._nameAndValues);

  final Map<String, List<String>> _nameAndValues;

  /// Returns the last value corresponding to the specified field, or null.
  String? get(String name) => _get(name);

  String? operator [](String name) {
    return _get(name);
  }

  int get length => _nameAndValues.values.fold(0, (previousValue, element) {
        return previousValue + element.length;
      });

  /// Returns the last value corresponding to the specified field parsed as an HTTP date, or null if either the field is absent or cannot be parsed as a date.
  DateTime? getDate(String name) =>
      _get(name)?.let((it) => DateTime.tryParse(it));

  String? _get(String name) => _nameAndValues[name]?.last;

  String name(int index) => _nameAndValues.keys.elementAt(index);

  String value(int index) => _nameAndValues.values.elementAt(index).first;

  Set<String> get names => Set.unmodifiable(_nameAndValues.keys);

  List<String>? values(String name) => _nameAndValues[name];

  static HeadersBuilder Builder() => _HeadersBuilder();

  HeadersBuilder newBuilder() => _HeadersBuilder(this);

  void forEach(void Function(String name, List<String> value) action) {
    _nameAndValues.forEach(action);
  }

  @override
  String toString() {
    final stringBuffer = StringBuffer();
    _nameAndValues.forEach((key, value) {
      for (final e in value) {
        stringBuffer.writeln('$key: $e');
      }
    });
    return stringBuffer.toString();
  }

  List<Pair<String, String>> toList() {
    var list = <Pair<String, String>>[];

    _nameAndValues.forEach((key, value) {
      for (final e in value) {
        list.add(Pair(key, e));
      }
    });

    return list;
  }

  Map<String, List<String>> toMap() {
    return _nameAndValues;
  }
}

final class _HeadersBuilder extends HeadersBuilder {
  _HeadersBuilder([Headers? headers]) : super(headers);
}

sealed class HeadersBuilder {
  final Map<String, List<String>> _namesAndValues = {};

  HeadersBuilder([Headers? headers]) {
    if (headers != null) {
      _namesAndValues.addAll(headers._nameAndValues);
    }
  }

  HeadersBuilder add(String name, dynamic value) {
    final values = _namesAndValues[name];
    if (values == null) {
      return set(name, value);
    }
    return apply((it) {
      if (value is DateTime) {
        values.add(value.toHttpDateString().trim());
      } else if (value is String) {
        values.add(value.trim());
      } else if (value is Iterable<String>) {
        values.addAll(value.map((e) => e.trim()));
      } else {
        throw _valueError(value);
      }
    });
  }

  HeadersBuilder addAll(Headers headers) {
    return apply((it) {
      it._namesAndValues.addAll(headers._nameAndValues);
    });
  }

  HeadersBuilder set(String name, dynamic value) => apply((it) {
        if (value is DateTime) {
          it._namesAndValues[name] = [value.toHttpDateString().trim()];
        } else if (value is String) {
          it._namesAndValues[name] = [value.trim()];
        } else if (value is Iterable<String>) {
          it._namesAndValues[name] = value.map((e) => e.trim()).toList();
        } else {
          throw _valueError(value);
        }
      });

  HeadersBuilder removeAll(String name) => apply((it) {
        it._namesAndValues.remove(name);
      });

  Headers build() => Headers._(_namesAndValues);

  ArgumentError _valueError(dynamic value) => ArgumentError.value(
      value, "value", "must be DateTime, String or Iterable<String>");
}
