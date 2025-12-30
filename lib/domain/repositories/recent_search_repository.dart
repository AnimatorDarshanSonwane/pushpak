import '../entities/recent_search_entity.dart';

abstract class RecentSearchRepository {
  Future<List<RecentSearchEntity>> getRecentSearches();
  Future<void> addRecentSearch(RecentSearchEntity search);
}
