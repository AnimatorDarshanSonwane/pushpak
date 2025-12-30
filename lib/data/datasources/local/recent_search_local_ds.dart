import '../../../domain/entities/recent_search_entity.dart';

class RecentSearchLocalDatasource {
  final List<RecentSearchEntity> _cache = [];

  List<RecentSearchEntity> getSearches() => _cache;

  void addSearch(RecentSearchEntity search) {
    _cache.insert(0, search);
    if (_cache.length > 5) {
      _cache.removeLast();
    }
  }
}
