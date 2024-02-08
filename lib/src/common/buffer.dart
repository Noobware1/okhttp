import 'dart:async';
import 'dart:convert';

/// A Common interface to avoid annoying type checks
class Buffer implements StreamSink<List<int>> {
  final List<int> _buffer = [];

  int get length => _buffer.length;

  @override
  String toString() {
    return utf8.decode(_buffer);
  }

  @override
  void add(List<int> event) {
    _buffer.addAll(event);
  }

  @override
  void addError(Object error, [StackTrace? stackTrace]) {
    throw UnsupportedError('this is a stub');
  }

  @override
  Future addStream(Stream<List<int>> stream) {
    // TODO: implement addStream
    throw UnsupportedError('this is a stub');
  }

  @override
  Future close() async {
    _buffer.clear();
  }

  @override
  Future get done => throw UnsupportedError('this is a stub');
}
