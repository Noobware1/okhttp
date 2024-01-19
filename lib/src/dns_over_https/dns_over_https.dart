// ignore_for_file: non_constant_identifier_names

import 'package:okhttp/src/dns_over_https/dns_record_codec.dart';
import 'package:okhttp/src/request.dart';
import 'package:okhttp/src/request_body.dart';
import 'package:okhttp/src/utils/utils.dart';

class DnsOverHttps {
  final Uri url;
  final bool post;
  DnsOverHttps({
    required this.url,
    required this.post,
  });

  Request buildRequest(String hostname, int type) {
    final request =
        Request.Builder().url(url).header('Accept', DNS_MESSAGE.toString());

    final query = DnsRecordCodec.encodeQuery(hostname, type);

    if (post) {
      request.post(RequestBody.fromString(query.string(), DNS_MESSAGE));
    } else {
      final encoded = query.base64Url().replaceFirst("=", "");
      request.get();
      request.addQueryParameter("dns", encoded);
    }

    return request.build();
  }

  static final DNS_MESSAGE = "application/dns-message".toMediaType();
}
