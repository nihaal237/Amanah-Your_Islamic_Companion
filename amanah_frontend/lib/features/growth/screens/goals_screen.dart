// lib/features/growth/screens/goals_screen.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../providers/growth_provider.dart';

class GoalsScreen extends StatefulWidget {
  const GoalsScreen({super.key});

  @override
  State<GoalsScreen> createState() => _GoalsScreenState();
}

class _GoalsScreenState extends State<GoalsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  static const Color _primaryGreen = Color(0xFF1B5E45);
  static const Color _bgColor = Color(0xFFEFF4F1);

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<GrowthProvider>().fetchGoals();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgColor,
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCreateGoalSheet(context),
        backgroundColor: _primaryGreen,
        child: const Icon(Icons.add_rounded, color: Colors.white),
      ),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            const SizedBox(height: 16),
            _buildStats(),
            const SizedBox(height: 16),
            _buildTabs(),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildActiveGoals(),
                  _buildCompletedGoals(),
                ],
              ),
            ),
          ],
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
              child: Text('My Goals', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Color(0xFF1A2E25))),
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

  Widget _buildStats() {
    return Consumer<GrowthProvider>(
      builder: (context, provider, _) {
        final active = provider.goals.where((g) => g['is_active'] == true).length;
        final completed = provider.completedGoals.length;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              Expanded(child: _statCard(Icons.flag_rounded, '$active', 'Active Goals', _primaryGreen)),
              const SizedBox(width: 12),
              Expanded(child: _statCard(Icons.check_circle_rounded, '$completed', 'Completed', const Color(0xFF4CAF50))),
              const SizedBox(width: 12),
              Expanded(child: _statCard(Icons.local_fire_department_rounded, '${provider.streak ?? 0}', 'Day Streak', Colors.orange)),
            ],
          ),
        );
      },
    );
  }

  Widget _statCard(IconData icon, String value, String label, Color color) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8)],
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 6),
          Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: Color(0xFF1A2E25))),
          Text(label, textAlign: TextAlign.center, style: const TextStyle(fontSize: 10, color: Color(0xFF6B8C7A), height: 1.2)),
        ],
      ),
    );
  }

  Widget _buildTabs() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        height: 40,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: const Color(0xFFE0EBE5)),
        ),
        child: TabBar(
          controller: _tabController,
          indicator: BoxDecoration(color: _primaryGreen, borderRadius: BorderRadius.circular(8)),
          indicatorSize: TabBarIndicatorSize.tab,
          dividerColor: Colors.transparent,
          labelColor: Colors.white,
          unselectedLabelColor: const Color(0xFF6B8C7A),
          labelStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
          tabs: const [Tab(text: 'Active'), Tab(text: 'Completed')],
        ),
      ),
    );
  }

  Widget _buildActiveGoals() {
    return Consumer<GrowthProvider>(
      builder: (context, provider, _) {
        if (provider.isLoading) {
          return const Center(child: CircularProgressIndicator(color: _primaryGreen));
        }
        final active = provider.goals.where((g) => g['is_active'] == true || g['is_active'] == null).toList();
        if (active.isEmpty) {
          return _emptyState('No active goals yet', 'Tap + to create your first spiritual goal', Icons.flag_outlined);
        }
        return RefreshIndicator(
          color: _primaryGreen,
          onRefresh: () => provider.fetchGoals(),
          child: ListView.builder(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 80),
            itemCount: active.length,
            itemBuilder: (context, i) => _GoalCard(
              goal: active[i],
              onComplete: () => provider.completeGoal(active[i]['id']),
              onDelete: () => provider.deleteGoal(active[i]['id'].toString()),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCompletedGoals() {
    return Consumer<GrowthProvider>(
      builder: (context, provider, _) {
        final completed = provider.completedGoals;
        if (completed.isEmpty) {
          return _emptyState('No completed goals', 'Complete your active goals to see them here', Icons.check_circle_outline_rounded);
        }
        return ListView.builder(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
          itemCount: completed.length,
          itemBuilder: (context, i) => _GoalCard(goal: completed[i], isCompleted: true),
        );
      },
    );
  }

  Widget _emptyState(String title, String sub, IconData icon) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 56, color: Colors.grey.shade300),
            const SizedBox(height: 16),
            Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF6B8C7A))),
            const SizedBox(height: 6),
            Text(sub, textAlign: TextAlign.center, style: const TextStyle(fontSize: 13, color: Color(0xFFADBFB5))),
          ],
        ),
      ),
    );
  }

  void _showCreateGoalSheet(BuildContext context) {
    final controller = TextEditingController();
    final categoryNotifier = ValueNotifier<String>('Prayer');
    final categories = ['Prayer', 'Quran', 'Dhikr', 'Charity', 'Learning', 'Health', 'Other'];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2)))),
              const SizedBox(height: 20),
              const Text('Create a New Goal', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Color(0xFF1A2E25))),
              const SizedBox(height: 4),
              const Text('Set a spiritual goal to track your progress', style: TextStyle(fontSize: 12, color: Color(0xFF6B8C7A))),
              const SizedBox(height: 20),
              const Text('Goal Title', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Color(0xFF3D5A4C))),
              const SizedBox(height: 8),
              TextField(
                controller: controller,
                style: const TextStyle(fontSize: 14, color: Color(0xFF1A2E25)),
                decoration: InputDecoration(
                  hintText: 'e.g. Read 1 page of Quran daily',
                  hintStyle: const TextStyle(color: Color(0xFFADBFB5), fontSize: 13),
                  filled: true, fillColor: const Color(0xFFF7FAF8),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFFE0EBE5))),
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFFE0EBE5))),
                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: _primaryGreen, width: 1.5)),
                ),
              ),
              const SizedBox(height: 16),
              const Text('Category', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Color(0xFF3D5A4C))),
              const SizedBox(height: 8),
              ValueListenableBuilder<String>(
                valueListenable: categoryNotifier,
                builder: (_, selected, __) => Wrap(
                  spacing: 8, runSpacing: 8,
                  children: categories.map((c) => GestureDetector(
                    onTap: () => categoryNotifier.value = c,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: selected == c ? _primaryGreen : const Color(0xFFF7FAF8),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: selected == c ? _primaryGreen : const Color(0xFFE0EBE5)),
                      ),
                      child: Text(c, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500,
                          color: selected == c ? Colors.white : const Color(0xFF6B8C7A))),
                    ),
                  )).toList(),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () {
                    if (controller.text.trim().isEmpty) return;
                    context.read<GrowthProvider>().createGoal(controller.text.trim());
                    Navigator.of(ctx).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _primaryGreen,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Create Goal', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GoalCard extends StatelessWidget {
  final Map<String, dynamic> goal;
  final VoidCallback? onComplete;
  final VoidCallback? onDelete;
  final bool isCompleted;

  const _GoalCard({required this.goal, this.onComplete, this.onDelete, this.isCompleted = false});

  static const Color _primaryGreen = Color(0xFF1B5E45);

  @override
  Widget build(BuildContext context) {
    final title = goal['title'] ?? goal['name'] ?? 'Goal';
    final category = goal['category'] ?? '';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: isCompleted ? Border.all(color: const Color(0xFF4CAF50).withValues(alpha: 0.3)) : null,
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8)],
      ),
      child: Row(
        children: [
          Container(
            width: 40, height: 40,
            decoration: BoxDecoration(
              color: isCompleted ? const Color(0xFF4CAF50).withValues(alpha: 0.1) : const Color(0xFFE8F4EE),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              isCompleted ? Icons.check_circle_rounded : Icons.flag_rounded,
              color: isCompleted ? const Color(0xFF4CAF50) : _primaryGreen,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(
                  fontSize: 14, fontWeight: FontWeight.w600,
                  color: isCompleted ? Colors.grey.shade500 : const Color(0xFF1A2E25),
                  decoration: isCompleted ? TextDecoration.lineThrough : null,
                )),
                if (category.isNotEmpty)
                  Text(category, style: const TextStyle(fontSize: 11, color: Color(0xFF6B8C7A))),
              ],
            ),
          ),
          if (!isCompleted && onComplete != null)
            GestureDetector(
              onTap: onComplete,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(color: _primaryGreen, borderRadius: BorderRadius.circular(10)),
                child: const Text('Done', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Colors.white)),
              ),
            ),
          if (!isCompleted && onDelete != null) ...[
            const SizedBox(width: 8),
            GestureDetector(
              onTap: onDelete,
              child: Icon(Icons.delete_outline_rounded, size: 18, color: Colors.grey.shade400),
            ),
          ],
        ],
      ),
    );
  }
}