import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;

  const Failure(this.message);
}

Failure handleFailure(Either<Failure, dynamic> resultEither) {
  return resultEither.fold((failure) => failure, (r) => null)!;
}

// General Failures of ajwaae

class GPSOffFailure extends Failure {
  const GPSOffFailure(message) : super(message);

  @override
  List<Object> get props => [message];
}

class GeneralFail extends Failure {
  const GeneralFail(message) : super(message);

  @override
  List<Object> get props => [message];
}

class FriendRequestNotSend extends Failure {
  const FriendRequestNotSend(message) : super(message);

  @override
  List<Object> get props => [message];
}

// Inappropriate Image
class InappropriateImageFailure extends Failure {
  const InappropriateImageFailure(message) : super(message);

  @override
  List<Object> get props => [message];
}

// RemoteConfig Failure
class UDIDGnerationFailure extends Failure {
  const UDIDGnerationFailure(message) : super(message);

  @override
  List<Object> get props => [message];
}

// Failure for underlying platform
class LocationFailure extends Failure {
  const LocationFailure(message) : super(message);

  @override
  List<Object> get props => [message];
}

class NoResultsFoundFailure extends Failure {
  const NoResultsFoundFailure(message) : super(message);

  @override
  List<Object> get props => [message];
}

class FcmTokenReterivalError extends Failure {
  const FcmTokenReterivalError(String message) : super(message);

  @override
  List<Object?> get props => [message];
}

// AccessToken  Failure
class AccessTokenFailure extends Failure {
  const AccessTokenFailure(message) : super(message);

  @override
  List<Object> get props => [message];
}

class TooManyAttemptsFailure extends Failure {
  const TooManyAttemptsFailure(message) : super(message);

  @override
  List<Object> get props => [message];
}

class ServerFailure extends Failure {
  const ServerFailure(message) : super(message);

  @override
  List<Object> get props => [message];
}

class InvalidTokenFailure extends Failure {
  const InvalidTokenFailure(message) : super(message);
  @override
  List<Object> get props => [message];
}

class CacheFailure extends Failure {
  const CacheFailure(message) : super(message);

  @override
  List<Object> get props => [message];
}

// Remote Config Failure
class NetworkFailure extends Failure {
  const NetworkFailure(message) : super(message);

  @override
  List<Object> get props => [message];
}

// Failure for underlying platform
class PlatformFailure extends Failure {
  const PlatformFailure(message) : super(message);

  @override
  List<Object> get props => [message];
}

class ImagePickerFailure extends Failure {
  const ImagePickerFailure(String message) : super(message);

  @override
  List<Object?> get props => [message];
}

class InvalidEmail extends Failure {
  const InvalidEmail(String message) : super(message);

  @override
  List<Object?> get props => [message];
}

class Empty extends Failure {
  const Empty(String message) : super(message);

  @override
  List<Object?> get props => [message];
}

class ErrorMessage extends Failure {
  const ErrorMessage(String message) : super(message);

  @override
  List<Object?> get props => [message];
}

class CopyLinkFailure extends Failure {
  const CopyLinkFailure(String message) : super(message);

  @override
  List<Object?> get props => [message];
}

class ShareLinkFailure extends Failure {
  const ShareLinkFailure(String message) : super(message);

  @override
  List<Object?> get props => [message];
}

class CodeAlreadySendFailure extends Failure {
  const CodeAlreadySendFailure(String message) : super(message);

  @override
  List<Object?> get props => [message];
}

class UserAlreadyLoggedInFailure extends Failure {
  const UserAlreadyLoggedInFailure(String message) : super(message);

  @override
  List<Object?> get props => [message];
}

class UserDoesNotExistFailure extends Failure {
  const UserDoesNotExistFailure(String message) : super(message);

  @override
  List<Object?> get props => [message];
}

class PhoneAlreadyRegisteredFailure extends Failure {
  const PhoneAlreadyRegisteredFailure(String message) : super(message);

  @override
  List<Object?> get props => [message];
}

class VerificationInvalidEmail extends Failure {
  const VerificationInvalidEmail(String message) : super(message);

  @override
  List<Object?> get props => [message];
}

class EmailAlreadyRegisteredFailure extends Failure {
  const EmailAlreadyRegisteredFailure(String message) : super(message);

  @override
  List<Object?> get props => [message];
}

class EmailNotVerifiedFailure extends Failure {
  const EmailNotVerifiedFailure(String message) : super(message);

  @override
  List<Object?> get props => [message];
}

class CountryNotAllowedFailure extends Failure {
  const CountryNotAllowedFailure(String message) : super(message);

  @override
  List<Object?> get props => [message];
}

class EmailAlreadyVerified extends Failure {
  const EmailAlreadyVerified(String message) : super(message);

  @override
  List<Object?> get props => [message];
}

class InvalidOtpFailure extends Failure {
  const InvalidOtpFailure(String message) : super(message);

  @override
  List<Object?> get props => [message];
}

class InvalidOtp extends Failure {
  const InvalidOtp(String message) : super(message);

  @override
  List<Object?> get props => [message];
}

class InvalidPassCode extends Failure {
  const InvalidPassCode(String message) : super(message);

  @override
  List<Object?> get props => [message];
}

class InvalidAuthToken extends Failure {
  const InvalidAuthToken(String message) : super(message);

  @override
  List<Object?> get props => [message];
}

class InvalidBiometric extends Failure {
  const InvalidBiometric(String message) : super(message);

  @override
  List<Object?> get props => [message];
}

class DocsRequired extends Failure {
  const DocsRequired(String message) : super(message);

  @override
  List<Object?> get props => [message];
}

class InvalidLoginToken extends Failure {
  const InvalidLoginToken(String message) : super(message);

  @override
  List<Object?> get props => [message];
}

class InvalidLoginTokenFailure extends Failure {
  const InvalidLoginTokenFailure(String message) : super(message);

  @override
  List<Object?> get props => [message];
}

class LanguageNotSupportedFailure extends Failure {
  const LanguageNotSupportedFailure(String message) : super(message);

  @override
  List<Object?> get props => [message];
}

class TokenNotFound extends Failure {
  const TokenNotFound(String message) : super(message);

  @override
  List<Object?> get props => [message];
}

class LoginTokenExpiredFailure extends Failure {
  const LoginTokenExpiredFailure(message) : super(message);

  @override
  List<Object> get props => [message];
}

class UnsupportedFileFormatFailure extends Failure {
  const UnsupportedFileFormatFailure(message) : super(message);

  @override
  List<Object> get props => [message];
}

class FileSizeGreaterFailure extends Failure {
  const FileSizeGreaterFailure(message) : super(message);

  @override
  List<Object> get props => [message];
}

class CameraServiceFailure extends Failure {
  const CameraServiceFailure(message) : super(message);

  @override
  List<Object> get props => [message];
}

class DynamicLinkFailure extends Failure {
  const DynamicLinkFailure(message) : super(message);

  @override
  List<Object> get props => [message];
}

class ImageSizeFailure extends Failure {
  const ImageSizeFailure(message) : super(message);

  @override
  List<Object> get props => [message];
}

class ContentTypeNotSupportedFailure extends Failure {
  const ContentTypeNotSupportedFailure(message) : super(message);

  @override
  List<Object> get props => [message];
}

class ImageUploadFailure extends Failure {
  const ImageUploadFailure(message) : super(message);

  @override
  List<Object> get props => [message];
}

class NoRecordFoundFailure extends Failure {
  const NoRecordFoundFailure(message) : super(message);

  @override
  List<Object> get props => [message];
}

class FCMFailure extends Failure {
  const FCMFailure(message) : super(message);

  @override
  List<Object> get props => [message];
}

class EmailLinkExpiredFailure extends Failure {
  const EmailLinkExpiredFailure(message) : super(message);

  @override
  List<Object> get props => [message];
}

class BadRequestFailure extends Failure {
  const BadRequestFailure(message) : super(message);

  @override
  List<Object> get props => [message];
}

class AlreadySharedFailure extends Failure {
  const AlreadySharedFailure(message) : super(message);

  @override
  List<Object> get props => [message];
}

class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure(message) : super(message);

  @override
  List<Object> get props => [message];
}

class ForbiddenFailure extends Failure {
  const ForbiddenFailure(message) : super(message);

  @override
  List<Object> get props => [message];
}

class MobileNoNotFoundFailure extends Failure {
  const MobileNoNotFoundFailure(message) : super(message);

  @override
  List<Object> get props => [message];
}

class NotFoundFailure extends Failure {
  const NotFoundFailure(message) : super(message);

  @override
  List<Object> get props => [message];
}

class InternalServerErrorFailure extends Failure {
  const InternalServerErrorFailure(message) : super(message);

  @override
  List<Object> get props => [message];
}

class NotImplementedFailure extends Failure {
  const NotImplementedFailure(message) : super(message);

  @override
  List<Object> get props => [message];
}

class VehicleAlreadyExistFailure extends Failure {
  const VehicleAlreadyExistFailure(message) : super(message);

  @override
  List<Object> get props => [message];
}

class UserAlreadyExistFailure extends Failure {
  const UserAlreadyExistFailure(message) : super(message);

  @override
  List<Object> get props => [message];
}
