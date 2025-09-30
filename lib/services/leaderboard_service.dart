// lib/services/leaderboard_service.dart
import '../models/leaderboard_entry.dart';

class LeaderboardService {
  static List<LeaderboardEntry> allTimeDummy() {
    return [
      LeaderboardEntry(
        id: '1',
        name: 'Alice',
        avatar: 'assets/avatars/alice.png',
        points: 3050,
        badges: ['assets/badges/gold.png'],
        streak: 12,
        level: 8,
      ),
      LeaderboardEntry(
        id: '2',
        name: 'Bob',
        avatar: 'assets/avatars/bob.png',
        points: 2850,
        badges: ['assets/badges/silver.png'],
        streak: 9,
        level: 7,
      ),
      LeaderboardEntry(
        id: '3',
        name: 'Charlie',
        avatar: 'assets/avatars/charlie.png',
        points: 2600,
        badges: ['assets/badges/bronze.png'],
        streak: 6,
        level: 6,
      ),
      LeaderboardEntry(
        id: '4',
        name: 'You',
        avatar: 'assets/avatars/you.png',
        points: 2380,
        badges: ['assets/badges/streak.png'],
        streak: 5,
        level: 6,
        isCurrentUser: true,
      ),
      // more entries to fill the list
      for (int i = 5; i <= 30; i++)
        LeaderboardEntry(
          id: '$i',
          name: 'Student $i',
          avatar: 'assets/avatars/placeholder.png',
          points: 2200 - i * 8,
          badges: i % 5 == 0 ? ['assets/badges/streak.png'] : [],
          streak: i % 7,
          level: 3 + (i % 5),
        ),
    ];
  }

  static List<LeaderboardEntry> getForPeriod(String period) {
    final all = allTimeDummy();
    switch (period) {
      case 'Weekly':
        return all.take(8).toList();
      case 'Monthly':
        return all.take(16).toList();
      default:
        return all;
    }
  }
}
