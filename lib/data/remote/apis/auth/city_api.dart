import 'package:injectable/injectable.dart';

import '../../../../common/either.dart';
import '../../../../common/error.dart';
import '../../../../models/dtos/city.dart';
import '../../dio.dart';
import '../api_path.dart';
import '../base/api.dart';

abstract interface class ICityApi {
  Future<Either<NetworkError, List<City>>> getCities();
}

@LazySingleton(as: ICityApi)
final class CityApi extends Api implements ICityApi {
  const CityApi(@nonAuthDio super.dio);

  @override
  Future<Either<NetworkError, List<City>>> getCities() => withTimeoutRequest(
        () async {
          final data = await dio.get<dynamic>(ApiPath.cities);
          return (data.data as List<dynamic>)
              .map((e) => City.fromJson(e as Map<String, dynamic>))
              .toList();
        },
      );
}
