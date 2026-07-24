import 'exceptions.dart';

class ErrorHandler {
  static String getMessage(dynamic error) {
    if (error is AuthException) {
      return error.message;
    }

    if (error is FirestoreException) {
      return error.message;
    }

    if (error is NetworkException) {
      return error.message;
    }

    if (error is CacheException) {
      return error.message;
    }

    if (error is ServerException) {
      return error.message;
    }

    return 'Something went wrong';
  }
}