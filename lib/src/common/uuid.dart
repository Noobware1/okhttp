import 'dart:math';
import 'dart:typed_data';

class UUID {
  UUID._(this._bytes);

  final List<int> _bytes;

  factory UUID.randomUUID() {
    // Use the built-in RNG or a custom provided RNG
    List<int> rng = CryptoRNG().generate();

    // per 4.4, set bits for version and clockSeq high and reserved
    rng[6] = (rng[6] & 0x0f) | 0x40;
    rng[8] = (rng[8] & 0x3f) | 0x80;

    return UUID._(rng);
  }

  /// Unparses a [buffer] of bytes and outputs a proper UUID string.
  /// An optional [offset] is allowed if you want to start at a different point
  /// in the buffer.
  ///
  /// Throws a [RangeError] exception if the [buffer] is not large enough to
  /// hold the bytes. That is, if the length of the [buffer] after the [offset]
  /// is less than 16.
  static String unparse(List<int> buffer, {int offset = 0}) {
    if (buffer.length - offset < 16) {
      throw RangeError('buffer too small: need 16: length=${buffer.length}'
          '${offset != 0 ? ', offset=$offset' : ''}');
    }
    var i = offset;
    return '${_byteToHex[buffer[i++]]}${_byteToHex[buffer[i++]]}'
        '${_byteToHex[buffer[i++]]}${_byteToHex[buffer[i++]]}-'
        '${_byteToHex[buffer[i++]]}${_byteToHex[buffer[i++]]}-'
        '${_byteToHex[buffer[i++]]}${_byteToHex[buffer[i++]]}-'
        '${_byteToHex[buffer[i++]]}${_byteToHex[buffer[i++]]}-'
        '${_byteToHex[buffer[i++]]}${_byteToHex[buffer[i++]]}'
        '${_byteToHex[buffer[i++]]}${_byteToHex[buffer[i++]]}'
        '${_byteToHex[buffer[i++]]}${_byteToHex[buffer[i++]]}';
  }

  /// Easy number -> hex conversion
  static final List<String> _byteToHex = List<String>.generate(256, (i) {
    return i.toRadixString(16).padLeft(2, '0');
  });

  @override
  String toString() {
    return unparse(_bytes);
  }
}

abstract class RNG {
  const RNG();

  Uint8List generate() {
    final uint8list = generateInternal();
    if (uint8list.length != 16) {
      throw Exception(
          'The length of the Uint8list returned by the custom RNG must be 16.');
    } else {
      return uint8list;
    }
  }

  Uint8List generateInternal();
}

/// Crypto-Strong RNG. All platforms, unknown speed, cryptographically strong
/// (theoretically)
class CryptoRNG extends RNG {
  static final _secureRandom = Random.secure();

  @override
  Uint8List generateInternal() {
    final b = Uint8List(16);

    for (var i = 0; i < 16; i += 4) {
      var k = _secureRandom.nextInt(pow(2, 32).toInt());
      b[i] = k;
      b[i + 1] = k >> 8;
      b[i + 2] = k >> 16;
      b[i + 3] = k >> 24;
    }

    return b;
  }
}
