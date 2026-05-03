// lib/features/quran/screens/quran_screen.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../providers/quran_provider.dart';

class QuranScreen extends StatefulWidget {
  const QuranScreen({super.key});

  @override
  State<QuranScreen> createState() => _QuranScreenState();
}

class _QuranScreenState extends State<QuranScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _searchController = TextEditingController();
  String _searchQuery = '';

  static const Color _primaryGreen = Color(0xFF1B5E45);
  static const Color _bgColor = Color(0xFFEFF4F1);

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<QuranProvider>().fetchSurahs();
      context.read<QuranProvider>().fetchBookmarks();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
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
            // ── Header ──
            _buildHeader(),

            // ── Last Read Card ──
            _buildLastReadCard(),

            const SizedBox(height: 16),

            // ── Search ──
            _buildSearchBar(),

            const SizedBox(height: 12),

            // ── Tabs ──
            _buildTabs(),

            // ── Content ──
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildSurahList(),
                  _buildBookmarksList(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Header ────────────────────────────────────────────────────────────────
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
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.06),
                    blurRadius: 8,
                  ),
                ],
              ),
              child: const Icon(Icons.arrow_back_rounded, size: 18, color: Color(0xFF1A2E25)),
            ),
          ),
          const SizedBox(width: 12),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Quran',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1A2E25),
                ),
              ),
              Text(
                'Library',
                style: TextStyle(fontSize: 12, color: Color(0xFF6B8C7A)),
              ),
            ],
          ),
          const Spacer(),
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: _primaryGreen,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.search_rounded, size: 18, color: Colors.white),
          ),
        ],
      ),
    );
  }

  // ── Last Read Card ────────────────────────────────────────────────────────
  Widget _buildLastReadCard() {
    return Consumer<QuranProvider>(
      builder: (context, provider, _) {
        final last = provider.lastRead;
        if (last == null) return const SizedBox(height: 16);

        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
          child: GestureDetector(
            onTap: () => context.push('/quran/${last['surah_number']}'),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF1B5E45), Color(0xFF2E7D5E)],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Last Read',
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.white.withValues(alpha: 0.7),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          last['surah_name'] ?? 'Al-Kahf',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          'Ayah No. ${last['ayah'] ?? 1}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white.withValues(alpha: 0.7),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.menu_book_rounded, color: Colors.white, size: 24),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // ── Search Bar ────────────────────────────────────────────────────────────
  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: TextField(
        controller: _searchController,
        onChanged: (v) => setState(() => _searchQuery = v.toLowerCase()),
        style: const TextStyle(fontSize: 14, color: Color(0xFF1A2E25)),
        decoration: InputDecoration(
          hintText: 'Search surah name...',
          hintStyle: const TextStyle(color: Color(0xFFADBFB5), fontSize: 13.5),
          prefixIcon: const Icon(Icons.search_rounded, color: Color(0xFFADBFB5), size: 20),
          suffixIcon: _searchQuery.isNotEmpty
              ? GestureDetector(
                  onTap: () {
                    _searchController.clear();
                    setState(() => _searchQuery = '');
                  },
                  child: const Icon(Icons.close_rounded, color: Color(0xFFADBFB5), size: 18),
                )
              : null,
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFE0EBE5)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFE0EBE5)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF2E7D5E), width: 1.5),
          ),
        ),
      ),
    );
  }

  // ── Tabs ──────────────────────────────────────────────────────────────────
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
            Tab(text: 'Surahs'),
            Tab(text: 'Bookmarks'),
          ],
        ),
      ),
    );
  }

  // ── Surah List ────────────────────────────────────────────────────────────
  Widget _buildSurahList() {
    return Consumer<QuranProvider>(
      builder: (context, provider, _) {
        if (provider.isLoading) {
          return const Center(
            child: CircularProgressIndicator(color: _primaryGreen),
          );
        }

        final surahs = provider.surahs.where((s) {
          if (_searchQuery.isEmpty) return true;
          final name = (s['english_name'] ?? '').toString().toLowerCase();
          final arabic = (s['name'] ?? '').toString();
          return name.contains(_searchQuery) || arabic.contains(_searchQuery);
        }).toList();

        if (surahs.isEmpty) {
          return const Center(
            child: Text('No surahs found.', style: TextStyle(color: Color(0xFF6B8C7A))),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
          itemCount: surahs.length,
          itemBuilder: (context, i) => _SurahTile(
            surah: surahs[i],
            onTap: () => context.push('/quran/${surahs[i]['number']}'),
          ),
        );
      },
    );
  }

  // ── Bookmarks List ────────────────────────────────────────────────────────
  Widget _buildBookmarksList() {
    return Consumer<QuranProvider>(
      builder: (context, provider, _) {
        final bookmarks = provider.bookmarks;

        if (bookmarks.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.bookmark_border_rounded, size: 48, color: Colors.grey.shade300),
                const SizedBox(height: 12),
                const Text(
                  'No bookmarks yet',
                  style: TextStyle(color: Color(0xFF6B8C7A), fontSize: 14),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Bookmark ayahs while reading to find them here.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Color(0xFFADBFB5), fontSize: 12),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
          itemCount: bookmarks.length,
          itemBuilder: (context, i) {
            final bm = bookmarks[i];
            return Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 8,
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: _primaryGreen.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.bookmark_rounded, size: 18, color: _primaryGreen),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${bm['surah_name']} — Ayah ${bm['ayah_number']}',
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF1A2E25),
                          ),
                        ),
                        if (bm['text'] != null)
                          Text(
                            bm['text'].toString(),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 12, color: Color(0xFF6B8C7A)),
                          ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () => provider.deleteBookmark(bm['id'].toString()),
                    child: Icon(Icons.close_rounded, size: 18, color: Colors.grey.shade400),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

// ── Surah Tile ─────────────────────────────────────────────────────────────
class _SurahTile extends StatelessWidget {
  final Map<String, dynamic> surah;
  final VoidCallback onTap;

  const _SurahTile({required this.surah, required this.onTap});

  static const Color _primaryGreen = Color(0xFF1B5E45);

  @override
  Widget build(BuildContext context) {
    final number = surah['number']?.toString() ?? '';
    final englishName = surah['english_name'] ?? '';
    final arabicName = surah['name'] ?? '';
    final meaning = surah['english_name_translation'] ?? '';
    final ayahs = surah['number_of_ayahs']?.toString() ?? '';

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 2),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Color(0xFFF0F0F0), width: 1),
          ),
        ),
        child: Row(
          children: [
            // Number badge
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: _primaryGreen.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text(
                  number,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: _primaryGreen,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 14),
            // Name + ayahs
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    englishName,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1A2E25),
                    ),
                  ),
                  Text(
                    '$meaning · $ayahs verses',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF6B8C7A),
                    ),
                  ),
                ],
              ),
            ),
            // Arabic name
            Text(
              arabicName,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: _primaryGreen,
              ),
              textDirection: TextDirection.rtl,
            ),
          ],
        ),
      ),
    );
  }
}