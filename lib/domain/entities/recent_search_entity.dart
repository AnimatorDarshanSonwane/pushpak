class RecentSearchEntity {
  final String title;
  final DateTime searchedAt;

  RecentSearchEntity({
    required this.title,
    required this.searchedAt,
  });

  // You can customize this getter as needed
  String get subtitle => '';
}
