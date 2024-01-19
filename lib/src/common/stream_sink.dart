import 'dart:async';
import 'dart:convert';

extension StreamSinkExtensions on StreamSink<List<int>> {
  void writeCharCode(int charCode) {
    return add([charCode]);
  }

  void writeUtf8(String string) {
    return add(utf8.encode(string));
  }
}
