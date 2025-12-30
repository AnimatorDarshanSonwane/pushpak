import 'package:flutter/material.dart';
import '../domain/entities/recent_search_entity.dart';
import '../domain/repositories/recent_search_repository.dart';

class RideViewModel extends ChangeNotifier {
  final RecentSearchRepository repository;

  RideViewModel(this.repository);

  List<RecentSearchEntity> recentSearches = [];

  Future<void> loadRecentSearches() async {
    recentSearches = await repository.getRecentSearches();
    notifyListeners();
  }

  Future<void> addSearch(String title) async {
    await repository.addRecentSearch(
      RecentSearchEntity(
        title: title,
        searchedAt: DateTime.now(),
      ),
    );
    await loadRecentSearches();
  }
}
