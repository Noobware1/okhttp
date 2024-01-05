class StringBuilder {
  String _string;
  StringBuilder(String string) : _string = string;

  void append(Object? s) {
    _string += s.toString();
  }

  }
