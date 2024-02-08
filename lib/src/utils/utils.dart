// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'dart:convert';
import 'dart:typed_data';

import 'package:nice_dart/nice_dart.dart';
import 'package:http_parser/http_parser.dart';
import 'package:okhttp/src/common/string.dart';

/// Returns the encoding to use for a response with the given headers.
///
/// Defaults to [latin1] if the headers don't specify a charset or if that
/// charset is unknown.
Encoding encodingForContentType(MediaType? contentType) =>
    encodingForCharset(contentType?.parameters['charset']);

/// Returns the encoding to use for a response with the given headers.
///
/// Defaults to [latin1] if the headers don't specify a charset or if that
/// charset is unknown.
Encoding encodingForHeaders(Map<String, String> headers) =>
    encodingForCharset(contentTypeForHeaders(headers).parameters['charset']);

/// Returns the [Encoding] that corresponds to [charset].
///
/// Returns [fallback] if [charset] is null or if no [Encoding] was found that
/// corresponds to [charset].
Encoding encodingForCharset(String? charset, [Encoding fallback = latin1]) {
  if (charset == null) return fallback;
  return Encoding.getByName(charset) ?? fallback;
}

/// Returns the [Encoding] that corresponds to [charset].
///
/// Throws a [FormatException] if no [Encoding] was found that corresponds to
/// [charset].
Encoding requiredEncodingForCharset(String charset) =>
    Encoding.getByName(charset) ??
    (throw FormatException('Unsupported encoding "$charset".'));

/// Returns the [MediaType] object for the given headers's content-type.
///
/// Defaults to `application/octet-stream`.
MediaType contentTypeForHeaders(Map<String, String> headers) {
  var contentType = headers['content-type'];
  if (contentType != null) return MediaType.parse(contentType);
  return MediaType('application', 'octet-stream');
}

extension DelimiterOffset on String {
  /// Returns the  of the first character in this string that contains a character in
  /// [delimiters]. Returns end if there is no such character.
  int delimiterOffset({
    required String delimiters,
    int start = 0,
    int? end,
  }) {
    end ??= length;
    for (var i = start; i < end; i++) {
      if (delimiters.contains(this[i])) return i;
    }
    return end;
  }

  /// Returns the  of the first character in this string that is [delimiter]. Returns [end]
  /// if there is no such character.
  int delimiterOffsetChar({
    required String delimiter,
    int start = 0,
    int end = -1,
  }) {
    assert(delimiter.length == 1);
    end = end == -1 ? length : end;
    for (var i = start; i < end; i++) {
      if (this[i] == delimiter) return i;
    }
    return end;
  }
}

extension Uint8ListExtension on Uint8List {
  String string([Encoding? encoding]) {
    if (encoding != null) return encoding.decode(this);
    return String.fromCharCodes(this);
  }

  String base64Url() => Base64Codec.urlSafe().encode(this);
}

extension Base64Url on String {
  /// Returns a base64-encoded version of this string encoded in UTF-8.
  String base64Url() => Base64Codec.urlSafe().encode(utf8.encode(this));
}

extension ToMediaType on String {
  /// Returns the media type for this string.
  MediaType toMediaType() => MediaType.parse(this);
}

extension ToMediaTypeorNull on String? {
  /// Returns the media type for this string or null.
  MediaType? toMediaTypeOrNull() => this?.let((it) => MediaType.parse(it));
}

extension TrimSubString on String {
  /// Returns a substring of this string that removes characters from the beginning and end of the
  /// string that are equal to [delimiter].
  String trimSubstring(int start, [int? end]) {
    end ??= length;
    final _start = indexOfFirstNonAsciiWhitespace(start, end);
    final _end = indexOfLastNonAsciiWhitespace(start, end);
    return substring(_start, _end);
  }
}

extension OfControlOrNonAscii on String {
  /// Returns the  of the first character in this string that is either a control character (like
  /// `\u0000` or `\n`) or a non-ASCII character. Returns -1 if this string has no such characters.
  int get indexOfControlOrNonAscii {
    for (var i = 0; i < length; i++) {
      final c = this[i].code;
      if (c <= '\u001f'.code || c >= '\u007f'.code) {
        // break;
        return i;
      }
    }
    return -1;
  }

  ///   Increments [start] until this string is not ASCII whitespace. Stops at [end].
  int indexOfFirstNonAsciiWhitespace([int start = 0, int? end]) {
    end ??= length;
    for (int i = start; i < end; i++) {
      switch (this[i]) {
        case '\t':
        case '\n':
        case '\u000C':
        case '\r':
        case ' ':
          break;
        default:
          return i;
      }
    }

    return start;
  }

  /// Decrements [end] until `input[end - 1]` is not ASCII whitespace. Stops at [start].
  int indexOfLastNonAsciiWhitespace([int start = 0, int? end]) {
    end ??= length;

    for (int i = end - 1; i >= start; i--) {
      switch (this[i]) {
        case '\t':
        case '\n':
        case '\u000C':
        case '\r':
        case ' ':
          break;
        default:
          return i + 1;
      }
    }

    return start;
  }
}
