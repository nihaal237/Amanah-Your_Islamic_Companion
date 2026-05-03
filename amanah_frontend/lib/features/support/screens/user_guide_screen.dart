// lib/features/support/screens/user_guide_screen.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class UserGuideScreen extends StatefulWidget {
  const UserGuideScreen({super.key});

  @override
  State<UserGuideScreen> createState() => _UserGuideScreenState();
}

class _UserGuideScreenState extends State<UserGuideScreen> {
  final _searchController = TextEditingController();
  int? _expandedSection;
  String _query = '';

  static const Color _primaryGreen = Color(0xFF1B5E45);
  static const Color _bgColor = Color(0xFFEFF4F1);

  final List<_GuideSection> _sections = const [
    _GuideSection(
      icon: Icons.menu_book_rounded,
      title: 'Quran Reading',
      sub: 'Translation, Audio & Bookmarks',
      steps: [
        'Select a Surah or Juz from the main directory',
        'Long-press an Ayah to bookmark or share',
        'Tap the headphones icon for high-quality recitations',
      ],
    ),
    _GuideSection(
      icon: Icons.rotate_right_rounded,
      title: 'Daily Dhikr',
      sub: 'Digital Tasbeeh & Morning/Evening Adhkar',
      body: 'Stay connected through remembrance. Our Dhikr module provides a haptic-feedback Tasbeeh counter and authenticated morning and evening supplications.',
      tip: 'Pro Tip: Double-tap the counter to reset your daily goal.',
    ),
    _GuideSection(
      icon: Icons.mosque_rounded,
      title: 'Prayer Tracking',
      sub: 'Prayer Times, Qibla & History',
      steps: null,
    ),
    _GuideSection(
      icon: Icons.volunteer_activism_rounded,
      title: 'Community Giving',
      sub: 'Zakat calculator & charity portal',
      steps: null,
    ),
  ];

  List<_GuideSection> get _filteredSections {
    if (_query.isEmpty) return _sections;
    return _sections.where((s) =>
      s.title.toLowerCase().contains(_query) ||
      s.sub.toLowerCase().contains(_query)
    ).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
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
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                child: Column(
                  children: [
                    _buildHeroCard(),
                    const SizedBox(height: 16),
                    _buildSearch(),
                    const SizedBox(height: 16),
                    ..._filteredSections.asMap().entries.map((e) => _buildSectionTile(e.key, e.value)),
                    const SizedBox(height: 16),
                    _buildContactBanner(),
                  ],
                ),
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
              child: Text('User Guide',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Color(0xFF1A2E25))),
            ),
          ),
          Icon(Icons.more_vert_rounded, color: Colors.grey.shade400),
        ],
      ),
    );
  }

  Widget _buildHeroCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8)],
      ),
      child: Column(
        children: [
          Container(
            width: 48, height: 48,
            decoration: BoxDecoration(color: const Color(0xFFE8F4EE), borderRadius: BorderRadius.circular(12)),
            child: const Icon(Icons.auto_stories_rounded, color: _primaryGreen, size: 24),
          ),
          const SizedBox(height: 12),
          const Text('User Guide',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: Color(0xFF1A2E25))),
          const SizedBox(height: 4),
          const Text('Master your spiritual journey with Amanah',
              style: TextStyle(fontSize: 12, color: Color(0xFF6B8C7A))),
        ],
      ),
    );
  }

  Widget _buildSearch() {
    return TextField(
      controller: _searchController,
      onChanged: (v) => setState(() => _query = v.toLowerCase()),
      style: const TextStyle(fontSize: 14, color: Color(0xFF1A2E25)),
      decoration: InputDecoration(
        hintText: 'Search features or topics...',
        hintStyle: const TextStyle(color: Color(0xFFADBFB5), fontSize: 13),
        prefixIcon: const Icon(Icons.search_rounded, color: Color(0xFFADBFB5), size: 20),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE0EBE5))),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE0EBE5))),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF2E7D5E), width: 1.5)),
      ),
    );
  }

  Widget _buildSectionTile(int index, _GuideSection section) {
    final isExpanded = _expandedSection == index;
    return GestureDetector(
      onTap: () => setState(() => _expandedSection = isExpanded ? null : index),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8)],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  Container(
                    width: 36, height: 36,
                    decoration: BoxDecoration(color: const Color(0xFFE8F4EE), borderRadius: BorderRadius.circular(10)),
                    child: Icon(section.icon, color: _primaryGreen, size: 18),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(section.title,
                            style: TextStyle(
                              fontSize: 13, fontWeight: FontWeight.w700,
                              color: isExpanded ? _primaryGreen : const Color(0xFF1A2E25),
                            )),
                        Text(section.sub, style: const TextStyle(fontSize: 11, color: Color(0xFF6B8C7A))),
                      ],
                    ),
                  ),
                  Icon(
                    isExpanded ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded,
                    color: Colors.grey.shade400,
                  ),
                ],
              ),
            ),
            if (isExpanded) ...[
              Divider(height: 1, color: Colors.grey.shade100),
              Padding(
                padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (section.steps != null) ...[
                      const Text('How to use:', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF3D5A4C))),
                      const SizedBox(height: 8),
                      ...section.steps!.map((step) => Padding(
                        padding: const EdgeInsets.only(bottom: 6),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.check_circle_rounded, size: 14, color: _primaryGreen),
                            const SizedBox(width: 8),
                            Expanded(child: Text(step, style: const TextStyle(fontSize: 12, color: Color(0xFF5A7A68), height: 1.4))),
                          ],
                        ),
                      )),
                    ],
                    if (section.body != null) ...[
                      Text(section.body!, style: const TextStyle(fontSize: 12, color: Color(0xFF5A7A68), height: 1.5)),
                    ],
                    if (section.tip != null) ...[
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE8F4EE),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(section.tip!,
                            style: const TextStyle(fontSize: 11, color: _primaryGreen, fontWeight: FontWeight.w500)),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildContactBanner() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1B5E45),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Still need help?', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Colors.white)),
                SizedBox(height: 4),
                Text('Talk to our 24/7 support team', style: TextStyle(fontSize: 11, color: Colors.white70)),
              ],
            ),
          ),
          GestureDetector(
            onTap: () => context.push('/support/email'),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
              child: const Text('Contact Us',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF1B5E45))),
            ),
          ),
        ],
      ),
    );
  }
}

class _GuideSection {
  final IconData icon;
  final String title, sub;
  final List<String>? steps;
  final String? body, tip;
  const _GuideSection({required this.icon, required this.title, required this.sub, this.steps, this.body, this.tip});
}