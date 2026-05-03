// lib/features/growth/screens/grateful_guidance_screen.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class GratefulGuidanceScreen extends StatelessWidget {
  final String mood;
  const GratefulGuidanceScreen({super.key, this.mood = 'grateful'});

  static const Color _primaryGreen = Color(0xFF1B5E45);
  static const Color _bgColor = Color(0xFFEFF4F1);

  // Mood-specific content
  Map<String, dynamic> get _content {
    switch (mood.toLowerCase()) {
      case 'anxious':
        return {
          'arabic': 'أَلَا بِذِكْرِ اللَّهِ تَطْمَئِنُّ الْقُلُوبُ',
          'surah': 'SURAH AR-RAD [13:28]',
          'promise': 'The Peace Promise',
          'quote': '"Verily, in the remembrance of Allah do hearts find rest."',
          'actions': [
            {'icon': Icons.self_improvement_rounded, 'title': 'Recite Ayat al-Kursi', 'sub': 'A shield against anxiety'},
            {'icon': Icons.air_rounded, 'title': 'Breathing Dhikr', 'sub': 'Slow rhythmic SubhanAllah'},
            {'icon': Icons.edit_note_rounded, 'title': 'Anxiety Journal', 'sub': 'Name what worries you'},
          ],
          'wisdom': '"Anxiety is a reminder to return to Allah. Every hardship carries a hidden mercy."',
          'author': 'Ibn al-Qayyim',
        };
      case 'sad':
        return {
          'arabic': 'إِنَّ مَعَ الْعُسْرِ يُسْرًا',
          'surah': 'SURAH ASH-SHARH [94:6]',
          'promise': 'The Relief Promise',
          'quote': '"Verily, with every hardship comes ease."',
          'actions': [
            {'icon': Icons.menu_book_rounded, 'title': 'Read Surah Ad-Duha', 'sub': 'The chapter of comfort'},
            {'icon': Icons.self_improvement_rounded, 'title': 'Perform Sujud al-Shukr', 'sub': 'Prostration of gratitude'},
            {'icon': Icons.edit_note_rounded, 'title': 'Gratitude Journal', 'sub': 'List 3 hidden blessings'},
          ],
          'wisdom': '"Sadness is a cleansing of the heart. Allah is closest to the broken-hearted."',
          'author': 'Ibn Ata\'illah',
        };
      default: // grateful
        return {
          'arabic': 'لَئِن شَكَرْتُمْ لَأَزِيدَنَّكُمْ',
          'surah': 'SURAH IBRAHIM [14:7]',
          'promise': 'The Divine Promise',
          'quote': '"And [remember] when your Lord proclaimed, \'If you are grateful, I will surely increase you [in favor]; but if you deny, indeed, My punishment is severe.\'"',
          'actions': [
            {'icon': Icons.menu_book_rounded, 'title': 'Read Surah Ar-Rahman', 'sub': 'Reflect on the favors of your Lord'},
            {'icon': Icons.self_improvement_rounded, 'title': 'Perform Sujud al-Shukr', 'sub': 'A prostration of thankfulness'},
            {'icon': Icons.edit_note_rounded, 'title': 'Grateful Journaling', 'sub': 'List 3 hidden blessings of today'},
          ],
          'wisdom': '"Gratitude is the secret to abundance. When you focus on what you have, you find you have everything."',
          'author': 'Sarah Al-Farsi',
        };
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = _content;
    return Scaffold(
      backgroundColor: _bgColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildHeader(context),
              const SizedBox(height: 16),
              _buildAyahCard(c),
              const SizedBox(height: 16),
              _buildPromiseCard(c),
              const SizedBox(height: 20),
              _buildSpiritualActions(c),
              const SizedBox(height: 20),
              _buildCommunityWisdom(c),
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
              child: Text('Grateful Guidance',
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

  Widget _buildAyahCard(Map<String, dynamic> c) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF1B5E45), Color(0xFF2E7D5E)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          children: [
            Text(
              c['arabic'],
              textAlign: TextAlign.center,
              textDirection: TextDirection.rtl,
              style: const TextStyle(fontSize: 24, color: Colors.white, fontWeight: FontWeight.w600, height: 1.8),
            ),
            const SizedBox(height: 12),
            Text(
              c['surah'],
              style: TextStyle(fontSize: 11, color: Colors.white.withValues(alpha: 0.7), letterSpacing: 1, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPromiseCard(Map<String, dynamic> c) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8)],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 36, height: 36,
              decoration: BoxDecoration(color: const Color(0xFFE8F4EE), borderRadius: BorderRadius.circular(10)),
              child: const Icon(Icons.auto_awesome_rounded, size: 18, color: _primaryGreen),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(c['promise'], style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFF1A2E25))),
                  const SizedBox(height: 6),
                  Text(c['quote'], style: const TextStyle(fontSize: 13, color: Color(0xFF5A7A68), height: 1.5, fontStyle: FontStyle.italic)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSpiritualActions(Map<String, dynamic> c) {
    final actions = c['actions'] as List;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Spiritual Actions', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Color(0xFF1A2E25))),
              Text('3 Tasks Today', style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8)],
            ),
            child: ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: actions.length,
              separatorBuilder: (_, __) => Divider(height: 1, color: Colors.grey.shade100, indent: 56),
              itemBuilder: (context, i) {
                final a = actions[i];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  child: Row(
                    children: [
                      Container(
                        width: 36, height: 36,
                        decoration: BoxDecoration(color: const Color(0xFFE8F4EE), borderRadius: BorderRadius.circular(10)),
                        child: Icon(a['icon'] as IconData, size: 18, color: _primaryGreen),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(a['title'], style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF1A2E25))),
                            Text(a['sub'], style: const TextStyle(fontSize: 11, color: Color(0xFF6B8C7A))),
                          ],
                        ),
                      ),
                      Icon(Icons.chevron_right_rounded, color: Colors.grey.shade400, size: 18),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCommunityWisdom(Map<String, dynamic> c) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8)],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Community Wisdom', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFF1A2E25))),
            const SizedBox(height: 10),
            Text(c['wisdom'], style: const TextStyle(fontSize: 13, color: Color(0xFF5A7A68), height: 1.5, fontStyle: FontStyle.italic)),
            const SizedBox(height: 12),
            Row(
              children: [
                Container(
                  width: 28, height: 28,
                  decoration: const BoxDecoration(color: _primaryGreen, shape: BoxShape.circle),
                  child: Center(
                    child: Text(
                      (c['author'] as String).substring(0, 2).toUpperCase(),
                      style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text('— ${c['author']}', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Color(0xFF3D5A4C))),
              ],
            ),
          ],
        ),
      ),
    );
  }
}