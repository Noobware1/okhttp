import 'package:test/test.dart';
import 'package:okhttp/src/request.dart';

void main() {
  group('RequestBuilder', () {
    test('should set url correctly', () {
      var request = Request.Builder().url('https://example.com').build();
      expect(request.url, Uri.parse('https://example.com'));
    });

    test('should set header correctly', () {
      var request = Request.Builder()
          .url('https://example.com')
          .header('Content-Type', 'application/json')
          .build();
      expect(request.headers.get('Content-Type'), 'application/json');
    });

    test('should add header correctly', () {
      var request = Request.Builder()
          .url('https://example.com')
          .addHeader('Cookie', 'sessionid=123')
          .header('Content-Type', 'application/json')
          .build();

      expect(request.headers.get('Cookie'), 'sessionid=123');
    });

    test('should remove header correctly', () {
      var request = Request.Builder()
          .url('https://example.com')
          .addHeader('Cookie', 'sessionid=123')
          .header('Content-Type', 'application/json')
          .removeHeader('Content-Type')
          .build();
      expect(request.headers.get('Content-Type'), isNull);
    });

    test('should set method correctly', () {
      var request = Request.Builder()
          .url('https://example.com')
          .method('POST', null)
          .build();
      expect(request.method, 'POST');
    });

    test('should add query parameter correctly', () {
      var builder = Request.Builder();
      builder.url('https://example.com');
      builder.addQueryParameter('key', 'value');
      var request = builder.build();
      expect(request.url.queryParameters['key'], 'value');
    });
  });
}
