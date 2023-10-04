
import 'failure.dart';

class NotAuthenticatedError extends Error {}

class UnExpectedValueError extends Error {
  final Failure valueFailure;

  UnExpectedValueError(this.valueFailure);

  @override
  String toString() {
    const String explanation =
        'Encountered a value failure at an un recoverable point. Terminating.';
    return Error.safeToString('$explanation Failure was: $Failure');
  }
}

class UnableToLoadContacts extends Error {
  final String message;

  UnableToLoadContacts(this.message);

  @override
  String toString() {
    return Error.safeToString(message);
  }
}

class UnableToSendInviteMessage extends Error {
  final String message;

  UnableToSendInviteMessage(this.message);

  @override
  String toString() {
    return Error.safeToString(message);
  }
}




