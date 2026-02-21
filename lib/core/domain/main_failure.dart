import 'package:freezed_annotation/freezed_annotation.dart';

part 'main_failure.freezed.dart';

@freezed
abstract class MainFailure with _$MainFailure {
  const factory MainFailure.serverFailure([String? message]) = ServerFailure;

  const factory MainFailure.databaseFailure([String? message]) =
      DatabaseFailure;

  const factory MainFailure.networkFailure([String? message]) = NetworkFailure;

  const factory MainFailure.authenticationFailure([String? message]) =
      AuthenticationFailure;

  const factory MainFailure.permissionFailure([String? message]) =
      PermissionFailure;

  const factory MainFailure.unknownFailure([String? message]) = UnknownFailure;
}
