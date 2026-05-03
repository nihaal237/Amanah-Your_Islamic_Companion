// lib/features/legal/screens/legal_screens.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// ── Shared scaffold for all legal screens ─────────────────────────────────
class _LegalScreen extends StatelessWidget {
  final String title;
  final String lastUpdated;
  final List<Widget> sections;
  final String? actionLabel;
  final VoidCallback? onAction;

  const _LegalScreen({
    required this.title,
    required this.lastUpdated,
    required this.sections,
    this.actionLabel,
    this.onAction,
  });

  static const Color _primaryGreen = Color(0xFF1B5E45);
  static const Color _bgColor = Color(0xFFEFF4F1);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgColor,
      body: SafeArea(
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
                  const Spacer(),
                  Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Color(0xFF1A2E25))),
                  const Spacer(),
                  const SizedBox(width: 36),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: Color(0xFF1A2E25))),
                    const SizedBox(height: 4),
                    Text('Last updated: $lastUpdated',
                        style: const TextStyle(fontSize: 12, color: Color(0xFF6B8C7A))),
                    const SizedBox(height: 20),
                    ...sections,
                    if (actionLabel != null) ...[
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: onAction,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _primaryGreen,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          child: Text(actionLabel!, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Center(
                        child: GestureDetector(
                          onTap: () {},
                          child: const Text('Download PDF',
                              style: TextStyle(fontSize: 13, color: Color(0xFF2E7D5E), fontWeight: FontWeight.w500)),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Section helpers ────────────────────────────────────────────────────────
Widget _sectionCard({required Widget child}) {
  return Container(
    margin: const EdgeInsets.only(bottom: 14),
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8)],
    ),
    child: child,
  );
}

Widget _sectionTitle(String title) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Text(title,
        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Color(0xFF1A2E25))),
  );
}

Widget _bodyText(String text) {
  return Text(text, style: const TextStyle(fontSize: 13, color: Color(0xFF5A7A68), height: 1.6));
}

Widget _numberedSection(int num, String title, String body) {
  return Container(
    margin: const EdgeInsets.only(bottom: 14),
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8)],
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 28, height: 28,
          decoration: BoxDecoration(color: const Color(0xFFE8F4EE), borderRadius: BorderRadius.circular(8)),
          child: Center(child: Text('$num', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFF1B5E45)))),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFF1A2E25))),
              const SizedBox(height: 6),
              Text(body, style: const TextStyle(fontSize: 13, color: Color(0xFF5A7A68), height: 1.5)),
            ],
          ),
        ),
      ],
    ),
  );
}

Widget _bulletItem(IconData icon, String title, String body, {Color iconColor = const Color(0xFF1B5E45)}) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 32, height: 32,
          decoration: BoxDecoration(color: const Color(0xFFE8F4EE), borderRadius: BorderRadius.circular(8)),
          child: Icon(icon, size: 16, color: iconColor),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF1A2E25))),
              Text(body, style: const TextStyle(fontSize: 12, color: Color(0xFF6B8C7A), height: 1.4)),
            ],
          ),
        ),
      ],
    ),
  );
}

// ══════════════════════════════════════════════════════════════════════════
// Privacy Policy Screen
// ══════════════════════════════════════════════════════════════════════════
class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return _LegalScreen(
      title: 'Trust & Privacy',
      lastUpdated: 'October 24, 2024',
      sections: [
        _sectionCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _sectionTitle('Key Commitments'),
              _bulletItem(Icons.lock_outline_rounded, 'End-to-end encrypted', 'Your spiritual data and personal info stays private.'),
              _bulletItem(Icons.block_rounded, 'Zero ad targeting', 'We never use your profile for ads plans and offers.'),
              _bulletItem(Icons.visibility_outlined, 'Transparency always', 'We are open about how we collect, process and store data.'),
            ],
          ),
        ),
        _numberedSection(1, 'Information Collection',
            'Amanah collects information you provide directly to us when you create or modify your account, request services, contact customer support, or otherwise communicate with us. This information may include your name, email, phone number, city, address, and profile picture.'),
        _numberedSection(2, 'Data Security',
            'We implement a variety of security measures to maintain the safety of your personal information. All sensitive information provided via the Amanah app is transmitted to our secure systems and then encrypted and stored.'),
        _numberedSection(3, 'Giving & Contributions',
            'Financial transactions through the Giving feature are processed through secure third-party payment processors. Amanah does not store your full credit card details or bank account information on our systems.'),
        _numberedSection(4, 'Your Rights',
            '• The right to access the personal data we hold about you.\n• The right to request that we correct any inaccuracies in your data.\n• The right to request the erasure of your personal data under certain conditions.'),
        _sectionCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Questions?', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFF1A2E25))),
              const SizedBox(height: 6),
              const Text('If you have questions about this policy, please reach out to our legal team.',
                  style: TextStyle(fontSize: 12, color: Color(0xFF6B8C7A), height: 1.4)),
              const SizedBox(height: 12),
              GestureDetector(
                onTap: () {},
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(color: const Color(0xFF1B5E45), borderRadius: BorderRadius.circular(20)),
                  child: const Text('Contact Legal Team', style: TextStyle(fontSize: 12, color: Colors.white, fontWeight: FontWeight.w500)),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════
// Terms of Service Screen
// ══════════════════════════════════════════════════════════════════════════
class TermsOfServiceScreen extends StatelessWidget {
  const TermsOfServiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return _LegalScreen(
      title: 'Terms of Service',
      lastUpdated: 'October 24, 2024',
      actionLabel: 'I Accept These Terms',
      onAction: () => context.pop(),
      sections: [
        _sectionCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Welcome to Amanah. These terms govern your use of our platform. By accessing Amanah, you agree to be bound by these terms. If you do not agree, please do not use the service.',
                  style: TextStyle(fontSize: 13, color: Color(0xFF5A7A68), height: 1.5)),
            ],
          ),
        ),
        _numberedSection(1, 'Acceptance of Terms',
            'Amanah provides a digital ecosystem for spiritual growth and community support. By creating an account, you confirm that you are at least 18 years of age and possesses the legal authority to enter into this agreement.\n\n⚠ IMPORTANT NOTICE\nAmanah is not for spiritual or religious advice. Content shared by users does not represent religious or legal guidance.'),
        _numberedSection(2, 'User Conduct & Trust',
            'Users are expected to maintain the principle of "Amanah" (Trust). Prohibited actions include:\n\n• Spreading misinformation or harmful content\n• Harassment or discriminatory behavior\n• Unauthorized scraping of sacred texts or user data'),
        _numberedSection(3, 'Giving & Contributions',
            'When using our giving features, you acknowledge that Amanah facilitates the transfer but is not responsible for the ultimate allocation of funds by third-party organizations.\n\n✓ Transparent Tracking\nAll contributions are tracked automatically for all donations.'),
        _numberedSection(4, 'Data Privacy',
            'Data privacy is our priority. We encrypt all personal data and never sell your information to third parties. For a detailed breakdown, please see our Privacy Policy.'),
      ],
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════
// Community Guidelines Screen
// ══════════════════════════════════════════════════════════════════════════
class CommunityGuidelinesScreen extends StatelessWidget {
  const CommunityGuidelinesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return _LegalScreen(
      title: 'Community Guidelines',
      lastUpdated: 'October 24, 2024',
      sections: [
        _sectionCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 52, height: 52,
                  decoration: BoxDecoration(color: const Color(0xFFE8F4EE), shape: BoxShape.circle),
                  child: const Icon(Icons.people_alt_rounded, color: Color(0xFF1B5E45), size: 26),
                ),
              ),
              const SizedBox(height: 14),
              _sectionTitle('Our Shared Trust'),
              _bodyText('Amanah is a sanctuary built on mutual respect and shared values. These guidelines help ensure our community remains a safe space for spiritual growth.'),
            ],
          ),
        ),
        _sectionCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _bulletItem(Icons.favorite_outline_rounded, 'Unwavering Kindness',
                  'Treat every member with the same dignity and compassion you would offer your own family.'),
              _bulletItem(Icons.shield_outlined, 'Sacred Privacy',
                  'Respect personal journeys. What is shared in confidence stays within our community circles.'),
              _bulletItem(Icons.verified_outlined, 'Authenticity & Sincerity',
                  'Engage with sincerity (Ikhlas). Avoid impersonation or misleading information. Our strength lies in being truthful to ourselves and others.'),
            ],
          ),
        ),
        Container(
          margin: const EdgeInsets.only(bottom: 14),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.red.shade50,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.red.shade100),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.warning_amber_rounded, color: Colors.red.shade400, size: 18),
                  const SizedBox(width: 8),
                  Text('Prohibited Content',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Colors.red.shade700)),
                ],
              ),
              const SizedBox(height: 12),
              _prohibitedItem(Icons.record_voice_over_outlined, 'Harassment & Hate Speech',
                  'Zero tolerance for attacks based on race, religion, gender, or orientation.'),
              _prohibitedItem(Icons.campaign_outlined, 'Spam & Commercialism',
                  'Amanah is for spiritual growth, not for unsolicited sales or promotional noise.'),
              _prohibitedItem(Icons.warning_outlined, 'Misleading Information',
                  'Spreading unverified claims or harmful medical advice is strictly forbidden.'),
            ],
          ),
        ),
        _sectionCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _sectionTitle('Our Commitment to Action'),
              _bodyText('If you see something that violates these principles, please report it immediately. Our moderation team reviews all reports with fairness and discretion.'),
              const SizedBox(height: 14),
              GestureDetector(
                onTap: () {},
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1B5E45),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Center(
                    child: Text('Contact Support',
                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.white)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _prohibitedItem(IconData icon, String title, String body) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 16, color: Colors.red.shade400),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.red.shade700)),
                Text(body, style: const TextStyle(fontSize: 11, color: Color(0xFF6B8C7A), height: 1.4)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}