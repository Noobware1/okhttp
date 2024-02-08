part of 'package:okhttp/src/headers.dart';

extension on HeadersBuilder {
  HeadersBuilder commonAdd(String name, dynamic value) {
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

  /// Add a header with the specified name and value. Does validation of header names, allowing
  /// non-ASCII values.
  HeadersBuilder commonAddUnsafeNonAscii(
    String name,
    String value,
  ) {
    return apply((it) {
      it.headersCheckName(name);
      it._namesAndValues[name] = [value.trim()];
    });
  }

  HeadersBuilder commonAddAll(Headers headers) {
    return apply((it) {
      it._namesAndValues.addAll(headers._nameAndValues);
    });
  }

  HeadersBuilder commonSet(String name, dynamic value) => apply((it) {
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

  HeadersBuilder commonRemoveAll(String name) => apply((it) {
        it._namesAndValues.remove(name);
      });

  void headersCheckName(String name) {
    assert(name.isNotEmpty, "name is empty");
    for (var i = 0; i < name.length; i++) {
      final c = name[i].code;
      assert(
        c >= '\u0021'.code && c <= '\u007e'.code,
        "Unexpected char 0x${String.fromCharCode(c)} at $i in header name: $name",
      );
    }
  }

  Headers commonBuild() => Headers._(_namesAndValues);

  ArgumentError _valueError(dynamic value) => ArgumentError.value(
      value, "value", "must be DateTime, String or Iterable<String>");
}

final class _CommonBuilder extends HeadersBuilder {
  _CommonBuilder([Headers? headers]) : super(headers);
}

Headers _fromMap(Map<String, String> map) {
  final headers = caseInsensitiveKeyMap<List<String>>();
  map.forEach((key, value) {
    if (headers.containsKey(key)) {
      headers[key]!.add(value);
    } else {
      headers[key] = [value];
    }
  });
  return Headers._(headers);
}

extension on Headers {
  /// Returns the last value corresponding to the specified field, or null.
  String? commonGet(String name) => _nameAndValues[name]?.last;

  int get commonLength =>
      _nameAndValues.values.fold(0, (previousValue, element) {
        return previousValue + element.length;
      });

  /// Returns the last value corresponding to the specified field parsed as an HTTP date, or null if either the field is absent or cannot be parsed as a date.
  DateTime? commonGetDate(String name) =>
      commonGet(name)?.let((it) => DateTime.tryParse(it));

  String commonName(int index) => _nameAndValues.keys.elementAt(index);

  String commonValue(int index) => _nameAndValues.values.elementAt(index).first;

  Set<String> get commonNames => Set.unmodifiable(_nameAndValues.keys);

  List<String>? commonValues(String name) => _nameAndValues[name];

  void commonforEach(void Function(String name, List<String> value) action) {
    _nameAndValues.forEach(action);
  }

  String commonToString([bool list = false]) {
    if (list) {
      return toList().mapList((e) => '${e.first}: ${e.second}').toString();
    }
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

  Map<String, List<String>> commontoMap() {
    return _nameAndValues;
  }
}
