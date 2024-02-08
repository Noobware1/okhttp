import 'dart:io';
import 'dart:math';

import 'package:nice_dart/nice_dart.dart';
import 'package:okhttp/src/internet_socket_address.dart';
import 'package:okhttp/src/proxy.dart';

class Route {
  final InternetAddress address;

  final Proxy proxy;
  final InternetSocketAddress socketAddress;

  Route(this.address, this.proxy, this.socketAddress);

  /// Returns true if this route tunnels HTTPS or HTTP/2 through an HTTP proxy.
  /// See [RFC 2817, Section 5.2][rfc_2817].
  ///
  /// [rfc_2817]: http://www.ietf.org/rfc/rfc2817.txt
  bool requiresTunnel() {
    if (proxy.type != ProxyType.HTTP) return false;

    return true;

    // return (address.sslSocketFactory != null) ||
    //   (Protocol.H2_PRIOR_KNOWLEDGE in address.protocols)
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Route &&
          runtimeType == other.runtimeType &&
          address == other.address &&
          proxy == other.proxy &&
          socketAddress == other.socketAddress;

  @override
  int get hashCode =>
      address.hashCode ^ proxy.hashCode ^ socketAddress.hashCode;

  /// Returns a string with the URL hostname, socket IP address, and socket port, like one of these:
  ///
  ///  * `example.com:80 at 1.2.3.4:8888`
  /// * `example.com:443 via proxy [::1]:8888`
  ///
  /// This omits duplicate information when possible.
  @override
  String toString() {
    return buildString((it) {
      final addressHostname = address.host; // Already in canonical form.
      final socketHostname = socketAddress.address?.host;
      if (addressHostname.contains(':')) {
        it.write('[');
        it.write(addressHostname);
        it.write(']');
      } else {
        it.write(addressHostname);
      }
      if (address.url.port != socketAddress.port ||
          addressHostname == socketHostname) {
        it.write(":");
        it.write(address.url.port);
      }

      if (addressHostname != socketHostname) {
        if (proxy == Proxy.NO_PROXY) {
          it.write(' at ');
        } else {
          it.write(' via proxy ');
        }

        if (socketHostname == null) {
          it.write('<unresolved>');
        } else if (socketHostname.contains(':')) {
          it.write('[');
          it.write(socketHostname);
          it.write(']');
        } else {
          it.write(socketHostname);
        }

        it.write(':');
        it.write(socketAddress.port);
      }
    });
  }
}

extension on InternetAddress {
  Uri get url => Uri.parse(address);
}
