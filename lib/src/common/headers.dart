import 'package:nice_dart/nice_dart.dart';

bool isSensitiveHeader(String key) {
  return key.equals("Authorization", ignoreCase: true) ||
      key.equals("Cookie", ignoreCase: true) ||
      key.equals("Proxy-Authorization", ignoreCase: true) ||
      key.equals("Set-Cookie", ignoreCase: true);
}
