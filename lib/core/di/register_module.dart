import 'package:google_sign_in/google_sign_in.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

@module
abstract class RegisterModule {
  @lazySingleton
  SupabaseClient get supabase => Supabase.instance.client;

  @lazySingleton
  GoTrueClient get auth => Supabase.instance.client.auth;

  @lazySingleton
  GoogleSignIn get googleSignIn => GoogleSignIn.instance;

  @preResolve
  Future<SharedPreferences> get sharedPreferences =>
      SharedPreferences.getInstance();
}
