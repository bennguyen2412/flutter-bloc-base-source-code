import 'package:dart3z/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../models/dtos/city.dart';
import '../../dio.dart';
import '../api_path.dart';
import '../base/api.dart';

abstract interface class ICityApi {
  Future<Option<List<City>>> getCities();
}

@LazySingleton(as: ICityApi)
final class CityApi extends Api implements ICityApi {
  const CityApi(@nonAuthDio super.dio);

  @override
  Future<Option<List<City>>> getCities() => withTimeoutRequestOption(
        () async {
          final data = await dio.get<dynamic>(ApiPath.cities);
          return (data.data as List<dynamic>)
              .map((e) => City.fromJson(e as Map<String, dynamic>))
              .toList();
        },
      );
}
