class OkHttpException implements Exception {
  final String message;
  final int? statusCode;
  final String? reasonPhrase;
  final Uri? uri;
  final Exception? error;
  final StackTrace? stackTrace;
  OkHttpException(
    this.message, {
    this.error,
    this.stackTrace,
    this.statusCode,
    this.reasonPhrase,
    this.uri,
  });

  @override
  String toString() {
    return 'OkHttpException($message, $error, $stackTrace, $statusCode, $reasonPhrase, $uri)';
  }
}
