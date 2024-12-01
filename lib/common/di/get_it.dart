import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import '../../app_flavor.dart';
import '../../data/remote/remote.dart';
import 'get_it.config.dart';

final getIt = GetIt.instance;

@InjectableInit(
  preferRelativeImports: true,
)
void configureDependencies() =>
    getIt.init(environment: FlavorConfigurations.current.name);

const development = Environment('development');
const staging = Environment('staging');
const production = Environment('production');

@module
abstract class RegisterModule {
  @singleton
  DioClient get dioClient => DioClient();

  @authDio
  Dio get dioAuth => dioClient.authDio;

  @nonAuthDio
  Dio get dioNonAuth => dioClient.dio;
}
