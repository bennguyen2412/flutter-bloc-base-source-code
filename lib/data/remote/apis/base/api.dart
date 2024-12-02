import 'dart:async';

import 'package:dio/dio.dart';

import '../../../../flavor_configurations.dart';
import '../../../../common/either.dart';
import '../../../../common/error.dart';
import '../../status_code.dart';

abstract base class Api {
  final Dio dio;

  const Api(this.dio);

  Future<Either<NetworkError, T>> withTimeoutRequest<T>(
      Future<T> Function() request) async {
    try {
      return await Either.tryCatch(
        (err) => mapErrorToNetworkError(err),
        () async => await request(),
      ).timeout(
        Duration(milliseconds: FlavorConfigurations.current.connectTimeout),
      );
    } on TimeoutException catch (timeoutException) {
      return Left<NetworkError, T>(Timeout(exception: timeoutException));
    }
  }

  NetworkError mapErrorToNetworkError(Object? error) {
    if (error is DioException) {
      final code = error.response?.statusCode;
      if (code == null) return UnknownNetworkError();

      switch (code) {
        case NetworkStatusCode.notFound:
          return NotFound(exception: error);
        case NetworkStatusCode.badRequest:
          return BadRequest(exception: error);
        case NetworkStatusCode.forbidden:
          return Forbidden(exception: error);
        case NetworkStatusCode.internalServerError:
          return InternalServerError(exception: error);
        case NetworkStatusCode.unauthorized:
          return Unauthorized(exception: error);
        default:
          return UnknownNetworkError();
      }
    } else if (error is TimeoutException) {
      return Timeout(exception: error);
    }

    // TODO: Add more exception
    return UnknownNetworkError();
  }
}
