import 'package:http_parser/http_parser.dart';
import 'package:ok_http/src/common/string.dart';
import 'package:ok_http/src/request_body.dart';

class FormBody extends RequestBody {
  FormBody() : super(MediaType.parse('application/x-www-form-urlencoded'));

  @override
  int get contentLength => toString().length;

  final List<String> _names = [];
  final List<String> _values = [];

  void add(String name, String value) {
    _names.add(name.canonicalizeWithCharset(charset: encoding));
    _values.add(value.canonicalizeWithCharset(charset: encoding));
  }

  String name(int index) {
    return _names[index].percentDecode();
  }

  String value(int index) {
    return _values[index].percentDecode();
  }

  int get length => _names.length;

  @override
  String toString() {
    final StringSink buffer = StringBuffer();

    for (var i = 0; i < _names.length; i++) {
      if (i > 0) buffer.writeCharCode('&'.code);
      buffer.write(_names[i]);
      buffer.writeCharCode('='.code);
      buffer.write(_values[i]);
    }
    return buffer.toString();
  }
}
