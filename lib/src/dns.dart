// ignore_for_file: constant_identifier_names

import 'dart:io';

///
/// A domain name service that resolves IP addresses for host names. Most applications will use the
/// [system DNS service][SYSTEM], which is the default. Some applications may provide their own
/// implementation to use a different DNS server, to prefer IPv6 addresses, to prefer IPv4 addresses,
/// or to force a specific known IP address.
///
/// Implementations of this interface must be safe for concurrent use.
///
abstract class Dns {
  const Dns();

  ///
  /// Returns the IP addresses of `hostname`, in the order they will be attempted by OkHttp. If a
  /// connection to an address fails, OkHttp will retry the connection with the next address until
  /// either a connection is made, the set of IP addresses is exhausted, or a limit is exceeded.
  ///
  /// @throws UnknownHostException if the host name could not be resolved.
  ///
  Future<List<InternetAddress>> lookup(String hostname);

  static const SYSYTEM = DnsSystem();
}

class DnsSystem extends Dns {
  const DnsSystem();

  ///
  /// A DNS that uses [InternetAddress.lookup] to ask the underlying operating system to
  /// lookup IP addresses. Most custom [Dns] implementations should delegate to this instance.
  ///
  @override
  Future<List<InternetAddress>> lookup(String hostname) async {
    try {
      return await InternetAddress.lookup(hostname);
    } catch (e) {
      throw UnknownHostException(
          "Broken system behaviour for dns lookup of $hostname");
    }
  }
}

class UnknownHostException implements Exception {
  final String cause;
  UnknownHostException(this.cause);

  @override
  String toString() {
    return 'UnknownHostException: $cause';
  }
}
