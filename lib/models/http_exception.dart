class HttpException implements Exception {
  late final String message;

  HttpException({required this.message});

  @override
  String toString() {
    return message;
  }
}
