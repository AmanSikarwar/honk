import 'package:envied/envied.dart';

part 'env.g.dart';

@Envied(path: '.env', obfuscate: true)
abstract class Env {
  @EnviedField(varName: 'SUPABASE_URL')
  static String supabaseUrl = _Env.supabaseUrl;

  @EnviedField(varName: 'SUPABASE_ANON_KEY')
  static String supabaseAnonKey = _Env.supabaseAnonKey;

  @EnviedField(varName: 'GOOGLE_WEB_CLIENT_ID')
  static String googleWebClientId = _Env.googleWebClientId;

  @EnviedField(varName: 'GOOGLE_IOS_CLIENT_ID')
  static String googleIosClientId = _Env.googleIosClientId;
}
