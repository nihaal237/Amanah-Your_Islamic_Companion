// lib/features/scholar/screens/ask_sheikh_screen.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../providers/scholar_provider.dart';

class AskSheikhScreen extends StatefulWidget {
  final String? scholarName;
  const AskSheikhScreen({super.key, this.scholarName});

  @override
  State<AskSheikhScreen> createState() => _AskSheikhScreenState();
}

class _AskSheikhScreenState extends State<AskSheikhScreen> {
  final _questionController = TextEditingController();
  static const int _maxChars = 500;

  static const Color _primaryGreen = Color(0xFF1B5E45);
  static const Color _bgColor = Color(0xFFEFF4F1);

  // Default scholar shown
  final _scholar = const _ScholarInfo(
    name: 'Sheikh Hamza Yusuf',
    specialty: 'Islamic Jurisprudence & Ethics',
    tags: ['Maliki Fiqh', 'Theology'],
    avgResponse: '48 hours',
    answered: '1.2k+',
  );

  final List<_Dialogue> _dialogues = const [
    _Dialogue(
      category: 'Spiritual Health',
      timeAgo: '2 days ago',
      question: '"How can one maintain spiritual focus while working in a high-stress corporate...',
      answer: 'Spiritual focus begins with the',
    ),
    _Dialogue(
      category: 'Family Life',
      timeAgo: '1 week ago',
      question: '"What is the recommended approach for balancing children\'s secular and religious..',
      answer: 'Education is a holistic journey',
    ),
  ];

  @override
  void dispose() {
    _questionController.dispose();
    super.dispose();
  }

  Future<void> _submitQuestion() async {
    if (_questionController.text.trim().isEmpty) return;
    final provider = context.read<ScholarProvider>();
    final success = await provider.askQuestion(_questionController.text.trim());
    if (!mounted) return;
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Question submitted! You\'ll be notified when answered.'),
          backgroundColor: _primaryGreen,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
      _questionController.clear();
    }
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
              const SizedBox(height: 20),
              _buildScholarCard(),
              const SizedBox(height: 20),
              _buildQuestionBox(context),
              const SizedBox(height: 20),
              _buildDialogues(),
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
              child: Text('Sheikh Hamza Yusuf',
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

  Widget _buildScholarCard() {
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
          children: [
            Row(
              children: [
                // Avatar
                Stack(
                  children: [
                    Container(
                      width: 56, height: 56,
                      decoration: BoxDecoration(color: const Color(0xFFE8F4EE), shape: BoxShape.circle),
                      child: const Center(
                        child: Text('HY', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: _primaryGreen)),
                      ),
                    ),
                    Positioned(
                      bottom: 0, right: 0,
                      child: Container(
                        width: 14, height: 14,
                        decoration: BoxDecoration(color: const Color(0xFF4CAF50), shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2)),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(_scholar.name, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Color(0xFF1A2E25))),
                      Text(_scholar.specialty, style: const TextStyle(fontSize: 11, color: Color(0xFF6B8C7A))),
                      const SizedBox(height: 6),
                      Wrap(
                        spacing: 6,
                        children: _scholar.tags.map((t) => Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(color: const Color(0xFFE8F4EE), borderRadius: BorderRadius.circular(10)),
                          child: Text(t, style: const TextStyle(fontSize: 10, color: _primaryGreen, fontWeight: FontWeight.w500)),
                        )).toList(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.access_time_rounded, size: 14, color: Colors.grey.shade400),
                const SizedBox(width: 6),
                Text('Avg. response: ${_scholar.avgResponse}',
                    style: const TextStyle(fontSize: 12, color: Color(0xFF6B8C7A))),
                const Spacer(),
                Icon(Icons.check_circle_outline_rounded, size: 14, color: Colors.grey.shade400),
                const SizedBox(width: 4),
                Text('${_scholar.answered} Answered',
                    style: const TextStyle(fontSize: 12, color: Color(0xFF6B8C7A))),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuestionBox(BuildContext context) {
    final provider = context.watch<ScholarProvider>();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Your Question', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Color(0xFF1A2E25))),
              Text('${_questionController.text.length} / $_maxChars characters',
                  style: const TextStyle(fontSize: 11, color: Color(0xFF6B8C7A))),
            ],
          ),
          const SizedBox(height: 10),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFFE0EBE5)),
              boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8)],
            ),
            child: Column(
              children: [
                TextField(
                  controller: _questionController,
                  maxLength: _maxChars,
                  maxLines: 5,
                  onChanged: (_) => setState(() {}),
                  style: const TextStyle(fontSize: 14, color: Color(0xFF1A2E25)),
                  decoration: InputDecoration(
                    hintText: 'Ask about ethics, jurisprudence, or spiritual growth...',
                    hintStyle: const TextStyle(color: Color(0xFFADBFB5), fontSize: 13),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.all(16),
                    counterText: '',
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                  child: Row(
                    children: [
                      const Icon(Icons.info_outline_rounded, size: 14, color: Color(0xFFADBFB5)),
                      const SizedBox(width: 6),
                      const Text('Keep it concise for a better response',
                          style: TextStyle(fontSize: 11, color: Color(0xFFADBFB5))),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: provider.isLoading ? null : _submitQuestion,
              style: ElevatedButton.styleFrom(
                backgroundColor: _primaryGreen,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: provider.isLoading
                  ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                  : const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.send_rounded, size: 16),
                        SizedBox(width: 8),
                        Text('Submit Question', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                      ],
                    ),
            ),
          ),
          const SizedBox(height: 8),
          const Center(
            child: Text(
              'Note: Typical response times vary based on the Sheikh\'s schedule.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 11, color: Color(0xFF6B8C7A)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDialogues() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Public Dialogues', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Color(0xFF1A2E25))),
              GestureDetector(
                onTap: () {},
                child: const Text('View all history →',
                    style: TextStyle(fontSize: 12, color: Color(0xFF2E7D5E), fontWeight: FontWeight.w500)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ..._dialogues.map((d) => _DialogueCard(dialogue: d)),
        ],
      ),
    );
  }
}

class _DialogueCard extends StatelessWidget {
  final _Dialogue dialogue;
  const _DialogueCard({required this.dialogue});

  static const Color _primaryGreen = Color(0xFF1B5E45);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(color: const Color(0xFFE8F4EE), borderRadius: BorderRadius.circular(8)),
                child: Text(dialogue.category, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: _primaryGreen)),
              ),
              const Spacer(),
              Text(dialogue.timeAgo, style: const TextStyle(fontSize: 11, color: Color(0xFF6B8C7A))),
            ],
          ),
          const SizedBox(height: 8),
          Text(dialogue.question, style: const TextStyle(fontSize: 13, color: Color(0xFF1A2E25), height: 1.4)),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: const Color(0xFFF7FAF8), borderRadius: BorderRadius.circular(10)),
            child: Row(
              children: [
                Container(
                  width: 28, height: 28,
                  decoration: const BoxDecoration(color: _primaryGreen, shape: BoxShape.circle),
                  child: const Center(child: Text('SH', style: TextStyle(fontSize: 9, fontWeight: FontWeight.w700, color: Colors.white))),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Answered by Sheikh Hamza',
                          style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF1A2E25))),
                      Text(dialogue.answer, style: const TextStyle(fontSize: 11, color: Color(0xFF6B8C7A))),
                    ],
                  ),
                ),
                Container(
                  width: 24, height: 24,
                  decoration: BoxDecoration(color: const Color(0xFFE8F4EE), borderRadius: BorderRadius.circular(6)),
                  child: const Icon(Icons.chevron_right_rounded, size: 16, color: _primaryGreen),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ScholarInfo {
  final String name, specialty, avgResponse, answered;
  final List<String> tags;
  const _ScholarInfo({required this.name, required this.specialty, required this.tags, required this.avgResponse, required this.answered});
}

class _Dialogue {
  final String category, timeAgo, question, answer;
  const _Dialogue({required this.category, required this.timeAgo, required this.question, required this.answer});
}