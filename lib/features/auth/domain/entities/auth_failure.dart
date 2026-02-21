import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_failure.freezed.dart';

@freezed
class AuthFailure with _$AuthFailure {
  const factory AuthFailure.serverError(String message) = ServerError;
  const factory AuthFailure.emailAlreadyInUse() = EmailAlreadyInUse;
  const factory AuthFailure.invalidEmailAndPasswordCombination() =
      InvalidEmailAndPasswordCombination;
  const factory AuthFailure.weakPassword() = WeakPassword;
  const factory AuthFailure.userNotFound() = UserNotFound;
  const factory AuthFailure.emailNotVerified() = EmailNotVerified;
  const factory AuthFailure.tooManyRequests() = TooManyRequests;
  const factory AuthFailure.networkError() = NetworkError;
  const factory AuthFailure.cancelledByUser() = CancelledByUser;
  const factory AuthFailure.unknown(String message) = Unknown;
}
