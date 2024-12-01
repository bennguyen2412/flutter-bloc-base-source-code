import 'package:injectable/injectable.dart';

import '../../common/either.dart';
import '../../common/error.dart';
import '../../data/remote/remote.dart';
import '../../models/dtos/city.dart';
import '../domain.dart';

@LazySingleton(as: CityRepository)
final class CityRepositoryImpl implements CityRepository {
  const CityRepositoryImpl(this.cityApi);

  final ICityApi cityApi;

  @override
  Future<Either<DataSourceError, List<City>>> getCities() =>
      cityApi.getCities();
}
