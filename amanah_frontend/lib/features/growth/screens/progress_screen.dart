// lib/features/growth/screens/progress_screen.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../providers/growth_provider.dart';

class ProgressScreen extends StatefulWidget {
  const ProgressScreen({super.key});

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  static const Color _primaryGreen = Color(0xFF1B5E45);
  static const Color _bgColor = Color(0xFFEFF4F1);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<GrowthProvider>().fetchProgress();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildHeader(context),
              const SizedBox(height: 20),
              _buildHeroCard(),
              const SizedBox(height: 20),
              _buildDailyGoals(),
              const SizedBox(height: 20),
              _buildWeeklyOverview(),
              const SizedBox(height: 20),
              _buildHadithBanner(),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => context.pop(),
            child: Container(
              width: 36, height: 36,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 8)],
              ),
              child: const Icon(Icons.arrow_back_rounded, size: 18, color: Color(0xFF1A2E25)),
            ),
          ),
          const Expanded(
            child: Center(
              child: Text('Your Progress',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Color(0xFF1A2E25))),
            ),
          ),
          Container(
            width: 32, height: 32,
            decoration: BoxDecoration(color: _primaryGreen, borderRadius: BorderRadius.circular(8)),
            child: const Center(child: Text('IA', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Colors.white))),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroCard() {
    return Consumer<GrowthProvider>(
      builder: (context, provider, _) {
        final score = provider.score ?? 850;
        final streak = provider.streak ?? 5;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 12)],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Track your spiritual journey',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: Color(0xFF1A2E25))),
                const SizedBox(height: 4),
                const Text('Stay consistent, grow closer to your faith every day.',
                    style: TextStyle(fontSize: 12, color: Color(0xFF6B8C7A))),
                const SizedBox(height: 16),
                Row(
                  children: [
                    // Streak
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF7FAF8),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Text('Current Streak', style: TextStyle(fontSize: 10, color: Color(0xFF6B8C7A))),
                                const SizedBox(width: 4),
                                const Icon(Icons.local_fire_department_rounded, size: 14, color: Color(0xFFFF6B35)),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text('$streak', style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w800, color: Color(0xFF1A2E25))),
                            const Text('days', style: TextStyle(fontSize: 11, color: Color(0xFF6B8C7A))),
                            const SizedBox(height: 4),
                            const Text('+2 from last week',
                                style: TextStyle(fontSize: 10, color: Color(0xFF1B5E45), fontWeight: FontWeight.w500)),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Score
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF1B5E45), Color(0xFF2E7D5E)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text('Total Points', style: TextStyle(fontSize: 10, color: Colors.white.withValues(alpha: 0.8))),
                                const SizedBox(width: 4),
                                Icon(Icons.star_rounded, size: 14, color: Colors.white.withValues(alpha: 0.8)),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text('$score', style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w800, color: Colors.white)),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(Icons.emoji_events_rounded, size: 14, color: Colors.amber),
                                const SizedBox(width: 4),
                                Text('Gold Level', style: TextStyle(fontSize: 10, color: Colors.white.withValues(alpha: 0.9), fontWeight: FontWeight.w600)),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDailyGoals() {
    final goals = [
      _GoalItem(icon: Icons.mosque_rounded,   label: 'Prayers Completed', current: 4, target: 5,  color: const Color(0xFF1B5E45)),
      _GoalItem(icon: Icons.menu_book_rounded, label: 'Quran Pages Read',  current: 7, target: 10, color: const Color(0xFF2E7D5E)),
      _GoalItem(icon: Icons.rotate_right_rounded, label: 'Dhikr Sessions', current: 2, target: 3,  color: Colors.orange),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Daily Goals', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Color(0xFF1A2E25))),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8)],
            ),
            child: Column(
              children: goals.map((g) => Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 32, height: 32,
                          decoration: BoxDecoration(
                            color: g.color.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(g.icon, size: 16, color: g.color),
                        ),
                        const SizedBox(width: 10),
                        Expanded(child: Text(g.label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Color(0xFF1A2E25)))),
                        Text('${g.current}/${g.target}', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: g.color)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: g.current / g.target,
                        backgroundColor: Colors.grey.shade100,
                        valueColor: AlwaysStoppedAnimation(g.color),
                        minHeight: 6,
                      ),
                    ),
                  ],
                ),
              )).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeeklyOverview() {
    final days = ['MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT', 'SUN'];
    final values = [0.4, 0.6, 0.5, 1.0, 0.7, 0.3, 0.2];
    final today = 3; // THU

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Weekly Overview', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Color(0xFF1A2E25))),
          const Text('Your activity over the last 7 days', style: TextStyle(fontSize: 12, color: Color(0xFF6B8C7A))),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8)],
            ),
            child: Column(
              children: [
                SizedBox(
                  height: 100,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: List.generate(7, (i) {
                      final isToday = i == today;
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            width: 28,
                            height: 80 * values[i],
                            decoration: BoxDecoration(
                              color: isToday ? _primaryGreen : const Color(0xFFB8D9C8),
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                        ],
                      );
                    }),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: days.asMap().entries.map((e) => Text(
                    e.value,
                    style: TextStyle(
                      fontSize: 9,
                      color: e.key == today ? _primaryGreen : Colors.grey.shade400,
                      fontWeight: e.key == today ? FontWeight.w700 : FontWeight.w400,
                    ),
                  )).toList(),
                ),
                const Divider(height: 20),
                Row(
                  children: [
                    Container(width: 10, height: 10, decoration: BoxDecoration(color: _primaryGreen, borderRadius: BorderRadius.circular(3))),
                    const SizedBox(width: 6),
                    const Text('Completed', style: TextStyle(fontSize: 11, color: Color(0xFF6B8C7A))),
                    const SizedBox(width: 16),
                    Container(width: 10, height: 10, decoration: BoxDecoration(color: Color(0xFFB8D9C8), borderRadius: BorderRadius.circular(3))),
                    const SizedBox(width: 6),
                    const Text('Target', style: TextStyle(fontSize: 11, color: Color(0xFF6B8C7A))),
                    const Spacer(),
                    const Text('Average: 65 pts', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF1B5E45))),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHadithBanner() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF1B5E45), Color(0xFF2E7D5E)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            const Text(
              '"The most beloved of deeds to Allah are those that are most consistent, even if they are small."',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.white, fontStyle: FontStyle.italic, height: 1.5),
            ),
            const SizedBox(height: 12),
            Text('— Prophet Muhammad ﷺ',
                style: TextStyle(fontSize: 12, color: Colors.white.withValues(alpha: 0.8), fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }
}

class _GoalItem {
  final IconData icon;
  final String label;
  final int current;
  final int target;
  final Color color;
  const _GoalItem({required this.icon, required this.label, required this.current, required this.target, required this.color});
}