// ignore_for_file: non_constant_identifier_names

import 'dart:async';
import 'dart:convert';

import 'package:http_parser/http_parser.dart';
import 'package:nice_dart/nice_dart.dart';
import 'package:okhttp/src/common/buffer.dart';
import 'package:okhttp/src/common/byte_extensions.dart';
import 'package:okhttp/src/common/stream_sink.dart';
import 'package:okhttp/src/common/string.dart';
import 'package:okhttp/src/common/uuid.dart';
import 'package:okhttp/src/headers.dart';
import 'package:okhttp/src/request_body.dart';
import 'package:okhttp/src/utils/utils.dart';

/// An [RFC 2387][rfc_2387]-compliant request body.
///
/// [rfc_2387]: http://www.ietf.org/rfc/rfc2387.txt
class MultipartBody extends RequestBody {
  MultipartBody._({
    required this.boundary,
    required this.parts,
    required MediaType contentType,
  })  : _contentType =
            '${contentType.toString()}; boundary=$boundary'.toMediaType(),
        _contentLength = -1;

  final String boundary;
  final List<Part> parts;

  List<int> get boundaryByteString => utf8.encode(boundary);

  late final int length = parts.length;

  int _contentLength;

  @override
  int get contentLength {
    var result = _contentLength;
    if (result == -1) {
      result = writeOrCountBytes(null, true);
      _contentLength = result;
    }
    return result;
  }

  final MediaType _contentType;

  @override
  MediaType get contentType => _contentType;

  Part part(int index) => parts[index];

  @override
  void writeTo(StreamSink<List<int>> sink) {
    writeOrCountBytes(sink, false);
  }

  @override
  String toString() {
    final buffer = Buffer();
    writeOrCountBytes(buffer, false);
    return buffer.toString();
  }

  static MultipartBodyBuilder Builder([String? boundary]) =>
      _MultipartBodyBuilder(boundary);

  /// Either writes this request to [sink] or measures its content length. We have one method do
  /// double-duty to make sure the counting and content are consistent, particularly when it comes
  /// to awkward operations like measuring the encoded length of header strings, or the
  /// length-in-digits of an encoded integer.
  int writeOrCountBytes(
    StreamSink<List<int>>? sink,
    bool countBytes,
  ) {
    var byteCount = 0;

    if (countBytes) {
      sink ??= Buffer();
    }
    final boundaryByteString = this.boundaryByteString;
    for (var p = 0; p < parts.length; p++) {
      final part = parts[p];
      final headers = part.headers;
      final body = part.body;

      sink?.write(_DASHDASH);
      sink?.write(boundaryByteString);
      sink?.write(_CRLF);

      if (headers != null) {
        for (var h = 0; h < headers.length; h++) {
          sink
            ?..writeUtf8(headers.name(h))
            ..write(_COLONSPACE)
            ..writeUtf8(headers.value(h))
            ..write(_CRLF);
        }
      }

      final contentType = body.contentType;
      if (contentType != null) {
        sink
          ?..writeUtf8("Content-Type: ")
          ..writeUtf8(contentType.toString())
          ..write(_CRLF);
      }

      // We can't measure the body's size without the sizes of its components.
      final contentLength = body.contentLength;
      if (contentLength == -1 && countBytes) {
        return -1;
      }

      sink?.write(_CRLF);

      if (countBytes) {
        byteCount += contentLength;
      } else {
        body.writeTo(sink!);
      }

      sink?.write(_CRLF);
    }

    sink
      ?..write(_DASHDASH)
      ..write(boundaryByteString)
      ..write(_DASHDASH)
      ..write(_CRLF);

    if (countBytes && sink is Buffer) {
      byteCount += sink.length;
    }

    return byteCount;
  }

  /// The "mixed" subtype of "multipart" is intended for use when the body parts are independent
  /// and need to be bundled in a particular order. Any "multipart" subtypes that an implementation
  /// does not recognize must be treated as being of subtype "mixed".
  static final MediaType MIXED = "multipart/mixed".toMediaType();

  /// The "multipart/alternative" type is syntactically identical to "multipart/mixed", but the
  /// semantics are different. In particular, each of the body parts is an "alternative" version of
  /// the same information.
  static final MediaType ALTERNATIVE = "multipart/alternative".toMediaType();

  /// This type is syntactically identical to "multipart/mixed", but the semantics are different.
  /// In particular, in a digest, the default `Content-Type` value for a body part is changed from
  /// "text/plain" to "message/rfc822".
  static final MediaType DIGEST = "multipart/digest".toMediaType();

  /// This type is syntactically identical to "multipart/mixed", but the semantics are different.
  /// In particular, in a parallel entity, the order of body parts is not significant.
  static final MediaType PARALLEL = "multipart/parallel".toMediaType();

  /// The media-type multipart/form-data follows the rules of all multipart MIME data streams as
  /// outlined in RFC 2046. In forms, there are a series of fields to be supplied by the user who
  /// fills out the form. Each field has a name. Within a given form, the names are unique.
  static final MediaType FORM = "multipart/form-data".toMediaType();
}

class Part {
  final Headers? headers;
  final RequestBody body;

  Part(this.headers, this.body) {
    assert(headers?.get("Content-Type") == null,
        "Unexpected header: Content-Type");
    assert(headers?.get("Content-Length") == null,
        "Unexpected header: Content-Length");
  }

  factory Part.createFormData(
    String name,
    RequestBody body, {
    String? filename,
  }) {
    final disposition = buildString((it) {
      it.write("form-data; name=");
      it.writeQuotedString(name);
      if (filename != null) {
        it.write("; filename=");
        it.writeQuotedString(filename);
      }
    });

    final headers = Headers.Builder()
        .addUnsafeNonAscii("Content-Disposition", disposition)
        .build();

    return Part(headers, body);
  }

  @override
  String toString() {
    return "Part(headers: ${headers?.toString(true) ?? 'null'}, body: $body)";
  }
}

class _MultipartBodyBuilder extends MultipartBodyBuilder {
  _MultipartBodyBuilder([String? boundary]) : super(boundary);
}

sealed class MultipartBodyBuilder {
  MultipartBodyBuilder([String? boundary]) {
    if (boundary == null) {
      _boundary = UUID.randomUUID().toString();
    } else {
      _boundary = boundary;
    }
  }

  late final String _boundary;
  MediaType _type = MultipartBody.MIXED;
  final List<Part> _parts = [];

  /// Set the MIME type. Expected values for `type` are [MIXED] (the default), [ALTERNATIVE],
  /// [DIGEST], [PARALLEL] and [FORM].
  MultipartBodyBuilder setType(MediaType type) {
    return apply((it) {
      assert(type.type == "multipart", "multipart != $type");
      it._type = type;
    });
  }

  /// Add a part to the body.
  MultipartBodyBuilder addPart(RequestBody body, [Headers? headers]) {
    return apply((it) {
      it.addToPart(Part(headers, body));
    });
  }

  /// Add a form data part to the body.
  MultipartBodyBuilder addFormDataPart(
    String name,
    String value, {
    String? filename,
  }) {
    return apply((it) {
      it.addToPart(Part.createFormData(name, RequestBody.fromString(value),
          filename: filename));
    });
  }

  /// Add a part to the body.
  MultipartBodyBuilder addToPart(Part part) {
    return apply((it) {
      it._parts.add(part);
    });
  }

  /// Assemble the specified parts into a request body.
  MultipartBody build() {
    assert(_parts.isNotEmpty, "Multipart body must have at least one part.");
    return MultipartBody._(
      boundary: _boundary,
      parts: List.unmodifiable(_parts),
      contentType: _type,
    );
  }
}

final _COLONSPACE = [':'.code.toByte(), ' '.code.toByte()];
final _CRLF = ['\r'.code.toByte(), '\n'.code.toByte()];
final _DASHDASH = ['-'.code.toByte(), '-'.code.toByte()];

extension on StringSink {
  /// Appends a quoted-string to a StringBuilder.
  ///
  /// RFC 2388 is rather vague about how one should escape special characters in form-data
  /// parameters, and as it turns out Firefox and Chrome actually do rather different things, and
  /// both say in their comments that they're not really sure what the right approach is. We go
  /// with Chrome's behavior (which also experimentally seems to match what IE does), but if you
  /// actually want to have a good chance of things working, please avoid double-quotes, newlines,
  /// percent signs, and the like in your field names.

  void writeQuotedString(String key) {
    write('"');
    for (var i = 0; i < key.length; i++) {
      final ch = key[i];
      switch (ch) {
        case '\n':
          write("%0A");
          break;
        case '\r':
          write("%0D");
          break;
        case '"':
          write("%22");
          break;
        default:
          write(ch);
          break;
      }
    }
    write('"');
  }
}
