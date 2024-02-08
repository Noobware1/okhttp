// ignore_for_file: constant_identifier_names

import 'package:okhttp/src/utils/utils.dart';

const USERNAME_ENCODE_SET = " \"':;<=>@[]^`{}|/\\?#";
const PASSWORD_ENCODE_SET = " \"':;<=>@[]^`{}|/\\?#";
const PATH_SEGMENT_ENCODE_SET = " \"<>^`{}|/\\?#";
const PATH_SEGMENT_ENCODE_SET_URI = "[]";
const QUERY_ENCODE_SET = " \"'<>#";
const QUERY_COMPONENT_REENCODE_SET = " \"'<>#&=";
const QUERY_COMPONENT_ENCODE_SET = " !\"#\$&'(),/:;<=>?@[]\\^`{|}~";
const QUERY_COMPONENT_ENCODE_SET_URI = "\\^`{|}";
const FORM_ENCODE_SET = " !\"#\$&'()+,/:;<=>?@[\\]^`{|}~";
const FRAGMENT_ENCODE_SET = "";
const FRAGMENT_ENCODE_SET_URI = " \"#<>\\^`{|}";

extension UrlCommonOnUri on Uri {
  // resolvePath({
  //   required String input,
  //   required int startPos,
  //   required int limit,
  //  }) {
  //   var pos = startPos;
  //   // Read a delimiter.
  //   if (pos == limit) {
  //     // Empty path: keep the base path as-is.
  //     return;
  //   }
  //   final  c = input[pos]
  //  ; if (c == '/' || c == '\\') {
  //     // Absolute path: reset to the default "/".
  //     encodedPathSegments.clear()
  //     encodedPathSegments.add("")
  //     pos++
  //   } else {
  //     // Relative path: clear everything after the last '/'.
  //     encodedPathSegments[encodedPathSegments.size - 1] = ""
  //   }

  //   // Read path segments.
  //   var i = pos;
  //   while (i < limit) {
  //     val pathSegmentDelimiterOffset = input.delimiterOffset("/\\", i, limit)
  //     val segmentHasTrailingSlash = pathSegmentDelimiterOffset < limit
  //     push(input, i, pathSegmentDelimiterOffset, segmentHasTrailingSlash, true)
  //     i = pathSegmentDelimiterOffset
  //     if (segmentHasTrailingSlash) i++
  //   }
  // }

  bool get isHttps => scheme == "https";

  List<String> get encodedPathSegments {
    final url = toString();
    final pathStart = url.indexOf('/', scheme.length + 3);
    final pathEnd = url.delimiterOffset(
        delimiters: "?#", start: pathStart, end: url.length);
    final result = <String>[];
    var i = pathStart;
    while (i < pathEnd) {
      i++; // Skip the '/'.
      final segmentEnd =
          url.delimiterOffset(delimiters: '/', start: i, end: pathEnd);
      result.add(url.substring(i, segmentEnd));
      i = segmentEnd;
    }
    return result;
  }

  String get encodedPath => encodedPathSegments.join("/");
}
