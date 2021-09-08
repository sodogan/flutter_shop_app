enum RequestType { get, post, patch, delete }

class HttpException implements Exception {
  final String message;
  final RequestType requestType;
  final StackTrace stackTrace;

  HttpException(
      {required this.requestType,
      required this.message,
      required this.stackTrace});

  @override
  String toString() {
    return 'For $requestType: $message->for more see stackTrace: $stackTrace';
  }
}
