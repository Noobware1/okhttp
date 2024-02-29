import 'dart:io';

class InternetSocketAddress {
  final _InternetSocketAddressHolder _holder;

  String get hostName => _holder.getHostString ?? '0.0.0';

  InternetAddress? get address => _holder._addr;

  int get port => _holder._port;

  bool get isUnresolved => _holder.isUnresolved;

  InternetSocketAddress._(this._holder);

  static Future<InternetSocketAddress> fromHost(
      String hostname, int port) async {
    _checkHost(hostname);
    InternetAddress? addr;
    String? host;
    try {
      addr = await _getByName(hostname);
    } catch (e) {
      host = hostname;
    }
    return InternetSocketAddress._(
        _InternetSocketAddressHolder(host, addr, _checkPort(port)));
  }

  static InternetSocketAddress fromPort(int port) {
    return fromAddress(InternetAddress.anyIPv4, port);
  }

  static InternetSocketAddress fromAddress(InternetAddress? address, int port) {
    return InternetSocketAddress._(
        _InternetSocketAddressHolder(null, address, port));
  }

  static int _checkPort(int port) {
    if (port < 0 || port > 0xFFFF) {
      throw ArgumentError("port out of range: $port");
    }
    return port;
  }

  static String _checkHost(String? hostname) {
    if (hostname == null) throw ArgumentError("hostname can't be null");
    return hostname;
  }

  static Future<InternetAddress> _getByName(String host) {
    return InternetAddress.lookup(host).then((value) => value[0]);
  }

  @override
  String toString() {
    return _holder.toString();
  }
}

class _InternetSocketAddressHolder {
  // The hostname of the Socket Address
  final String? _hostname;
  // The IP address of the Socket Address
  final InternetAddress? _addr;
  // The port number of the Socket Address
  final int _port;

  _InternetSocketAddressHolder(
      String? hostname, InternetAddress? addr, int port)
      : _hostname = hostname,
        _addr = addr,
        _port = port;

  String? get getHostString {
    if (_hostname != null) return _hostname!;
    if (_addr != null) {
      return _addr!.host;
    }
    return null;
  }

  bool get isUnresolved => _addr == null;

  @override
  String toString() {
    String formatted;

    if (isUnresolved) {
      formatted = "${_hostname ?? ""}/<unresolved>";
    } else {
      formatted = _addr.toFormattedString();
      if (_addr?.type == InternetAddressType.IPv6) {
        int i = formatted.lastIndexOf("/");
        formatted =
            "${formatted.substring(0, i + 1)}[${formatted.substring(i + 1)}]";
      }
    }
    return "$formatted:$_port";
  }
}

extension on InternetAddress? {
  String toFormattedString() {
    if (this == null) return "";
    return "${this!.host}/${this!.address}";
  }
}
