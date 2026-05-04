// lib/features/scholar/screens/my_questions_screen.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../providers/scholar_provider.dart';

class MyQuestionsScreen extends StatefulWidget {
  const MyQuestionsScreen({super.key});

  @override
  State<MyQuestionsScreen> createState() => _MyQuestionsScreenState();
}

class _MyQuestionsScreenState extends State<MyQuestionsScreen> {
  static const Color _primaryGreen = Color(0xFF1B5E45);
  static const Color _bgColor = Color(0xFFEFF4F1);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ScholarProvider>().fetchMyQuestions();
    });
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
              child: Consumer<ScholarProvider>(
                builder: (context, provider, _) {
                  if (provider.isLoading) {
                    return const Center(child: CircularProgressIndicator(color: _primaryGreen));
                  }
                  if (provider.myQuestions.isEmpty) {
                    return _buildEmpty(context);
                  }
                  return RefreshIndicator(
                    color: _primaryGreen,
                    onRefresh: () => provider.fetchMyQuestions(),
                    child: ListView.builder(
                      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                      itemCount: provider.myQuestions.length,
                      itemBuilder: (context, i) => _QuestionCard(question: provider.myQuestions[i]),
                    ),
                  );
                },
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
              child: Text('My Questions',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Color(0xFF1A2E25))),
            ),
          ),
          GestureDetector(
            onTap: () => context.push('/scholar/ask'),
            child: Container(
              width: 36, height: 36,
              decoration: BoxDecoration(color: _primaryGreen, borderRadius: BorderRadius.circular(10)),
              child: const Icon(Icons.add_rounded, color: Colors.white, size: 20),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmpty(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.help_outline_rounded, size: 56, color: Colors.grey.shade300),
            const SizedBox(height: 16),
            const Text("No questions yet", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF6B8C7A))),
            const SizedBox(height: 6),
            const Text("Ask a verified scholar a question to get guidance on your spiritual journey.",
                textAlign: TextAlign.center, style: TextStyle(fontSize: 13, color: Color(0xFFADBFB5))),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () => context.push('/scholar/ask'),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(color: _primaryGreen, borderRadius: BorderRadius.circular(20)),
                child: const Text('Ask a Question', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuestionCard extends StatelessWidget {
  final Map<String, dynamic> question;
  const _QuestionCard({required this.question});

  static const Color _primaryGreen = Color(0xFF1B5E45);

  @override
  Widget build(BuildContext context) {
    final text = question['question'] ?? question['text'] ?? '';
    final answer = question['answer'];
    final isAnswered = answer != null && answer.toString().isNotEmpty;
    final createdAt = question['created_at'] ?? '';

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: isAnswered ? Border.all(color: _primaryGreen.withValues(alpha: 0.2)) : null,
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Status badge
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: isAnswered ? const Color(0xFFE8F4EE) : Colors.orange.shade50,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            isAnswered ? Icons.check_circle_rounded : Icons.schedule_rounded,
                            size: 12,
                            color: isAnswered ? _primaryGreen : Colors.orange,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            isAnswered ? 'Answered' : 'Pending',
                            style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700,
                                color: isAnswered ? _primaryGreen : Colors.orange),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    if (createdAt.isNotEmpty)
                      Text(_formatDate(createdAt),
                          style: const TextStyle(fontSize: 11, color: Color(0xFF6B8C7A))),
                  ],
                ),
                const SizedBox(height: 10),
                // Question text
                Text(text, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500,
                    color: Color(0xFF1A2E25), height: 1.5)),
              ],
            ),
          ),

          // Answer section
          if (isAnswered) ...[
            Divider(height: 1, color: Colors.grey.shade100),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 28, height: 28,
                        decoration: BoxDecoration(color: const Color(0xFFE8F4EE), shape: BoxShape.circle),
                        child: const Center(child: Text('SH', style: TextStyle(fontSize: 9, fontWeight: FontWeight.w700, color: _primaryGreen))),
                      ),
                      const SizedBox(width: 8),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Scholar Response', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: _primaryGreen)),
                          Text('Verified Answer', style: TextStyle(fontSize: 10, color: Color(0xFF6B8C7A))),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(answer.toString(),
                      style: const TextStyle(fontSize: 13, color: Color(0xFF3D5A4C), height: 1.5)),
                ],
              ),
            ),
          ],

          // Pending message
          if (!isAnswered)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(color: Colors.orange.shade50, borderRadius: BorderRadius.circular(8)),
                child: const Row(
                  children: [
                    Icon(Icons.info_outline_rounded, size: 14, color: Colors.orange),
                    SizedBox(width: 6),
                    Expanded(
                      child: Text('Your question is in queue. Scholars typically respond within 24-48 hours.',
                          style: TextStyle(fontSize: 11, color: Colors.orange, height: 1.3)),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  String _formatDate(String raw) {
    try {
      final dt = DateTime.parse(raw);
      return '${dt.day}/${dt.month}/${dt.year}';
    } catch (_) {
      return raw;
    }
  }
}