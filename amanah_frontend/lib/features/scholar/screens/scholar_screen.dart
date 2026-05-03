// lib/features/scholar/screens/scholar_screen.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../providers/scholar_provider.dart';

class ScholarScreen extends StatefulWidget {
  const ScholarScreen({super.key});

  @override
  State<ScholarScreen> createState() => _ScholarScreenState();
}

class _ScholarScreenState extends State<ScholarScreen> {
  String _selectedFilter = 'All Scholars';
  final List<String> _filters = ['All Scholars', 'Fiqh', 'Aqeedah', 'Haniya'];

  static const Color _primaryGreen = Color(0xFF1B5E45);
  static const Color _bgColor = Color(0xFFEFF4F1);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ScholarProvider>().fetchScholars();
      context.read<ScholarProvider>().fetchArchive();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildHeader(context),
              const SizedBox(height: 16),
              _buildHeroCard(context),
              const SizedBox(height: 20),
              _buildSearchBar(),
              const SizedBox(height: 16),
              _buildFilterChips(),
              const SizedBox(height: 16),
              _buildScholarsList(context),
              const SizedBox(height: 20),
              _buildPopularQuestions(),
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
              child: Text('Scholar Q&A',
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

  Widget _buildHeroCard(BuildContext context) {
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
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Ask questions\nfrom verified\nscholars',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: Colors.white, height: 1.3)),
            const SizedBox(height: 8),
            Text(
              'Seek clarity on your journey with trusted spiritual guidance from our global community of Islamic scholars.',
              style: TextStyle(fontSize: 12, color: Colors.white.withValues(alpha: 0.8), height: 1.4),
            ),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: () => context.push('/scholar/ask'),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.4)),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.edit_rounded, size: 14, color: Colors.white),
                    SizedBox(width: 6),
                    Text('Ask a Question', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.white)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: TextField(
        style: const TextStyle(fontSize: 14, color: Color(0xFF1A2E25)),
        decoration: InputDecoration(
          hintText: 'Search scholars or specialties...',
          hintStyle: const TextStyle(color: Color(0xFFADBFB5), fontSize: 13),
          prefixIcon: const Icon(Icons.search_rounded, color: Color(0xFFADBFB5), size: 20),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE0EBE5))),
          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE0EBE5))),
          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF2E7D5E), width: 1.5)),
        ),
      ),
    );
  }

  Widget _buildFilterChips() {
    return SizedBox(
      height: 36,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: _filters.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, i) {
          final f = _filters[i];
          final isSelected = _selectedFilter == f;
          return GestureDetector(
            onTap: () => setState(() => _selectedFilter = f),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? _primaryGreen : Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: isSelected ? _primaryGreen : const Color(0xFFE0EBE5)),
              ),
              child: Text(f,
                  style: TextStyle(
                    fontSize: 12, fontWeight: FontWeight.w500,
                    color: isSelected ? Colors.white : const Color(0xFF6B8C7A),
                  )),
            ),
          );
        },
      ),
    );
  }

  Widget _buildScholarsList(BuildContext context) {
    // Default scholars shown while API loads
    final scholars = [
      _Scholar(name: 'Sheikh Hamza Yusuf',   specialty: 'Jurisprudence (Fiqh), Islamic Spirituality & Ethics',   tags: ['Maliki Fiqh', 'Theology'],     answered: '1.2k+', available: true),
      _Scholar(name: 'Dr. Yasir Qadhi',      specialty: 'Theology / Aqeedah, Sirah, Contemporary American Islam', tags: ['Aqeedah', 'Sirah'],             answered: '980',   available: true),
      _Scholar(name: 'Ustadha Maryam',       specialty: 'Family Counseling, Quranic Exegesis (Tafsir), Women\'s Issues', tags: ['Tafsir', 'Family'],    answered: '2.1k+', available: false),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: scholars.map((s) => _ScholarCard(scholar: s, onTap: () => context.push('/scholar/ask'))).toList(),
      ),
    );
  }

  Widget _buildPopularQuestions() {
    final questions = [
      _Question(tag: 'TRENDING', tagColor: Colors.red, text: '"How can I maintain focus (Khushu) in my daily prayers during busy work days?"', comments: 12, reads: 156),
      _Question(tag: '', tagColor: Colors.grey, text: '"Are digital assets and crypto trading permissible under Sharia?"', comments: 8, reads: 98),
      _Question(tag: '', tagColor: Colors.grey, text: '"Advice for someone seeking to start memorizing the Quran in late adulthood?"', comments: 6, reads: 72),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Recent Popular Questions',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Color(0xFF1A2E25))),
          const SizedBox(height: 12),
          ...questions.map((q) => _QuestionCard(question: q)),
        ],
      ),
    );
  }
}

// ── Scholar Card ──────────────────────────────────────────────────────────
class _ScholarCard extends StatelessWidget {
  final _Scholar scholar;
  final VoidCallback onTap;
  const _ScholarCard({required this.scholar, required this.onTap});

  static const Color _primaryGreen = Color(0xFF1B5E45);

  @override
  Widget build(BuildContext context) {
    return Container(
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
                width: 48, height: 48,
                decoration: BoxDecoration(color: const Color(0xFFE8F4EE), shape: BoxShape.circle),
                child: Center(
                  child: Text(
                    scholar.name.split(' ').map((w) => w[0]).take(2).join(),
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: _primaryGreen),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(scholar.name, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFF1A2E25))),
                    Row(
                      children: [
                        Container(
                          width: 6, height: 6,
                          decoration: BoxDecoration(
                            color: scholar.available ? const Color(0xFF4CAF50) : Colors.grey,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          scholar.available ? 'Available Now' : 'Busy',
                          style: TextStyle(
                            fontSize: 11,
                            color: scholar.available ? const Color(0xFF4CAF50) : Colors.grey,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Text(scholar.answered,
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF6B8C7A))),
              const SizedBox(width: 4),
              const Text('Answered', style: TextStyle(fontSize: 10, color: Color(0xFF6B8C7A))),
            ],
          ),
          const SizedBox(height: 10),
          Text(scholar.specialty, style: const TextStyle(fontSize: 12, color: Color(0xFF6B8C7A), height: 1.4)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 6,
            children: scholar.tags.map((t) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(color: const Color(0xFFE8F4EE), borderRadius: BorderRadius.circular(12)),
              child: Text(t, style: const TextStyle(fontSize: 11, color: _primaryGreen, fontWeight: FontWeight.w500)),
            )).toList(),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            height: 38,
            child: ElevatedButton(
              onPressed: onTap,
              style: ElevatedButton.styleFrom(
                backgroundColor: _primaryGreen,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: const Text('View Profile', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Question Card ──────────────────────────────────────────────────────────
class _QuestionCard extends StatelessWidget {
  final _Question question;
  const _QuestionCard({required this.question});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (question.tag.isNotEmpty)
            Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(color: question.tagColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
              child: Text(question.tag, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: question.tagColor)),
            ),
          Text(question.text, style: const TextStyle(fontSize: 13, color: Color(0xFF1A2E25), height: 1.4)),
          const SizedBox(height: 10),
          Row(
            children: [
              Icon(Icons.comment_outlined, size: 14, color: Colors.grey.shade400),
              const SizedBox(width: 4),
              Text('${question.comments}', style: TextStyle(fontSize: 11, color: Colors.grey.shade500)),
              const SizedBox(width: 12),
              Icon(Icons.remove_red_eye_outlined, size: 14, color: Colors.grey.shade400),
              const SizedBox(width: 4),
              Text('${question.reads}', style: TextStyle(fontSize: 11, color: Colors.grey.shade500)),
              const Spacer(),
              Text('Read Answer →', style: TextStyle(fontSize: 11, color: Colors.grey.shade500, fontWeight: FontWeight.w500)),
            ],
          ),
        ],
      ),
    );
  }
}

class _Scholar {
  final String name, specialty, answered;
  final List<String> tags;
  final bool available;
  const _Scholar({required this.name, required this.specialty, required this.tags, required this.answered, required this.available});
}

class _Question {
  final String tag, text;
  final Color tagColor;
  final int comments, reads;
  const _Question({required this.tag, required this.tagColor, required this.text, required this.comments, required this.reads});
}