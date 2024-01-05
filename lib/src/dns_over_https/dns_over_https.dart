// ignore_for_file: non_constant_identifier_names

import 'package:ok_http/src/dns_over_https/dns_record_codec.dart';
import 'package:ok_http/src/request.dart';
import 'package:ok_http/src/request_body.dart';
import 'package:ok_http/src/utils/utils.dart';

class DnsOverHttps {
  final Uri url;
  final bool post;
  DnsOverHttps({
    required this.url,
    required this.post,
  });

  Request buildRequest(String hostname, int type) {
    final request = Request.uri(url, method: post ? 'POST' : 'GET')
      ..headers.add("Accept", DNS_MESSAGE.toString());

    final query = DnsRecordCodec.encodeQuery(hostname, type);

    if (post) {
      request.body = RequestBody.fromString(query.string(), DNS_MESSAGE);
    } else {
      final encoded = query.base64Url().replaceFirst("=", "");
      request.addQueryParameter("dns", encoded);
    }

    return request;
  }

  static final DNS_MESSAGE = "application/dns-message".toMediaType();
}
