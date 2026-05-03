// lib/features/quran/screens/quran_bookmarks_screen.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../providers/quran_provider.dart';

class QuranBookmarksScreen extends StatefulWidget {
  const QuranBookmarksScreen({super.key});

  @override
  State<QuranBookmarksScreen> createState() => _QuranBookmarksScreenState();
}

class _QuranBookmarksScreenState extends State<QuranBookmarksScreen> {
  static const Color _primaryGreen = Color(0xFF1B5E45);
  static const Color _bgColor = Color(0xFFEFF4F1);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<QuranProvider>().fetchBookmarks();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgColor,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(child: _buildBody()),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/quran'),
        backgroundColor: _primaryGreen,
        mini: true,
        child: const Icon(Icons.search_rounded, color: Colors.white),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => context.pop(),
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 8)],
              ),
              child: const Icon(Icons.arrow_back_rounded, size: 18, color: Color(0xFF1A2E25)),
            ),
          ),
          const Spacer(),
          const Text(
            'Bookmarked Ayahs',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Color(0xFF1A2E25)),
          ),
          const Spacer(),
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: _primaryGreen,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Center(
              child: Text('IA', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    return Consumer<QuranProvider>(
      builder: (context, provider, _) {
        return SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Bookmarks',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: Color(0xFF1A2E25)),
              ),
              const SizedBox(height: 4),
              const Text(
                'Continue your spiritual journey with your saved verses',
                style: TextStyle(fontSize: 13, color: Color(0xFF6B8C7A)),
              ),
              const SizedBox(height: 20),

              if (provider.bookmarks.isEmpty)
                _buildEmptyState()
              else
                ...provider.bookmarks.map((bm) => _BookmarkCard(
                      bookmark: bm,
                      onDelete: () => provider.deleteBookmark(bm['id'].toString()),
                      onNavigate: () => context.push('/quran/${bm['surah_number']}'),
                    )),

              const SizedBox(height: 16),
              _buildFindMoreButton(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 60),
        child: Column(
          children: [
            Icon(Icons.bookmark_border_rounded, size: 56, color: Colors.grey.shade300),
            const SizedBox(height: 16),
            const Text('No bookmarks yet', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF6B8C7A))),
            const SizedBox(height: 6),
            const Text(
              'Bookmark ayahs while reading\nto find them here.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, color: Color(0xFFADBFB5)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFindMoreButton() {
    return GestureDetector(
      onTap: () => context.push('/quran'),
      child: Container(
        width: double.infinity,
        height: 50,
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFFD0E5D8), width: 1.5),
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add_rounded, color: Color(0xFF1B5E45), size: 18),
            SizedBox(width: 8),
            Text(
              'Find More Verses to Bookmark',
              style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w500, color: Color(0xFF1B5E45)),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Bookmark Card ──────────────────────────────────────────────────────────
class _BookmarkCard extends StatelessWidget {
  final Map<String, dynamic> bookmark;
  final VoidCallback onDelete;
  final VoidCallback onNavigate;

  const _BookmarkCard({
    required this.bookmark,
    required this.onDelete,
    required this.onNavigate,
  });

  static const Color _primaryGreen = Color(0xFF1B5E45);

  @override
  Widget build(BuildContext context) {
    final surahName = bookmark['surah_name'] ?? 'Unknown';
    final ayahNum = bookmark['ayah_number']?.toString() ?? '';
    final arabicText = bookmark['arabic_text'] ?? '';
    final englishText = bookmark['english_text'] ?? '';
    final isBookmarked = true; // Always true on this screen

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ── Header chip ──
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8F4EE),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '$surahName, $ayahNum',
                    style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: _primaryGreen),
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: onDelete,
                  child: Icon(
                    isBookmarked ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
                    color: _primaryGreen,
                    size: 20,
                  ),
                ),
              ],
            ),
          ),

          // ── Arabic text ──
          if (arabicText.isNotEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
              child: Text(
                arabicText,
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
            ),

          // ── English translation ──
          if (englishText.isNotEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
              child: Text(
                '"$englishText"',
                style: const TextStyle(
                  fontSize: 13,
                  color: Color(0xFF5A7A68),
                  fontStyle: FontStyle.italic,
                  height: 1.5,
                ),
              ),
            ),

          const SizedBox(height: 14),
          const Divider(height: 1, color: Color(0xFFF0F5F2)),

          // ── Actions ──
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                _ActionBtn(
                  icon: Icons.play_circle_outline_rounded,
                  label: 'Recite',
                  onTap: () {},
                  filled: true,
                ),
                const SizedBox(width: 10),
                _ActionBtn(
                  icon: Icons.share_outlined,
                  label: 'Share',
                  onTap: () {},
                  filled: false,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionBtn extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool filled;

  const _ActionBtn({required this.icon, required this.label, required this.onTap, required this.filled});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: filled ? const Color(0xFF1B5E45) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: filled ? null : Border.all(color: const Color(0xFFD0E5D8)),
        ),
        child: Row(
          children: [
            Icon(icon, size: 14, color: filled ? Colors.white : const Color(0xFF1B5E45)),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: filled ? Colors.white : const Color(0xFF1B5E45),
              ),
            ),
          ],
        ),
      ),
    );
  }
}