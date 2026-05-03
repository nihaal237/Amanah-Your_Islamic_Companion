// lib/features/quran/screens/surah_screen.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../providers/quran_provider.dart';
import '../../../core/services/api_service.dart';
import '../../../core/constants/api_constants.dart';

class SurahScreen extends StatefulWidget {
  final int surahId;
  const SurahScreen({super.key, required this.surahId});

  @override
  State<SurahScreen> createState() => _SurahScreenState();
}

class _SurahScreenState extends State<SurahScreen> {
  Map<String, dynamic>? _surah;
  List<Map<String, dynamic>> _ayahs = [];
  bool _isLoading = true;
  bool _isPlaying = false;
  int _currentAyah = 1;

  static const Color _primaryGreen = Color(0xFF1B5E45);
  static const Color _bgColor = Color(0xFFEFF4F1);

  @override
  void initState() {
    super.initState();
    _fetchSurah();
  }

  Future<void> _fetchSurah() async {
    try {
      final response = await ApiService.get('${ApiConstants.surah}${widget.surahId}/');
      final data = response.data as Map<String, dynamic>;
      setState(() {
        _surah = data;
        _ayahs = (data['ayahs'] as List? ?? []).cast<Map<String, dynamic>>();
        _isLoading = false;
      });
      // Update last read in provider
      context.read<QuranProvider>().updateLastRead({
        'surah_number': widget.surahId,
        'surah_name': data['english_name'] ?? '',
        'ayah': 1,
      });
    } catch (_) {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgColor,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator(color: _primaryGreen))
                  : _buildAyahList(),
            ),
            _buildAudioPlayer(),
          ],
        ),
      ),
    );
  }

  // ── Header ────────────────────────────────────────────────────────────────
  Widget _buildHeader() {
    final name = _surah?['english_name'] ?? 'Surah';
    final meaning = _surah?['english_name_translation'] ?? '';
    final ayahCount = _surah?['number_of_ayahs']?.toString() ?? '';
    final type = _surah?['revelation_type'] ?? '';
    final number = _surah?['number']?.toString() ?? '';

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: Column(
        children: [
          // Top bar
          Row(
            children: [
              GestureDetector(
                onTap: () => context.pop(),
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F5F5),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.arrow_back_rounded, size: 18, color: Color(0xFF1A2E25)),
                ),
              ),
              const Expanded(
                child: Center(
                  child: Text(
                    'Quran Surahs',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Color(0xFF1A2E25)),
                  ),
                ),
              ),
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(color: _primaryGreen, borderRadius: BorderRadius.circular(8)),
                child: const Center(
                  child: Text('IA', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Colors.white)),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Surah info
          Container(
            width: double.infinity,
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
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'SURAH $number',
                    style: const TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.w600, letterSpacing: 1),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  name,
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: Colors.white),
                ),
                Text(
                  '$meaning · $ayahCount Ayahs · $type',
                  style: TextStyle(fontSize: 12, color: Colors.white.withValues(alpha: 0.8)),
                ),
                const SizedBox(height: 14),
                // Bismillah
                Text(
                  'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white.withValues(alpha: 0.9),
                    fontWeight: FontWeight.w500,
                    height: 1.6,
                  ),
                  textDirection: TextDirection.rtl,
                ),
                Text(
                  'In the name of Allah, the Entirely Merciful, the Especially Merciful.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 11, color: Colors.white.withValues(alpha: 0.7), fontStyle: FontStyle.italic),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  // ── Ayah List ─────────────────────────────────────────────────────────────
  Widget _buildAyahList() {
    if (_ayahs.isEmpty) {
      return const Center(
        child: Text('No ayahs found.', style: TextStyle(color: Color(0xFF6B8C7A))),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 120),
      itemCount: _ayahs.length,
      itemBuilder: (context, i) {
        final ayah = _ayahs[i];
        return _AyahTile(
          ayah: ayah,
          surahNumber: widget.surahId,
          isCurrentlyPlaying: _isPlaying && _currentAyah == (ayah['number_in_surah'] ?? i + 1),
          onPlay: () {
            setState(() {
              _currentAyah = ayah['number_in_surah'] ?? i + 1;
              _isPlaying = true;
            });
          },
        );
      },
    );
  }

  // ── Audio Player Bar ──────────────────────────────────────────────────────
  Widget _buildAudioPlayer() {
    final surahName = _surah?['english_name'] ?? 'Surah';

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 12, offset: const Offset(0, -2))],
      ),
      child: Row(
        children: [
          // Reciter avatar
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: const Color(0xFFE8F4EE),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.person_rounded, color: _primaryGreen, size: 22),
          ),
          const SizedBox(width: 12),
          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Mishary Rashid Alafasy',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF1A2E25)),
                ),
                Text(
                  surahName,
                  style: const TextStyle(fontSize: 11, color: Color(0xFF6B8C7A)),
                ),
              ],
            ),
          ),
          // Controls
          Row(
            children: [
              _playerBtn(Icons.skip_previous_rounded, () {}),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () => setState(() => _isPlaying = !_isPlaying),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: const BoxDecoration(
                    color: _primaryGreen,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    _isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                    color: Colors.white,
                    size: 22,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              _playerBtn(Icons.skip_next_rounded, () {}),
            ],
          ),
        ],
      ),
    );
  }

  Widget _playerBtn(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Icon(icon, size: 22, color: const Color(0xFF6B8C7A)),
    );
  }
}

// ── Ayah Tile ──────────────────────────────────────────────────────────────
class _AyahTile extends StatelessWidget {
  final Map<String, dynamic> ayah;
  final int surahNumber;
  final bool isCurrentlyPlaying;
  final VoidCallback onPlay;

  const _AyahTile({
    required this.ayah,
    required this.surahNumber,
    required this.isCurrentlyPlaying,
    required this.onPlay,
  });

  static const Color _primaryGreen = Color(0xFF1B5E45);

  @override
  Widget build(BuildContext context) {
    final provider = context.read<QuranProvider>();
    final numberInSurah = ayah['number_in_surah'] ?? 0;
    final arabic = ayah['text'] ?? '';
    final english = ayah['translation'] ?? ayah['english'] ?? '';
    final isBookmarked = provider.isBookmarked(surahNumber, numberInSurah);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: isCurrentlyPlaying
            ? Border.all(color: _primaryGreen, width: 1.5)
            : null,
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Ayah number
          Row(
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: _primaryGreen.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    '$numberInSurah',
                    style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: _primaryGreen),
                  ),
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () {
                  if (isBookmarked) {
                    final id = provider.bookmarkIdFor(surahNumber, numberInSurah);
                    if (id != null) provider.deleteBookmark(id);
                  } else {
                    provider.addBookmark(surahNumber: surahNumber, ayahNumber: numberInSurah);
                  }
                },
                child: Icon(
                  isBookmarked ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
                  size: 20,
                  color: isBookmarked ? _primaryGreen : Colors.grey.shade400,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Arabic text
          Text(
            arabic,
            textAlign: TextAlign.right,
            textDirection: TextDirection.rtl,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w500,
              color: Color(0xFF1A2E25),
              height: 1.8,
              fontFamily: 'serif',
            ),
          ),

          const SizedBox(height: 10),

          // English translation
          if (english.isNotEmpty)
            Text(
              english,
              style: const TextStyle(fontSize: 13, color: Color(0xFF5A7A68), height: 1.5),
            ),

          const SizedBox(height: 12),

          // Play + Copy
          Row(
            children: [
              _SmallBtn(icon: Icons.play_circle_outline_rounded, label: 'Play', onTap: onPlay, filled: isCurrentlyPlaying),
              const SizedBox(width: 8),
              _SmallBtn(icon: Icons.copy_rounded, label: 'Copy', onTap: () {}, filled: false),
            ],
          ),
        ],
      ),
    );
  }
}

class _SmallBtn extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool filled;

  const _SmallBtn({required this.icon, required this.label, required this.onTap, required this.filled});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: filled ? const Color(0xFF1B5E45) : const Color(0xFFF0F5F2),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 13, color: filled ? Colors.white : const Color(0xFF1B5E45)),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: filled ? Colors.white : const Color(0xFF1B5E45)),
            ),
          ],
        ),
      ),
    );
  }
}