// TODO: Define custom exceptions.
class ServerException implements Exception {
  final String message;

  ServerException(this.message);
}

class CacheException implements Exception {
  final String message;

  CacheException(this.message);
}

class AuthException implements Exception {
  final String message;

  AuthException(this.message);
}

class FirestoreException implements Exception {
  final String message;

  FirestoreException(this.message);
}

class NetworkException implements Exception {
  final String message;

  NetworkException(this.message);
}