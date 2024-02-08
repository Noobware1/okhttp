//  private fun Proxy.connectToInetAddress(
//     url: HttpUrl,
//     dns: Dns,
//   ): InetAddress {
//     return when (type()) {
//       Proxy.Type.DIRECT -> dns.lookup(url.host).first()
//       else -> (address() as InetSocketAddress).address
//     }
//   }

import 'dart:io';

import 'package:okhttp/src/dns.dart';
import 'package:okhttp/src/internet_socket_address.dart';
import 'package:okhttp/src/proxy.dart';

extension ProxyCommon on Proxy {
  Future<InternetAddress> connectToInetAddress(
    Uri url,
    Dns dns,
  ) async {
    switch (type) {
      case ProxyType.DIRECT:
        return (await dns.lookup(url.host)).first;
      default:
        return (address as InternetSocketAddress).address!;
    }
  }
}
