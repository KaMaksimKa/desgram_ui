import 'package:desgram_ui/data/repository/api_data_repository.dart';
import 'package:desgram_ui/domain/repository/api_repository.dart';
import 'package:desgram_ui/inrernal/dependencies/api_module.dart';

class RepositoryModule {
  static ApiRepository? _apiRepository;
  static ApiRepository getApiRepository() {
    return _apiRepository ??= ApiDataRepository(ApiModule.getAuthClient());
  }
}
