import '../../domain/entities/recent_search_entity.dart';
import '../../domain/repositories/recent_search_repository.dart';
import '../datasources/local/recent_search_local_ds.dart';

class RecentSearchRepositoryImpl implements RecentSearchRepository {
  final RecentSearchLocalDatasource local;

  RecentSearchRepositoryImpl(this.local);

  @override
  Future<List<RecentSearchEntity>> getRecentSearches() async {
    return local.getSearches();
  }

  @override
  Future<void> addRecentSearch(RecentSearchEntity search) async {
    local.addSearch(search);
  }
}
