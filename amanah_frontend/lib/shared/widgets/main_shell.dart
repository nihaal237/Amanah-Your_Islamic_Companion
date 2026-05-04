// lib/shared/widgets/main_shell.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MainShell extends StatelessWidget {
  final Widget child;
  const MainShell({super.key, required this.child});

  static const Color _primaryGreen = Color(0xFF1B5E45);

  static const List<_TabItem> _tabs = [
    _TabItem(icon: Icons.home_rounded, label: 'Home',      route: '/home'),
    _TabItem(icon: Icons.menu_book_rounded, label: 'Quran', route: '/quran'),
    _TabItem(icon: Icons.sentiment_satisfied_alt_rounded, label: 'Mood', route: '/growth/mood'),
    _TabItem(icon: Icons.tag_rounded, label: 'Dhikr',      route: '/dhikr'),
    _TabItem(icon: Icons.people_alt_rounded, label: 'Community', route: '/community'),
    _TabItem(icon: Icons.person_rounded, label: 'Profile', route: '/profile'),
  ];

  int _currentIndex(String location) {
    for (int i = 0; i < _tabs.length; i++) {
      if (location.startsWith(_tabs[i].route)) return i;
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    final currentIndex = _currentIndex(location);

    return Scaffold(
      body: child,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 12, offset: const Offset(0, -2))],
        ),
        child: SafeArea(
          child: SizedBox(
            height: 60,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(_tabs.length, (i) {
                final tab = _tabs[i];
                final isSelected = i == currentIndex;
                return GestureDetector(
                  onTap: () => context.go(tab.route),
                  behavior: HitTestBehavior.opaque,
                  child: SizedBox(
                    width: 56,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(tab.icon, size: 22, color: isSelected ? _primaryGreen : Colors.grey.shade400),
                        const SizedBox(height: 3),
                        Text(tab.label, style: TextStyle(
                          fontSize: 9,
                          color: isSelected ? _primaryGreen : Colors.grey.shade400,
                          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
                        )),
                        const SizedBox(height: 2),
                        if (isSelected)
                          Container(width: 4, height: 4,
                              decoration: const BoxDecoration(color: _primaryGreen, shape: BoxShape.circle)),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}

class _TabItem {
  final IconData icon;
  final String label, route;
  const _TabItem({required this.icon, required this.label, required this.route});
}