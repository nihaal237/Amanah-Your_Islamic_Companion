// lib/features/growth/screens/mood_screen.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MoodScreen extends StatefulWidget {
  const MoodScreen({super.key});

  @override
  State<MoodScreen> createState() => _MoodScreenState();
}

class _MoodScreenState extends State<MoodScreen> {
  String? _selectedMood;

  static const Color _primaryGreen = Color(0xFF1B5E45);
  static const Color _bgColor = Color(0xFFEFF4F1);

  final List<_MoodOption> _moods = const [
    _MoodOption(emoji: '🤲', label: 'Grateful',  color: Color(0xFF4CAF50)),
    _MoodOption(emoji: '😟', label: 'Anxious',   color: Color(0xFFFF9800)),
    _MoodOption(emoji: '🌙', label: 'Sad',        color: Color(0xFF5C6BC0)),
    _MoodOption(emoji: '☁️', label: 'Peaceful',  color: Color(0xFF26C6DA)),
    _MoodOption(emoji: '💡', label: 'Confused',  color: Color(0xFFAB47BC)),
    _MoodOption(emoji: '✨', label: 'Hopeful',   color: Color(0xFFFFCA28)),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildHeader(context),
              const SizedBox(height: 28),
              const Text(
                'How are you feeling today?',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Color(0xFF1A2E25)),
              ),
              const SizedBox(height: 20),
              _buildMoodGrid(),
              const SizedBox(height: 24),
              _buildWisdomCard(),
              const SizedBox(height: 16),
              _buildReflectionBanner(context),
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
              child: Text('Mood Guidance',
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

  Widget _buildMoodGrid() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 12)],
        ),
        child: GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 2.2,
          ),
          itemCount: _moods.length,
          itemBuilder: (context, i) {
            final mood = _moods[i];
            final isSelected = _selectedMood == mood.label;
            return GestureDetector(
              onTap: () {
                setState(() => _selectedMood = mood.label);
                Future.delayed(const Duration(milliseconds: 300), () {
                  if (mounted) context.push('/growth/mood/${mood.label.toLowerCase()}');
                });
              },
              child: Container(
                decoration: BoxDecoration(
                  color: isSelected ? mood.color.withValues(alpha: 0.15) : const Color(0xFFF7FAF8),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: isSelected ? mood.color : Colors.transparent,
                    width: 1.5,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(mood.emoji, style: const TextStyle(fontSize: 22)),
                    const SizedBox(width: 8),
                    Text(
                      mood.label,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: isSelected ? mood.color : const Color(0xFF3D5A4C),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildWisdomCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFD0E5D8)),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8)],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.auto_awesome_rounded, color: _primaryGreen, size: 18),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '"Truly, in the remembrance of Allah do hearts find rest." (13:28)',
                    style: TextStyle(fontSize: 13, color: Color(0xFF1A2E25), height: 1.5, fontStyle: FontStyle.italic),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'DAILY WISDOM',
                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: _primaryGreen, letterSpacing: 1),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReflectionBanner(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        height: 130,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: const LinearGradient(
            colors: [Color(0xFF1B5E45), Color(0xFF2E7D5E)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            const Text('Quiet Reflection',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white)),
            const Text('Guided dhikr for times of reflection',
                style: TextStyle(fontSize: 12, color: Colors.white70)),
            const SizedBox(height: 8),
            Text('SPIRITUAL SAFE WORK',
                style: TextStyle(fontSize: 9, color: Colors.white.withValues(alpha: 0.5), letterSpacing: 1.5, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}

class _MoodOption {
  final String emoji;
  final String label;
  final Color color;
  const _MoodOption({required this.emoji, required this.label, required this.color});
}