extension ToQueryList on List<String?> {
  String toQueryString(String outputString) {
    for (var i = 0; i < length; i++) {
      final key = this[i].toString();
      final value = this[i + 1];
      if (i > 0) outputString += ('&');
      outputString += key;
      if (value != null) {
        outputString += '=';
        outputString += value;
      }
    }
    return outputString;
  }
  //  internal fun List<String?>.toQueryString(out: StringBuilder) {
  //   for (i in 0 until size step 2) {
  //     val name = this[i]
  //     val value = this[i + 1]
  //     if (i > 0) out.append('&')
  //     out.append(name)
  //     if (value != null) {
  //       out.append('=')
  //       out.append(value)
  //     }
  //   }
  // }
}
