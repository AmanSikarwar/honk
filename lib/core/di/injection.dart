import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'injection.config.dart';

final GetIt getIt = GetIt.instance;

@InjectableInit(initializerName: 'init', preferRelativeImports: true, asExtension: true)
Future<void> configureDependencies(String environment) async =>
    getIt.init(environment: environment);

abstract class AppEnv {
  static const dev = 'dev';
  static const prod = 'prod';
  static const test = 'test';
}
