// ignore_for_file: prefer_initializing_formals, unnecessary_this, constant_identifier_names

import 'package:okhttp/src/auth.dart';
import 'package:okhttp/src/internet_socket_address.dart';

enum ProxyType {
  /// Represents a direct connection, or the absence of a proxy.
  DIRECT,

  /// Represents proxy for high level protocols such as HTTP or FTP.
  HTTP,

  /// Represents a SOCKS (V4 or V5) proxy.
  SOCKS;

  @override
  String toString() {
    return super.toString().split('.').last;
  }
}

class Proxy {
  final ProxyType _type;
  final InternetSocketAddress? _sa;
  final PasswordAuthentication? _auth;

  /// A proxy setting that represents a {@code DIRECT} connection,
  /// basically telling the protocol handler not to use any proxying.
  /// Used, for instance, to create sockets bypassing any other global
  /// proxy settings (like SOCKS):
  /// <P>
  /// {@code Socket s = new Socket(Proxy.NO_PROXY);}
  ///
  static const Proxy NO_PROXY = Proxy();

  // Creates the proxy that represents a {@code DIRECT} connection.
  const Proxy(
      {ProxyType? type,
      InternetSocketAddress? sa,
      PasswordAuthentication? auth})
      : _type = type ?? ProxyType.DIRECT,
        _sa = sa,
        _auth = auth;

  /// Returns the proxy type.
  ProxyType get type => _type;

  /// Returns the socket address of the proxy, or {@code null} if its a
  /// direct connection.
  /// @return a {@code SocketAddress} representing the socket end point of the proxy.
  InternetSocketAddress? get address => _sa;

  String? get userName => _auth?.userName;

  String? get password => _auth?.password;

  @override
  String toString() {
    if (type == ProxyType.DIRECT) return "DIRECT";
    return "$type @ $address";
  }
}
