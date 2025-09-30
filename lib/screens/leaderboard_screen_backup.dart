// lib/screens/leaderboard_screen.dart
import 'package:flutter/material.dart';
import '../models/leaderboard_entry.dart';
import '../services/leaderboard_service.dart';

class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({super.key});
  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  String _period = 'All-Time';
  String _query = '';
  List<LeaderboardEntry> _entries = [];
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _loadEntries();
  }

  void _loadEntries() {
    setState(() => _loading = true);
    final list = LeaderboardService.getForPeriod(_period);
    list.sort((a, b) => b.points.compareTo(a.points));
    setState(() {
      _entries = list;
      _loading = false;
    });
  }

  Future<void> _refresh() async {
    await Future.delayed(const Duration(milliseconds: 400));
    _loadEntries();
  }

  List<LeaderboardEntry> get _filteredEntries {
    if (_query.isEmpty) return _entries;
    final q = _query.toLowerCase();
    return _entries.where((e) => e.name.toLowerCase().contains(q)).toList();
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filteredEntries;
    final top3 = filtered.take(3).toList();
    final rest = filtered.skip(3).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Leaderboard', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.emoji_events),
            onPressed: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Rewards (placeholder)'))),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(64),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8),
            child: _buildSearchField(),
          ),
        ),
      ),
      // colorful gradient background
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFf8bbd0), Color(0xFFb39ddb), Color(0xFF80deea)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            const SizedBox(height: 8),
            _buildFilterChips(),
            const SizedBox(height: 12),
            SizedBox(height: 170, child: top3.isEmpty ? const SizedBox() : _buildTopThreeRow(top3)),
            const SizedBox(height: 8),
            Expanded(
              child: RefreshIndicator(
                onRefresh: _refresh,
                child: _loading
                    ? const Center(child: CircularProgressIndicator())
                    : rest.isEmpty
                        ? ListView(physics: const AlwaysScrollableScrollPhysics(), children: const [SizedBox(height: 60), Center(child: Text('No results'))])
                        : ListView.separated(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            itemCount: rest.length,
                            separatorBuilder: (_, __) => const SizedBox(height: 6),
                            itemBuilder: (context, index) {
                              final entry = rest[index];
                              final rank = index + 4;
                              return _LeaderboardRow(entry: entry, rank: rank);
                            },
                          ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('My Stats (placeholder)'))),
                      icon: const Icon(Icons.person),
                      label: const Text('My Stats'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  OutlinedButton(
                    onPressed: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Redeem (placeholder)'))),
                    child: const Text('Redeem'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchField() {
    return TextField(
      decoration: InputDecoration(
        hintText: 'Search students...',
        prefixIcon: const Icon(Icons.search),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
      ),
      onChanged: (v) => setState(() => _query = v.trim()),
    );
  }

  Widget _buildFilterChips() {
    const options = ['Weekly', 'Monthly', 'All-Time'];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: options.map((op) {
          final selected = op == _period;
          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: ChoiceChip(
              label: Text(op, style: TextStyle(color: selected ? Colors.white : Colors.black)),
              selected: selected,
              selectedColor: Colors.deepOrangeAccent,
              backgroundColor: Colors.white70,
              onSelected: (_) {
                setState(() => _period = op);
                _loadEntries();
              },
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildTopThreeRow(List<LeaderboardEntry> top3) {
    final a = top3.length > 0 ? top3[0] : null;
    final b = top3.length > 1 ? top3[1] : null;
    final c = top3.length > 2 ? top3[2] : null;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          if (b != null) Expanded(child: _TopCard(entry: b, position: 2)),
          const SizedBox(width: 8),
          if (a != null) Expanded(child: _TopCard(entry: a, position: 1, isCenter: true)),
          const SizedBox(width: 8),
          if (c != null) Expanded(child: _TopCard(entry: c, position: 3)),
        ],
      ),
    );
  }
}

class _TopCard extends StatelessWidget {
  final LeaderboardEntry entry;
  final int position;
  final bool isCenter;
  const _TopCard({required this.entry, required this.position, this.isCenter = false});

  LinearGradient _medalGradient(int pos) {
    if (pos == 1) {
      return const LinearGradient(colors: [Color(0xFFFFF59D), Color(0xFFFFD54F)]);
    } else if (pos == 2) {
      return const LinearGradient(colors: [Color(0xFF81D4FA), Color(0xFF4FC3F7)]);
    } else {
      return const LinearGradient(colors: [Color(0xFFFFAB91), Color(0xFFFF8A65)]);
    }
  }

  String _emoji(int pos) => pos == 1 ? '👑' : pos == 2 ? '⭐' : '🎉';

  @override
  Widget build(BuildContext context) {
    final gradient = _medalGradient(position);
    return Card(
      elevation: isCenter ? 10 : 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(gradient: gradient, borderRadius: BorderRadius.circular(16)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_emoji(position), style: TextStyle(fontSize: isCenter ? 32 : 26)),
            const SizedBox(height: 8),
            ClipOval(
              child: Image.asset(
                entry.avatar,
                width: isCenter ? 70 : 56,
                height: isCenter ? 70 : 56,
                fit: BoxFit.cover,
                errorBuilder: (c, e, s) => Container(
                  width: isCenter ? 70 : 56,
                  height: isCenter ? 70 : 56,
                  color: Colors.white70,
                  child: Center(child: Text(entry.name.isNotEmpty ? entry.name[0] : '?')),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(entry.name, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87, fontSize: isCenter ? 16 : 14)),
            const SizedBox(height: 6),
            Text('${entry.points} pts', style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}

class _LeaderboardRow extends StatelessWidget {
  final LeaderboardEntry entry;
  final int rank;
  const _LeaderboardRow({required this.entry, required this.rank});

  @override
  Widget build(BuildContext context) {
    final highlight = entry.isCurrentUser;
    final rowColor = highlight
        ? Colors.yellow[200]
        : rank % 2 == 0
            ? Colors.lightGreen[100]
            : Colors.pink[100];

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: rowColor,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 6, offset: const Offset(2, 4))],
      ),
      child: Row(
        children: [
          SizedBox(width: 56, child: Text('🏅 $rank', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16))),
          ClipOval(
            child: Image.asset(
              entry.avatar,
              width: 52,
              height: 52,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                width: 52,
                height: 52,
                color: Colors.white.withOpacity(0.6),
                child: Center(child: Text(entry.name.isNotEmpty ? entry.name[0] : '?')),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(entry.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 6),
                Row(
                  children: [
                    if (entry.badges.isNotEmpty)
                      ...entry.badges.map((b) => Padding(
                            padding: const EdgeInsets.only(right: 6.0),
                            child: Image.asset(b, width: 24, height: 24, errorBuilder: (_, __, ___) => const SizedBox()),
                          )),
                    const SizedBox(width: 6),
                    Text('Lvl ${entry.level} • 🔥 ${entry.streak}', style: const TextStyle(fontSize: 12)),
                  ],
                ),
              ],
            ),
          ),
          Text('${entry.points}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(width: 6),
          IconButton(
            icon: const Icon(Icons.compare_arrows),
            onPressed: () => showDialog(
              context: context,
              builder: (_) => AlertDialog(
                title: const Text('Compare'),
                content: Text('Compare ${entry.name} with you (implement)'),
                actions: [TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Close'))],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
