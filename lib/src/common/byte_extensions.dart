extension IntToByte on int {
  int toByte() {
    // If the most significant bit (bit 7) is set, indicating a negative number,
    // perform sign extension to get the correct negative value.
    int byte = this;
    if ((byte & 0x80) != 0) {
      byte = -((byte ^ 0xFF) + 1);
    }
    return byte;
  }
}
