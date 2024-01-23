

///
/// Quick and dirty pattern to differentiate IP addresses from hostnames. This is an approximation
/// of Android's private InetAddress#isNumeric API.
///
/// This matches IPv6 addresses as a hex string containing at least one colon, and possibly
/// including dots after the first colon. It matches IPv4 addresses as strings containing only
/// decimal digits and dots. This pattern matches strings like "a:.23" and "54" that are neither IP
/// addresses nor hostnames; they will be verified as IP addresses (which is a more strict
/// verification).
///
// ignore_for_file: unused_element

final _VERIFY_AS_IP_ADDRESS = RegExp("([0-9a-fA-F]*:[0-9a-fA-F:.]*)|([\\d.]+)");

extension HostNameCommonsOnString on String {
  /// Returns true if this string is not a host name and might be an IP address.
  bool get canParseAsIpAddress => _VERIFY_AS_IP_ADDRESS.hasMatch(this);

  /// If this is an IP address, this returns the IP address in canonical form.
  ///
  /// Otherwise, this performs IDN ToASCII encoding and canonicalize the result to lowercase. For
  /// example this converts `☃.net` to `xn--n3h.net`, and `WwW.GoOgLe.cOm` to `www.google.com`.
  /// `null` will be returned if the host cannot be ToASCII encoded or if the result contains
  /// unsupported ASCII characters.
  String toCanonicalHost() {
    final String host = this;

    // If the input contains a :, it’s an IPv6 address.
    if (host.contains(":")) {
      // If the input is encased in square braces "[...]", drop 'em.
      final inetAddressByteArray = (host.startsWith("[") && host.endsWith("]"))
          ? Uri.parseIPv6Address(host, 1, host.length - 1)
          : Uri.parseIPv6Address(host, 0, host.length);

      final address = canonicalizeInetAddress(inetAddressByteArray);
      //   if (address.size == 16) return inet6AddressToAscii(address)
      //   if (address.size == 4) return inet4AddressToAscii(address) // An IPv4-mapped IPv6 address.
      //   throw AssertionError("Invalid IPv6 address: '$host'")
      // }

      // val result = idnToAscii(host) ?: return null
      // if (result.isEmpty()) return null
      // if (result.containsInvalidHostnameAsciiCodes()) return null
      // if (result.containsInvalidLabelLengths()) return null

      // return result
    }
    return '';
  }

  /// Returns the canonical address for [address]. If [address] is an IPv6 address that is mapped to an
  /// IPv4 address, this returns the IPv4-mapped address. Otherwise, this returns [address].
  ///
  /// https://en.wikipedia.org/wiki/IPv6#IPv4-mapped_IPv6_addresses
  List<int> canonicalizeInetAddress(List<int> address) {
    return isMappedIpv4Address(address) ? address.sublist(12, 16) : address;
  }

  /// Returns true for IPv6 addresses like `0000:0000:0000:0000:0000:ffff:XXXX:XXXX`.
  bool isMappedIpv4Address(List<int> address) {
    if (address.length != 16) return false;
    for (var i = 0; i < 10; i++) {
      if (address[i] != 0) return false;
    }

    if (address[10] != -1) return false;
    if (address[11] != -1) return false;

    return true;
  }
}
