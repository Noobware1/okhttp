library okhttp3.dns_over_https.dns_client;

import 'dart:io';

import 'package:nice_dart/nice_dart.dart';
import 'package:okhttp/src/dns.dart';
import 'package:okhttp/src/dns_over_https/dns_over_https.dart';
import 'package:okhttp/src/okhttp_client.dart';
import 'package:socks5_proxy/socks_client.dart';

class DnsClient {
  static void assignToHttpClient(HttpClient client, Dns dns) {
    client.connectionFactory = (url, proxyHost, proxyPort) async {
      final addresses = await dns.lookup(proxyHost ?? url.host);
      var i = 0;
      while (i < addresses.lastIndex) {
        try {
          var uri = url.replace(host: addresses[i].host);
          print(uri);
          final connectionTask =
              await Socket.startConnect(addresses[i], proxyPort ?? 80);
          if (url.scheme == "https") {
            return SocketConnectionTask(
              SecureSocket.secure(
                await connectionTask.socket,
                host: addresses[i],
              ),
            );
          }
          return SocketConnectionTask(connectionTask.socket);
        } catch (e, s) {
          print('Error: $e');
          print('Stack $s');
          i++;
        }
      }
      throw Exception("Failed to connect to $url");
    };
  }
}

void main(List<String> args) async {
  // final dns = (await OkHttpClient.Builder().dohCloudflare()).build();
  final dns = await dohAdGuard();
  final HttpClient client = HttpClient();

  final url = Uri.parse("https://www.1337x.to/");
  DnsClient.assignToHttpClient(client, dns);

  final request = await client.getUrl(url);
  request.followRedirects = true;
  request.maxRedirects = 10;
  request.persistentConnection = true;

  final response = await request.close();
  print(response.redirects);
  // print(await response.transform(Utf8Decoder()).join());

  client.close();
}

Future<DnsOverHttps> dohAdGuard() async {
  return DnsOverHttps.Builder()
      .client(OkHttpClient())
      .url(Uri.parse("https://dns-unfiltered.adguard.com/dns-query"))
      .bootstrapDnsHosts(await Future.wait([
        getByIp("94.140.14.140"),
        getByIp("94.140.14.141"),
        getByIp("2a10:50c0::1:ff"),
        getByIp("2a10:50c0::2:ff"),
      ]))
      .build();
}

Future<DnsOverHttps> dohCloudflare() async {
  return DnsOverHttps.Builder()
      .client(OkHttpClient())
      .url(Uri.parse("https://cloudflare-dns.com/dns-query"))
      .bootstrapDnsHosts(await Future.wait([
        getByIp("162.159.36.1"),
        getByIp("162.159.46.1"),
        getByIp("1.1.1.1"),
        getByIp("1.0.0.1"),
        getByIp("162.159.132.53"),
        getByIp("2606:4700:4700::1111"),
        getByIp("2606:4700:4700::1001"),
        getByIp("2606:4700:4700::0064"),
        getByIp("2606:4700:4700::6400"),
      ]))
      .build();
}

extension on OkHttpClientBuilder {
  Future<OkHttpClientBuilder> dohCloudflare() async {
    return dns(DnsOverHttps.Builder()
        .client(build())
        .url(Uri.parse("https://cloudflare-dns.com/dns-query"))
        .bootstrapDnsHosts(await Future.wait([
          getByIp("162.159.36.1"),
          getByIp("162.159.46.1"),
          getByIp("1.1.1.1"),
          getByIp("1.0.0.1"),
          getByIp("162.159.132.53"),
          getByIp("2606:4700:4700::1111"),
          getByIp("2606:4700:4700::1001"),
          getByIp("2606:4700:4700::0064"),
          getByIp("2606:4700:4700::6400"),
        ]))
        .build());
  }
}
