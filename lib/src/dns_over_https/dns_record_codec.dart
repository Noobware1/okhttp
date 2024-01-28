import 'dart:convert';
import 'dart:typed_data';

class DnsRecordCodec {
  static Uint8List encodeQuery(String host, int type) {
    ByteData byteData = ByteData(512); // Adjust the size based on your needs
    int offset = 0;

    byteData.setInt16(offset, 0); // query id
    offset += 2;
    byteData.setInt16(offset, 256); // flags with recursion
    offset += 2;
    byteData.setInt16(offset, 1); // question count
    offset += 2;
    byteData.setInt16(offset, 0); // answerCount
    offset += 2;
    byteData.setInt16(offset, 0); // authorityResourceCount
    offset += 2;
    byteData.setInt16(offset, 0); // additional
    offset += 2;

    List<String> labels =
        host.split('.').where((label) => label.isNotEmpty).toList();
    for (String label in labels) {
      int utf8ByteCount = utf8.encode(label).length;
      assert(utf8ByteCount == label.length, "non-ascii hostname: $host");
      byteData.setInt8(offset, utf8ByteCount);
      offset++;
      List<int> labelBytes = utf8.encode(label);
      for (int byte in labelBytes) {
        byteData.setInt8(offset, byte);
        offset++;
      }
    }

    byteData.setInt8(offset, 0); // end
    offset++;

    Uint8List result = byteData.buffer.asUint8List(0, offset);

    return result;
  }
}
