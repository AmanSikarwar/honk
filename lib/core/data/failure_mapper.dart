import 'dart:io';

import 'package:supabase_flutter/supabase_flutter.dart';

import '../domain/main_failure.dart';

MainFailure mapErrorToMainFailure(Object error, StackTrace stackTrace) {
  if (error is MainFailure) {
    return error;
  }

  if (error is PostgrestException) {
    return MainFailure.databaseFailure(error.message);
  }

  if (error is AuthException) {
    return MainFailure.authenticationFailure(error.message);
  }

  if (error is SocketException) {
    return MainFailure.networkFailure(error.message);
  }

  return MainFailure.unknownFailure(error.toString());
}
