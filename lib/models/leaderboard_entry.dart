// lib/models/leaderboard_entry.dart
class LeaderboardEntry {
  final String id;
  final String name;
  final String avatar; // 'assets/avatars/alice.png'
  final int points;
  final List<String> badges;
  final int streak;
  final int level;
  final bool isCurrentUser;

  LeaderboardEntry({
    required this.id,
    required this.name,
    required this.avatar,
    required this.points,
    this.badges = const [],
    this.streak = 0,
    this.level = 1,
    this.isCurrentUser = false,
  });
}
