import 'package:okhttp/dns.dart';
import 'package:okhttp/okhttp.dart';
import 'package:okhttp/request.dart';

void main(List<String> args) async {
  var client = OkHttpClient();
  final dns = DnsOverHttps.Builder()
      .client(client)
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

  client = client.newBuilder().dns(dns).build();

  final request = Request.Builder().url("https://www.google.com").build();

  final response = await client.newCall(request).execute();

  print(response.body.string);
}
