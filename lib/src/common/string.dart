import 'dart:convert';

import 'package:okhttp/src/common/url_common.dart';
import 'package:okhttp/src/utils/utils.dart';

extension StringCommon on String {
  int get code => codeUnitAt(0);

  ///
  /// Returns a substring of `input` on the range `[pos..limit)` with the following
  /// transformations:
  ///
  /// Tabs, newlines, form feeds and carriage returns are skipped.
  ///
  /// In queries, ' ' is encoded to '+' and '+' is encoded to "%2B".
  ///
  /// Characters in `encodeSet` are percent-encoded.
  ///
  /// Control characters and non-ASCII characters are percent-encoded.
  ///
  /// All other characters are copied without transformation.
  ///
  /// * alreadyEncoded true to leave '%' as-is; false to convert it to '%25'.
  /// * strict true to encode '%' if it is not the prefix of a valid percent encoding.
  /// * plusIsSpace true to encode '+' as "%2B" if it is not already encoded.
  /// * unicodeAllowed true to leave non-ASCII codepoint unencoded.
  /// * charset which charset to use, null equals UTF-8.
  ///
  String canonicalizeWithCharset(
      {int pos = 0,
      bool alreadyEncoded = false,
      bool strict = false,
      bool plusIsSpace = false,
      bool unicodeAllowed = false,
      Encoding? charset}) {
    return Uri.encodeComponent(this).split('').map((element) {
      if (percentEncodeValues.containsKey(element)) {
        return percentEncodeValues[element]!;
      }
      return element;
    }).join('');
  }

  static const percentEncodeValues = {
    '\'': '%27',
    '!': '%21',
    '~': '%7E',
    '(': '%28',
    ')': '%29',
  };

  String percentDecode() {
    return Uri.decodeComponent(this);
  }

  String removePrefix(String prefix) {
    if (startsWith(prefix)) {
      return substring(prefix.length);
    }
    return this;
  }
}
