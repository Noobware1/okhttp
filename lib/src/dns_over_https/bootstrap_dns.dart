import 'dart:io';

import 'package:okhttp/src/dns.dart';

/// Internal Bootstrap DNS implementation for handling initial connection to DNS over HTTPS server.
///
/// Returns hardcoded results for the known host.
class BootstrapDns extends Dns {
  BootstrapDns(
    this._dnsHostname,
    this._dnsServers,
  );

  final String _dnsHostname;
  final List<InternetAddress> _dnsServers;

  @override
  Future<List<InternetAddress>> lookup(String hostname) async {
    if (_dnsHostname != hostname) {
      throw UnknownHostException(
        "BootstrapDns called for $hostname instead of $_dnsHostname",
      );
    }
    return _dnsServers;
  }
}
