// lib/features/community/screens/circles_screen.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../providers/community_provider.dart';

class CirclesScreen extends StatefulWidget {
  const CirclesScreen({super.key});

  @override
  State<CirclesScreen> createState() => _CirclesScreenState();
}

class _CirclesScreenState extends State<CirclesScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  static const Color _primaryGreen = Color(0xFF1B5E45);
  static const Color _bgColor = Color(0xFFEFF4F1);

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CommunityProvider>().fetchCircles();
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
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            _buildTabs(),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildAllCirclesTab(context),
                  _buildMyCirclesTab(context),
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
              child: Text('Community',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Color(0xFF1A2E25))),
            ),
          ),
          Container(
            width: 32, height: 32,
            decoration: BoxDecoration(color: _primaryGreen, borderRadius: BorderRadius.circular(8)),
            child: const Center(
              child: Text('IA', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabs() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Container(
        height: 40,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: const Color(0xFFE0EBE5)),
        ),
        child: TabBar(
          controller: _tabController,
          indicator: BoxDecoration(
            color: _primaryGreen,
            borderRadius: BorderRadius.circular(8),
          ),
          indicatorSize: TabBarIndicatorSize.tab,
          dividerColor: Colors.transparent,
          labelColor: Colors.white,
          unselectedLabelColor: const Color(0xFF6B8C7A),
          labelStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
          tabs: const [
            Tab(text: 'All Circles'),
            Tab(text: 'My Circles'),
          ],
        ),
      ),
    );
  }

  // ── All Circles Tab ───────────────────────────────────────────────────────
  Widget _buildAllCirclesTab(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildFeaturedCard(context),
          const SizedBox(height: 20),
          _buildGrowTogetherBanner(context),
          const SizedBox(height: 20),
          _buildExploreCircles(context),
        ],
      ),
    );
  }

  Widget _buildFeaturedCard(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('/community/circle/1'),
      child: Container(
        height: 180,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: const Color(0xFF1B5E45),
        ),
        child: Stack(
          children: [
            // Overlay gradient
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(
                  colors: [Colors.black.withValues(alpha: 0.6), Colors.black.withValues(alpha: 0.2)],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                ),
              ),
            ),
            // Featured badge
            Positioned(
              top: 12, left: 12,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: _primaryGreen,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text('FEATURED', style: TextStyle(fontSize: 9, fontWeight: FontWeight.w700, color: Colors.white, letterSpacing: 1)),
              ),
            ),
            // Content
            Positioned(
              bottom: 14, left: 14, right: 14,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Morning Dhikr\nGroup',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Colors.white, height: 1.2)),
                  const SizedBox(height: 6),
                  const Text('Start your day with the remembrance of Allah',
                      style: TextStyle(fontSize: 11, color: Colors.white70)),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Icon(Icons.people_rounded, size: 14, color: Colors.white.withValues(alpha: 0.8)),
                      const SizedBox(width: 4),
                      Text('1.3k members', style: TextStyle(fontSize: 11, color: Colors.white.withValues(alpha: 0.8))),
                      const Spacer(),
                      GestureDetector(
                        onTap: () => _showJoinDialog(context, 'Morning Dhikr Group', '1'),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text('Join Circle',
                              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: _primaryGreen)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGrowTogetherBanner(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Grow Together',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Color(0xFF1A2E25))),
          const SizedBox(height: 4),
          const Text('Join 15+ active circles focused on spiritual growth and learning.',
              style: TextStyle(fontSize: 12, color: Color(0xFF6B8C7A))),
          const SizedBox(height: 12),
          // Avatar stack
          Row(
            children: [
              SizedBox(
                width: 80, height: 28,
                child: Stack(
                  children: List.generate(4, (i) => Positioned(
                    left: i * 18.0,
                    child: Container(
                      width: 28, height: 28,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: [
                          const Color(0xFF1B5E45),
                          const Color(0xFF2E7D5E),
                          const Color(0xFF4CAF50),
                          const Color(0xFF81C784),
                        ][i],
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: Center(
                        child: Text(['A','B','C','+'][i],
                            style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w700, color: Colors.white)),
                      ),
                    ),
                  )),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildExploreCircles(BuildContext context) {
    final circles = [
      _CircleData(id: '1', name: 'Quran Study Circle',    members: '1.2k', tags: ['Tafsir', 'Weekly'],   desc: 'Weekly tafsir sessions and shared reflections on Surah Al-Kahf and more.'),
      _CircleData(id: '2', name: 'Daily Charity Drive',   members: '1.1k', tags: ['Charity', 'Projects'], desc: 'Small daily contributions to global causes. Transparency and community updates.'),
      _CircleData(id: '3', name: 'Mindful Muslimah',      members: '89',   tags: ['Mental Health', 'Support'], desc: 'A safe space for sisters to discuss mental health, spiritual growth, and daily life.'),
      _CircleData(id: '4', name: 'Arabic Grammar Club',   members: '211',  tags: ['Learning', 'Language'], desc: 'Learning Classical Arabic for deeper Quranic understanding. Beginners welcome.'),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Explore Circles',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Color(0xFF1A2E25))),
        const SizedBox(height: 12),
        ...circles.map((c) => _CircleCard(
          circle: c,
          onTap: () => context.push('/community/circle/${c.id}'),
          onJoin: () => _showJoinDialog(context, c.name, c.id),
        )),
      ],
    );
  }

  // ── My Circles Tab ────────────────────────────────────────────────────────
  Widget _buildMyCirclesTab(BuildContext context) {
    return Consumer<CommunityProvider>(
      builder: (context, provider, _) {
        if (provider.myCircles.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.people_outline_rounded, size: 56, color: Colors.grey.shade300),
                const SizedBox(height: 16),
                const Text('No circles joined yet',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF6B8C7A))),
                const SizedBox(height: 6),
                const Text('Join a circle to connect with the community.',
                    style: TextStyle(fontSize: 13, color: Color(0xFFADBFB5))),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () => _tabController.animateTo(0),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(color: const Color(0xFF1B5E45), borderRadius: BorderRadius.circular(20)),
                    child: const Text('Explore Circles',
                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.white)),
                  ),
                ),
              ],
            ),
          );
        }
        return ListView.builder(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          itemCount: provider.myCircles.length,
          itemBuilder: (context, i) {
            final c = provider.myCircles[i];
            return _CircleCard(
              circle: _CircleData(
                id: c['id'].toString(),
                name: c['name'] ?? '',
                members: c['members_count']?.toString() ?? '0',
                tags: [],
                desc: c['description'] ?? '',
              ),
              onTap: () => context.push('/community/circle/${c['id']}'),
              onJoin: null,
              joined: true,
            );
          },
        );
      },
    );
  }

  void _showJoinDialog(BuildContext context, String circleName, String circleId) {
    showDialog(
      context: context,
      builder: (ctx) => _JoinCircleDialog(
        circleName: circleName,
        circleId: circleId,
        onJoined: () {
          context.read<CommunityProvider>().joinCircle(circleId);
          Navigator.of(ctx).pop();
          context.push('/community/circle/$circleId');
        },
      ),
    );
  }
}

// ── Circle Card ────────────────────────────────────────────────────────────
class _CircleCard extends StatelessWidget {
  final _CircleData circle;
  final VoidCallback onTap;
  final VoidCallback? onJoin;
  final bool joined;

  const _CircleCard({required this.circle, required this.onTap, this.onJoin, this.joined = false});

  static const Color _primaryGreen = Color(0xFF1B5E45);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8)],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 40, height: 40,
                  decoration: BoxDecoration(color: const Color(0xFFE8F4EE), borderRadius: BorderRadius.circular(10)),
                  child: const Icon(Icons.groups_rounded, color: _primaryGreen, size: 22),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(circle.name,
                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFF1A2E25))),
                      Row(
                        children: [
                          Icon(Icons.people_rounded, size: 12, color: Colors.grey.shade400),
                          const SizedBox(width: 4),
                          Text('${circle.members} members',
                              style: const TextStyle(fontSize: 11, color: Color(0xFF6B8C7A))),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(circle.desc, style: const TextStyle(fontSize: 12, color: Color(0xFF6B8C7A), height: 1.4)),
            if (circle.tags.isNotEmpty) ...[
              const SizedBox(height: 8),
              Wrap(
                spacing: 6,
                children: circle.tags.map((t) => Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(color: const Color(0xFFE8F4EE), borderRadius: BorderRadius.circular(10)),
                  child: Text(t, style: const TextStyle(fontSize: 10, color: _primaryGreen, fontWeight: FontWeight.w500)),
                )).toList(),
              ),
            ],
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              height: 38,
              child: ElevatedButton(
                onPressed: joined ? onTap : onJoin,
                style: ElevatedButton.styleFrom(
                  backgroundColor: joined ? const Color(0xFFE8F4EE) : _primaryGreen,
                  foregroundColor: joined ? _primaryGreen : Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: Text(joined ? 'Open Circle' : 'Join Circle',
                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Join Circle Dialog ─────────────────────────────────────────────────────
class _JoinCircleDialog extends StatelessWidget {
  final String circleName;
  final String circleId;
  final VoidCallback onJoined;

  const _JoinCircleDialog({required this.circleName, required this.circleId, required this.onJoined});

  static const Color _primaryGreen = Color(0xFF1B5E45);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 56, height: 56,
              decoration: BoxDecoration(color: const Color(0xFFE8F4EE), shape: BoxShape.circle),
              child: const Icon(Icons.groups_rounded, color: _primaryGreen, size: 28),
            ),
            const SizedBox(height: 16),
            Text('Welcome to the\n$circleName!',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: Color(0xFF1A2E25))),
            const SizedBox(height: 8),
            const Text(
              'You\'ve successfully joined a community of knowledge and reflection. Let\'s start this journey together.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, color: Color(0xFF6B8C7A), height: 1.5),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 46,
              child: ElevatedButton(
                onPressed: onJoined,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _primaryGreen,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Start Engaging →',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
              ),
            ),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: const Text('View Circle Details',
                  style: TextStyle(fontSize: 13, color: Color(0xFF6B8C7A))),
            ),
          ],
        ),
      ),
    );
  }
}

class _CircleData {
  final String id, name, members, desc;
  final List<String> tags;
  const _CircleData({required this.id, required this.name, required this.members, required this.tags, required this.desc});
}