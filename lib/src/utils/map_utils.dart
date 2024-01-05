import 'dart:convert';

extension MapExtensions<K, V> on Map<K, V> {
  String mapToQuery({required Encoding encoding}) {
    if (this is! Map<String, String>) {
      throw ArgumentError.value(this, 'map', 'Must be a Map<String, String>');
    }
    return entries
        .map((e) =>
            '${Uri.encodeQueryComponent(e.key as String, encoding: encoding)}'
            '=${Uri.encodeQueryComponent(e.value as String, encoding: encoding)}')
        .join('&');
  }
}
