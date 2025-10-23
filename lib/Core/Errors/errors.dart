class ServerException implements Exception {
  final String message;
  ServerException([this.message = "Server Error"]);
}

class SomethingWrongException implements Exception {
  final String message;
  SomethingWrongException([this.message = "Cache Error"]);
}

class NetworkException implements Exception {
  final String message;
  NetworkException([this.message = "Check the Internet"]);
}