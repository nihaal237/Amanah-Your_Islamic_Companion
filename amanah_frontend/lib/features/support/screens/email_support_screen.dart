// lib/features/support/screens/email_support_screen.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class EmailSupportScreen extends StatefulWidget {
  const EmailSupportScreen({super.key});

  @override
  State<EmailSupportScreen> createState() => _EmailSupportScreenState();
}

class _EmailSupportScreenState extends State<EmailSupportScreen> {
  final _subjectController = TextEditingController();
  final _messageController = TextEditingController();
  bool _isLoading = false;

  static const Color _primaryGreen = Color(0xFF1B5E45);
  static const Color _bgColor = Color(0xFFEFF4F1);

  @override
  void dispose() {
    _subjectController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _sendMessage() async {
    if (_subjectController.text.trim().isEmpty || _messageController.text.trim().isEmpty) return;
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 1));
    if (!mounted) return;
    setState(() => _isLoading = false);
    _showSuccessDialog();
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 56, height: 56,
                decoration: const BoxDecoration(color: _primaryGreen, shape: BoxShape.circle),
                child: const Icon(Icons.check_rounded, color: Colors.white, size: 28),
              ),
              const SizedBox(height: 16),
              const Text('Message Sent!',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Color(0xFF1A2E25))),
              const SizedBox(height: 8),
              const Text(
                'Your message has been received. We typically respond within 24 hours.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 13, color: Color(0xFF6B8C7A), height: 1.5),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 46,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(ctx).pop();
                    context.pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _primaryGreen,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Back to Help Center',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 24),
          child: Column(
            children: [
              // Header
              Padding(
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
                        child: Text('Email Support',
                            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Color(0xFF1A2E25))),
                      ),
                    ),
                    Icon(Icons.more_vert_rounded, color: Colors.grey.shade400),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // How can we help card
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8)],
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 40, height: 40,
                            decoration: BoxDecoration(color: const Color(0xFFE8F4EE), borderRadius: BorderRadius.circular(10)),
                            child: const Icon(Icons.mail_outline_rounded, color: _primaryGreen, size: 20),
                          ),
                          const SizedBox(width: 12),
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('How can we help?',
                                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Color(0xFF1A2E25))),
                                Row(
                                  children: [
                                    Icon(Icons.access_time_rounded, size: 12, color: Color(0xFF6B8C7A)),
                                    SizedBox(width: 4),
                                    Text('24-hour typical response time',
                                        style: TextStyle(fontSize: 11, color: Color(0xFF6B8C7A))),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Subject
                    const Text('Subject',
                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Color(0xFF3D5A4C))),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _subjectController,
                      style: const TextStyle(fontSize: 14, color: Color(0xFF1A2E25)),
                      decoration: _inputDeco('What is this regarding?'),
                    ),

                    const SizedBox(height: 16),

                    // Message
                    const Text('Message',
                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Color(0xFF3D5A4C))),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _messageController,
                      maxLines: 5,
                      style: const TextStyle(fontSize: 14, color: Color(0xFF1A2E25)),
                      decoration: _inputDeco('Describe your issue or question in detail...'),
                    ),

                    const SizedBox(height: 24),

                    // Send button
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _sendMessage,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _primaryGreen,
                          foregroundColor: Colors.white,
                          disabledBackgroundColor: _primaryGreen.withValues(alpha: 0.6),
                          elevation: 0,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: _isLoading
                            ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5))
                            : const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('Send Message', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                                  SizedBox(width: 8),
                                  Icon(Icons.send_rounded, size: 16),
                                ],
                              ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Or contact directly
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8)],
                      ),
                      child: Column(
                        children: [
                          Text('Or contact us directly via',
                              style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Container(
                                width: 36, height: 36,
                                decoration: BoxDecoration(color: const Color(0xFFE8F4EE), borderRadius: BorderRadius.circular(10)),
                                child: const Icon(Icons.alternate_email_rounded, color: _primaryGreen, size: 18),
                              ),
                              const SizedBox(width: 12),
                              const Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Email Address',
                                        style: TextStyle(fontSize: 11, color: Color(0xFF6B8C7A))),
                                    Text('support@amanahapp.com',
                                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF1A2E25))),
                                  ],
                                ),
                              ),
                              Icon(Icons.open_in_new_rounded, size: 16, color: Colors.grey.shade400),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Support team banner
                    Container(
                      height: 110,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF1B5E45), Color(0xFF2E7D5E)],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              "We're here to ensure your journey with Amanah is secure and trustworthy.",
                              style: TextStyle(fontSize: 12, color: Colors.white.withValues(alpha: 0.9), height: 1.4),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Row(
                            children: List.generate(3, (i) => Container(
                              width: 36, height: 36,
                              margin: EdgeInsets.only(left: i > 0 ? -10 : 0),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: [const Color(0xFF4CAF50), const Color(0xFF2196F3), const Color(0xFFFF9800)][i],
                                border: Border.all(color: Colors.white, width: 2),
                              ),
                              child: const Icon(Icons.person_rounded, color: Colors.white, size: 18),
                            )),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDeco(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Color(0xFFADBFB5), fontSize: 13),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFFE0EBE5))),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFFE0EBE5))),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFF2E7D5E), width: 1.5)),
    );
  }
}