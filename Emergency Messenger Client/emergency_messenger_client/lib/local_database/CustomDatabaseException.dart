class CustomDatabaseException extends Exception {
  factory CustomDatabaseException([var message]) => _CustomDatabaseException(message);
}

class _CustomDatabaseException implements CustomDatabaseException {
  final message;

  _CustomDatabaseException([this.message]);

  String toString() {
    if (message == null) return "Exception";
    return "Exception: $message";
  }
}