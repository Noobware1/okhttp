import 'dart:convert';

/// Factory for HTTP authorization credentials.
interface class Credentials {
  /// Returns an auth credential for the Basic scheme.
  static String basic(String username, String password, [Encoding? encoding]) {
    final usernameAndPassword = "$username:$password";
    encoding ??= latin1;
    final encoded = base64Encode(latin1.encode(usernameAndPassword));
    return "Basic $encoded";
  }
}
