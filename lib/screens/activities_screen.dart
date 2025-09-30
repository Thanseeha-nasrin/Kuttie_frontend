import 'package:flutter/material.dart';

class ActivitiesScreen extends StatelessWidget {
  const ActivitiesScreen({super.key});

  final List<ActivityCardData> activities = const [
    ActivityCardData(
      title: "Letter to a Character",
      subtitle: "Write to your book friends!",
      colors: [Color(0xFF00C6FF), Color(0xFF0072FF)],
      icon: Icons.edit_note,
    ),
    ActivityCardData(
      title: "Paint an Old T-Shirt",
      subtitle: "Make your clothes AWESOME!",
      colors: [Color(0xFFFFD200), Color(0xFFFFA000)],
      icon: Icons.format_paint,
    ),
    ActivityCardData(
      title: "Bottle Art",
      subtitle: "Turn bottles into TREASURES!",
      colors: [Color(0xFF9D50BB), Color(0xFF6E48AA)],
      icon: Icons.wine_bar,
    ),
    ActivityCardData(
      title: "Mud Sculpting",
      subtitle: "Squish and mold FUN stuff!",
      colors: [Color(0xFFF09819), Color(0xFFEDDE5D)],
      icon: Icons.emoji_nature,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8F8E8),
      appBar: AppBar(
        title: const Text("Fun Activities"),
        backgroundColor: Colors.teal,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: LayoutBuilder(
          builder: (context, constraints) {
            // Adjust grid based on screen width
            int crossAxisCount = constraints.maxWidth < 600 ? 2 : 4;
            return GridView.builder(
              itemCount: activities.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1,
              ),
              itemBuilder: (context, index) {
                final activity = activities[index];
                return ActivityCard(activity: activity);
              },
            );
          },
        ),
      ),
    );
  }
}

class ActivityCardData {
  final String title;
  final String subtitle;
  final List<Color> colors;
  final IconData icon;

  const ActivityCardData({
    required this.title,
    required this.subtitle,
    required this.colors,
    required this.icon,
  });
}

class ActivityCard extends StatefulWidget {
  final ActivityCardData activity;

  const ActivityCard({super.key, required this.activity});

  @override
  State<ActivityCard> createState() => _ActivityCardState();
}

class _ActivityCardState extends State<ActivityCard> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: widget.activity.colors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: _isPressed ? 2 : 8,
              offset: const Offset(3, 3),
            ),
          ],
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(widget.activity.icon, size: 60, color: Colors.white),
            const SizedBox(height: 12),
            Text(
              widget.activity.title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                shadows: [
                  Shadow(
                    blurRadius: 4,
                    color: Colors.black26,
                    offset: Offset(2, 2),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 6),
            Text(
              widget.activity.subtitle,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 13, color: Colors.white70),
            ),
          ],
        ),
      ),
    );
  }
}
