// lib/features/home/screens/home_screen.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:intl/intl.dart';
import '../../prayer/providers/prayer_provider.dart';
import '../../auth/providers/auth_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedTab = 0;

  static const Color _primaryGreen = Color(0xFF1B5E45);
  static const Color _bgColor = Color(0xFFEFF4F1);

  final List<_NavItem> _navItems = const [
    _NavItem(icon: Icons.home_rounded, label: 'Home'),
    _NavItem(icon: Icons.menu_book_rounded, label: 'Quran'),
    _NavItem(icon: Icons.access_time_rounded, label: 'Prayer'),
    _NavItem(icon: Icons.people_alt_rounded, label: 'Community'),
    _NavItem(icon: Icons.trending_up_rounded, label: 'Progress'),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PrayerProvider>().fetchPrayerTimes();
    });
  }

  void _onTabTapped(int index) {
    setState(() => _selectedTab = index);
    switch (index) {
      case 1: context.push('/quran'); break;
      case 2: context.push('/prayer'); break;
      case 3: context.push('/community'); break;
      case 4: context.push('/progress'); break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().user;
    final userName = user?['full_name'] ?? 'Beloved';

    final hijri = HijriCalendar.now();
    final hijriStr = '${hijri.hDay} ${hijri.longMonthName} ${hijri.hYear}';
    final now = DateTime.now();
    final gregStr = DateFormat('MMMM dd, yyyy').format(now);

    return Scaffold(
      backgroundColor: _bgColor,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(bottom: 16),
                child: Column(
                  children: [
                    _buildTopBar(userName, hijriStr),
                    const SizedBox(height: 16),
                    _buildNextPrayerCard(gregStr),
                    const SizedBox(height: 20),
                    _buildQuickActions(),
                    const SizedBox(height: 20),
                    _buildTodaysPrayers(),
                    const SizedBox(height: 20),
                    _buildBanner(),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ),
            _buildBottomNav(),
          ],
        ),
      ),
    );
  }

  // ── Top bar ───────────────────────────────────────────────────────────────
  Widget _buildTopBar(String userName, String hijriStr) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'As-salamu Alaykum,',
                style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
              ),
              Text(
                userName,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1A2E25),
                ),
              ),
            ],
          ),
          const Spacer(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                hijriStr,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF1B5E45),
                ),
              ),
            ],
          ),
          const SizedBox(width: 12),
          _iconButton(Icons.notifications_none_rounded, () {}),
          const SizedBox(width: 8),
          _iconButton(Icons.person_outline_rounded, () => context.push('/profile')),
        ],
      ),
    );
  }

  Widget _iconButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 8),
          ],
        ),
        child: Icon(icon, size: 18, color: const Color(0xFF1A2E25)),
      ),
    );
  }

  // ── Next Prayer Card ──────────────────────────────────────────────────────
  Widget _buildNextPrayerCard(String gregStr) {
    return Consumer<PrayerProvider>(
      builder: (context, provider, _) {
        final nextPrayer = provider.nextPrayer;
        final nextTime = provider.nextPrayerTime ?? '--:--';
        final timeUntil = provider.timeUntilNextPrayer ?? '';

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF1B5E45), Color(0xFF2E7D5E)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF1B5E45).withValues(alpha: 0.3),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'Next Prayer',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.white.withValues(alpha: 0.9),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Text(
                      gregStr,
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.white.withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      nextTime,
                      style: const TextStyle(
                        fontSize: 44,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        height: 1,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            nextPrayer ?? 'Asr',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            timeUntil,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.white.withValues(alpha: 0.7),
                            ),
                          ),
                        ],
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

  // ── Quick Actions ─────────────────────────────────────────────────────────
  Widget _buildQuickActions() {
    final actions = [
      _QuickAction(icon: Icons.menu_book_rounded,               label: 'Read Quran',    sub: 'Continue reading', route: '/quran',       color: const Color(0xFF1B5E45)),
      _QuickAction(icon: Icons.access_time_rounded,             label: 'Prayer Times',  sub: 'View schedule',    route: '/prayer',      color: const Color(0xFF2E7D5E)),
      _QuickAction(icon: Icons.rotate_right_rounded,            label: 'Dhikr Counter', sub: 'Dhikr & Tasbeeh',  route: '/dhikr',       color: const Color(0xFF3A8C6E)),
      _QuickAction(icon: Icons.sentiment_satisfied_alt_rounded, label: 'Mood Guidance', sub: 'How are you?',     route: '/growth/mood', color: const Color(0xFF4D7C6A)),
      _QuickAction(icon: Icons.calendar_today_rounded,          label: 'Calendar',      sub: 'Islamic events',   route: '/calendar',    color: const Color(0xFF1B5E45)),
      _QuickAction(icon: Icons.school_rounded,                  label: 'Scholar Q&A',   sub: 'Ask a question',   route: '/scholar',     color: const Color(0xFF2E7D5E)),
      _QuickAction(icon: Icons.people_alt_rounded,              label: 'Community',     sub: 'Join circles',     route: '/community',   color: const Color(0xFF3A8C6E)),
      _QuickAction(icon: Icons.trending_up_rounded,             label: 'Your Progress', sub: 'Track goals',      route: '/progress',    color: const Color(0xFF4D7C6A)),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 0.82,
        ),
        itemCount: actions.length,
        itemBuilder: (context, i) => _buildActionTile(actions[i]),
      ),
    );
  }

  Widget _buildActionTile(_QuickAction action) {
    return GestureDetector(
      onTap: () => context.push(action.route),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 8, offset: const Offset(0, 2)),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: action.color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(action.icon, size: 20, color: action.color),
            ),
            const SizedBox(height: 6),
            Text(
              action.label,
              textAlign: TextAlign.center,
              maxLines: 2,
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1A2E25),
                height: 1.2,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Today's Prayers ───────────────────────────────────────────────────────
  Widget _buildTodaysPrayers() {
    return Consumer<PrayerProvider>(
      builder: (context, provider, _) {
        if (provider.isLoading) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(24),
              child: CircularProgressIndicator(color: Color(0xFF1B5E45)),
            ),
          );
        }

        final prayers = provider.todaysPrayers;

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Today's Prayers",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Color(0xFF1A2E25)),
              ),
              const SizedBox(height: 12),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 2)),
                  ],
                ),
                child: prayers.isEmpty
                    ? const Padding(
                        padding: EdgeInsets.all(20),
                        child: Center(
                          child: Text(
                            'Prayer times unavailable.\nCheck your location settings.',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Color(0xFF6B8C7A), fontSize: 13),
                          ),
                        ),
                      )
                    : ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: prayers.length,
                        separatorBuilder: (_, __) => Divider(
                          height: 1,
                          color: Colors.grey.shade100,
                          indent: 56,
                        ),
                        itemBuilder: (context, i) {
                          final p = prayers[i];
                          final isNext = p['name'] == provider.nextPrayer;
                          final isLogged = p['logged'] == true;
                          return _PrayerRow(
                            name: p['name'],
                            time: p['time'],
                            isNext: isNext,
                            isLogged: isLogged,
                            onLog: () => provider.logPrayer(p['name']),
                          );
                        },
                      ),
              ),
            ],
          ),
        );
      },
    );
  }

  // ── Banner ────────────────────────────────────────────────────────────────
  Widget _buildBanner() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        height: 160,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: const Color(0xFF1B5E45), // ✅ plain color, removed broken DecorationImage
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              colors: [
                Colors.black.withValues(alpha: 0.45),
                Colors.black.withValues(alpha: 0.1),
              ],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
            ),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(                              // ✅ non-const so textDirection works
                'إِنَّ اللَّهَ مَعَ الصَّابِرِينَ',
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.right,
              ),
              const SizedBox(height: 4),
              const Text(
                '"Truly, with hardship comes ease"',
                style: TextStyle(fontSize: 12, color: Colors.white70, fontStyle: FontStyle.italic),
              ),
              const SizedBox(height: 6),
              Text(
                'Surah Ash-Sharh 94:6',
                style: TextStyle(fontSize: 11, color: Colors.white.withValues(alpha: 0.6)),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  _bannerAction(Icons.share_outlined),
                  const SizedBox(width: 8),
                  _bannerAction(Icons.favorite_border_rounded),
                  const SizedBox(width: 8),
                  _bannerAction(Icons.bookmark_border_rounded),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _bannerAction(IconData icon) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(icon, size: 16, color: Colors.white),
    );
  }

  // ── Bottom Nav ────────────────────────────────────────────────────────────
  Widget _buildBottomNav() {
    return Container(
      height: 64,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 12, offset: const Offset(0, -2)),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(_navItems.length, (i) {
          final item = _navItems[i];
          final isSelected = i == _selectedTab;
          return GestureDetector(
            onTap: () => _onTabTapped(i),
            behavior: HitTestBehavior.opaque,
            child: SizedBox(
              width: 60,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(item.icon, size: 22, color: isSelected ? _primaryGreen : Colors.grey.shade400),
                  const SizedBox(height: 3),
                  Text(
                    item.label,
                    style: TextStyle(
                      fontSize: 10,
                      color: isSelected ? _primaryGreen : Colors.grey.shade400,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 2),
                  if (isSelected)
                    Container(
                      width: 4,
                      height: 4,
                      decoration: const BoxDecoration(color: _primaryGreen, shape: BoxShape.circle),
                    ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}

// ── Prayer Row ────────────────────────────────────────────────────────────
class _PrayerRow extends StatelessWidget {
  final String name;
  final String time;
  final bool isNext;
  final bool isLogged;
  final VoidCallback onLog;

  const _PrayerRow({
    required this.name,
    required this.time,
    required this.isNext,
    required this.isLogged,
    required this.onLog,
  });

  static const Color _primaryGreen = Color(0xFF1B5E45);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: isNext
          ? BoxDecoration(color: _primaryGreen.withValues(alpha: 0.05))
          : null,
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: isNext ? _primaryGreen.withValues(alpha: 0.1) : Colors.grey.shade100,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(Icons.mosque_rounded, size: 18, color: isNext ? _primaryGreen : Colors.grey.shade400),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              name,
              style: TextStyle(
                fontSize: 14,
                fontWeight: isNext ? FontWeight.w600 : FontWeight.w500,
                color: isNext ? _primaryGreen : const Color(0xFF1A2E25),
              ),
            ),
          ),
          Text(
            time,
            style: TextStyle(
              fontSize: 13,
              color: isNext ? _primaryGreen : Colors.grey.shade500,
              fontWeight: isNext ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
          const SizedBox(width: 12),
          GestureDetector(
            onTap: isLogged ? null : onLog,
            child: Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: isLogged ? _primaryGreen : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                isLogged ? Icons.check_rounded : Icons.add_rounded,
                size: 16,
                color: isLogged ? Colors.white : Colors.grey.shade400,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Data models ───────────────────────────────────────────────────────────
class _NavItem {
  final IconData icon;
  final String label;
  const _NavItem({required this.icon, required this.label});
}

class _QuickAction {
  final IconData icon;
  final String label;
  final String sub;
  final String route;
  final Color color;
  const _QuickAction({
    required this.icon,
    required this.label,
    required this.sub,
    required this.route,
    required this.color,
  });
}