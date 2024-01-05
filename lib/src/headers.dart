import 'package:ok_http/src/common/map.dart';
import 'package:ok_http/src/common/string.dart';

class Headers extends CommonMap<String, String> {
  Headers() : super(caseInsensitiveKeyMap());

  String name(int index) => keys.elementAt(index);

  String value(int index) => values.elementAt(index);

  @override
  String toString() {
    final StringBuffer sb = StringBuffer();
    for (var i = 0; i < length; i++) {
      final name = this.name(i);
      final value = this.value(i);
      sb.write(name);
      sb.write(": ");
      sb.write(value);
      if (i != length - 1) {
        sb.write("\n");
      }
    }
    return sb.toString();
  }

  List<String> getNames(String name) {
    final result = <String>[];
    for (var i = 0; i < length; i++) {
      if (name.equals(this.name(i), ignoreCase: true)) {
        result.add(this.name(i));
      }
    }
    return result;
  }

  List<String> getValues(String name) {
    final result = <String>[];
    for (var i = 0; i < length; i++) {
      if (name.equals(this.name(i), ignoreCase: true)) {
        result.add(value(i));
      }
    }
    return result;
  }
}
