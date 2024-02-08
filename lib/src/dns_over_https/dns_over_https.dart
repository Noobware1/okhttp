// ignore_for_file: non_constant_identifier_names

import 'dart:io';
import 'dart:typed_data';

import 'package:nice_dart/nice_dart.dart';
import 'package:okhttp/src/call.dart';
import 'package:okhttp/src/dns.dart';
import 'package:okhttp/src/dns_over_https/bootstrap_dns.dart';
import 'package:okhttp/src/dns_over_https/dns_record_codec.dart';
import 'package:okhttp/src/expections/okhttp_exception.dart';
import 'package:okhttp/src/okhttp_client.dart';
import 'package:okhttp/src/request.dart';
import 'package:okhttp/src/request_body.dart';
import 'package:okhttp/src/response.dart';
import 'package:okhttp/src/utils/utils.dart';

class DnsOverHttps extends Dns {
  final Uri url;
  final bool post;
  final OkHttpClient client;

  final bool includeIPv6;
  final bool resolvePrivateAddresses;
  final bool resolvePublicAddresses;
  DnsOverHttps._({
    required this.url,
    required this.post,
    required this.client,
    required this.includeIPv6,
    required this.resolvePrivateAddresses,
    required this.resolvePublicAddresses,
  });

  void _buildRequest(
    String hostname,
    List<Call> networkRequests,
    List<InternetAddress> results,
    List<Exception> failures,
    int type,
  ) {
    final request = __buildRequest(hostname, type);
    networkRequests.add(client.newCall(request));
  }

  Request __buildRequest(String hostname, int type) {
    final request =
        Request.Builder().url(url).header('Accept', DNS_MESSAGE.toString());

    final query = DnsRecordCodec.encodeQuery(hostname, type);
    if (post) {
      request.post(RequestBody.fromString(query.string(), DNS_MESSAGE));
    } else {
      final encoded = query.base64Url().replaceAll("=", "");
      request.get();
      request.addQueryParameter("dns", encoded);
    }

    return request.build();
  }

  Future<List<InternetAddress>> _lookupHttps(String hostname) async {
    final List<Call> networkRequests = []; //FixedLengthList(2);
    final List<Exception> failures = []; //FixedLengthList(2);
    final List<InternetAddress> results = []; //FixedLengthList(5);

    _buildRequest(
        hostname, networkRequests, results, failures, DnsRecordCodec.TYPE_A);

    if (includeIPv6) {
      _buildRequest(hostname, networkRequests, results, failures,
          DnsRecordCodec.TYPE_AAAA);
    }

    await _executeRequests(hostname, networkRequests, results, failures);

    return results.isEmpty ? _throwBestFailure(hostname, failures) : results;
  }

  Future<void> _executeRequests(
    String hostname,
    List<Call> networkRequests,
    List<InternetAddress> responses,
    List<Exception> failures,
  ) async {
    for (var call in networkRequests) {
      try {
        final response = await call.execute();
        _processResponse(response, hostname, responses, failures);
      } catch (e, s) {
        failures.add(e is Exception ? e : Exception(e.toString()));
      }
    }
  }

  List<InternetAddress> _throwBestFailure(
    String hostname,
    List<Exception> failures,
  ) {
    if (failures.isEmpty) {
      throw UnknownHostException(hostname);
    }

    final failure = failures[0];

    if (failure is UnknownHostException) {
      throw failure;
    }

    final unknownHostException = UnknownHostException(hostname).let((it) {
      final cause = buildString((it) {
        it.write('[');
        for (var failure in failures) {
          it.write(failure.toString());
        }
        it.write(']');
      });

      return it.initCause(cause);
    });

    throw unknownHostException;
  }

  void _processResponse(
    Response response,
    String hostname,
    List<InternetAddress> results,
    List<Exception> failures,
  ) {
    try {
      final addresses = _readResponse(hostname, response);
      results.addAll(addresses);
    } catch (e) {
      failures.add(e is Exception ? e : Exception(e.toString()));
    }
  }

  List<InternetAddress> _readResponse(
    String hostname,
    Response response,
  ) {
    if (!response.isSuccessful) {
      throw OkHttpException(
          "response: ${response.statusCode} ${response.message}");
    }

    final body = response.body;

    final MAX_RESPONSE_SIZE = 64 * 1024;

    if (body.contentLength > MAX_RESPONSE_SIZE) {
      throw OkHttpException(
        "response size exceeds limit ($MAX_RESPONSE_SIZE bytes): ${body.contentLength} bytes",
      );
    }

    final responseBytes = body.bytes;

    return DnsRecordCodec.decodeAnswers(
        hostname, Uint8List.fromList(responseBytes));
  }

  static final DNS_MESSAGE = "application/dns-message".toMediaType();

  @override
  Future<List<InternetAddress>> lookup(String hostname) {
    return _lookupHttps(hostname);
  }

  static DnsOverHttpsBuilder Builder() => _CommonBuilder();
}

class _CommonBuilder extends DnsOverHttpsBuilder {
  _CommonBuilder();
}

sealed class DnsOverHttpsBuilder {
  OkHttpClient? _client;
  Uri? _url;
  bool _includeIPv6 = true;
  bool _post = false;
  Dns _systemDns = Dns.SYSTEM;
  List<InternetAddress>? _bootstrapDnsHosts;
  bool _resolvePrivateAddresses = false;
  bool _resolvePublicAddresses = true;

  Dns _buildBootstrapClient() {
    final hosts = _bootstrapDnsHosts;

    if (hosts != null) {
      return BootstrapDns(_url!.host, hosts);
    } else {
      return _systemDns;
    }
  }

  DnsOverHttps build() {
    return DnsOverHttps._(
      client: _client?.newBuilder().dns(_buildBootstrapClient()).build() ??
          (throw Exception("client not set")),
      url: _url ?? (throw Exception("url not set")),
      includeIPv6: _includeIPv6,
      post: _post,
      resolvePrivateAddresses: _resolvePrivateAddresses,
      resolvePublicAddresses: _resolvePublicAddresses,
    );
  }

  DnsOverHttpsBuilder client(OkHttpClient client) {
    return apply((it) {
      it._client = client;
    });
  }

  DnsOverHttpsBuilder url(Uri url) {
    return apply((it) {
      it._url = url;
    });
  }

  DnsOverHttpsBuilder includeIPv6(bool includeIPv6) {
    return apply((it) {
      it._includeIPv6 = includeIPv6;
    });
  }

  DnsOverHttpsBuilder post(bool post) {
    return apply((it) {
      it._post = post;
    });
  }

  DnsOverHttpsBuilder resolvePrivateAddresses(bool resolvePrivateAddresses) {
    return apply((it) {
      it._resolvePrivateAddresses = resolvePrivateAddresses;
    });
  }

  DnsOverHttpsBuilder resolvePublicAddresses(bool resolvePublicAddresses) {
    return apply((it) {
      it._resolvePublicAddresses = resolvePublicAddresses;
    });
  }

  DnsOverHttpsBuilder bootstrapDnsHosts(
      List<InternetAddress>? bootstrapDnsHosts) {
    return apply((it) {
      it._bootstrapDnsHosts = bootstrapDnsHosts;
    });
  }

  DnsOverHttpsBuilder addBootstrapDnsHosts(
      List<InternetAddress>? bootstrapDnsHosts) {
    if (_bootstrapDnsHosts == null) {
      return this.bootstrapDnsHosts(bootstrapDnsHosts);
    }
    return apply((it) {
      if (bootstrapDnsHosts != null) {
        it._bootstrapDnsHosts!.addAll(bootstrapDnsHosts);
      }
      return;
    });
  }

  DnsOverHttpsBuilder systemDns(Dns systemDns) {
    return apply((it) {
      it._systemDns = systemDns;
    });
  }
}

Future<InternetAddress> getByIp(String host) {
  return InternetAddress.lookup(host).then((value) => value[0]);
}
