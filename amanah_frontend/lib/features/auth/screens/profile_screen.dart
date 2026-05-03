// lib/features/auth/screens/profile_screen.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  static const Color _primaryGreen = Color(0xFF1B5E45);
  static const Color _bgColor = Color(0xFFEFF4F1);

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().user;
    final fullName = user?['full_name'] ?? 'User';
    final initials = _getInitials(fullName);
    final bio = user?['bio'] ?? 'Daily Seeker of Knowledge';
    final score = user?['amanah_score'] ?? 842;

    return Scaffold(
      backgroundColor: _bgColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildHeader(context),
              _buildProfileCard(context, fullName, initials, bio, score),
              const SizedBox(height: 12),
              _buildStatsRow(),
              const SizedBox(height: 20),
              _buildSection('Appearance', [
                _buildToggleTile(Icons.dark_mode_outlined, 'Dark Mode', false, (v) {}),
                _buildNavTile(context, Icons.color_lens_outlined, 'Theme Color', trailing: _colorDots()),
              ]),
              const SizedBox(height: 12),
              _buildSection('Preferences', [
                _buildNavTile(context, Icons.notifications_outlined, 'Notifications',
                    sub: 'Prayer times & Daily verses', onTap: () {}),
                _buildNavTile(context, Icons.language_outlined, 'App Language',
                    sub: 'English (US)', onTap: () {}),
              ]),
              const SizedBox(height: 12),
              _buildSection('Account', [
                _buildNavTile(context, Icons.lock_outline_rounded, 'Change Password',
                    onTap: () => context.push('/profile/password')),
                _buildNavTile(context, Icons.shield_outlined, 'Privacy Settings', onTap: () {}),
                _buildNavTile(context, Icons.privacy_tip_outlined, 'Privacy Policy',
                    onTap: () => context.push('/privacy-policy')),
                _buildNavTile(context, Icons.description_outlined, 'Terms of Service',
                    onTap: () => context.push('/terms-of-service')),
                _buildNavTile(context, Icons.help_outline_rounded, 'Help & Support', onTap: () {}),
              ]),
              const SizedBox(height: 20),
              _buildLogoutButton(context),
              const SizedBox(height: 12),
              Text('Amanah Version 2.4.1 (Build 108)',
                  style: TextStyle(fontSize: 11, color: Colors.grey.shade400)),
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
              child: Text('Profile', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Color(0xFF1A2E25))),
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

  Widget _buildProfileCard(BuildContext context, String fullName, String initials, String bio, dynamic score) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 12, offset: const Offset(0, 2))],
        ),
        child: Column(
          children: [
            // Avatar
            Stack(
              children: [
                Container(
                  width: 72, height: 72,
                  decoration: BoxDecoration(shape: BoxShape.circle, color: _primaryGreen),
                  child: Center(
                    child: Text(initials, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: Colors.white)),
                  ),
                ),
                Positioned(
                  bottom: 0, right: 0,
                  child: Container(
                    width: 22, height: 22,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(color: const Color(0xFFE0EBE5), width: 1.5),
                    ),
                    child: const Icon(Icons.camera_alt_rounded, size: 12, color: _primaryGreen),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(fullName, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Color(0xFF1A2E25))),
            const SizedBox(height: 4),
            Text(bio, style: const TextStyle(fontSize: 12, color: Color(0xFF6B8C7A))),
            const SizedBox(height: 16),
            // Amanah Score
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xFFE8F4EE),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('AMANAH SCORE', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: Color(0xFF6B8C7A), letterSpacing: 0.8)),
                      Text('$score', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: _primaryGreen)),
                    ],
                  ),
                  Row(
                    children: [
                      const Icon(Icons.trending_up_rounded, color: _primaryGreen, size: 16),
                      const SizedBox(width: 4),
                      Text('+12% this\nweek', style: const TextStyle(fontSize: 11, color: _primaryGreen, fontWeight: FontWeight.w500)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Expanded(child: _statCard(Icons.calendar_today_rounded, '48', 'Days Active')),
          const SizedBox(width: 12),
          Expanded(child: _statCard(Icons.mosque_rounded, '214', 'Prayers\nLogged')),
          const SizedBox(width: 12),
          Expanded(child: _statCard(Icons.menu_book_rounded, '86', 'Pages\nRead')),
        ],
      ),
    );
  }

  Widget _statCard(IconData icon, String value, String label) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: _primaryGreen),
          const SizedBox(height: 6),
          Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: Color(0xFF1A2E25))),
          Text(label, style: const TextStyle(fontSize: 10, color: Color(0xFF6B8C7A), height: 1.3)),
        ],
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> items) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF6B8C7A))),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8)],
            ),
            child: Column(
              children: items.asMap().entries.map((e) {
                final isLast = e.key == items.length - 1;
                return Column(
                  children: [
                    e.value,
                    if (!isLast) Divider(height: 1, color: Colors.grey.shade100, indent: 52),
                  ],
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavTile(BuildContext context, IconData icon, String title, {String? sub, Widget? trailing, VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Icon(icon, size: 20, color: const Color(0xFF1B5E45)),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Color(0xFF1A2E25))),
                  if (sub != null) Text(sub, style: const TextStyle(fontSize: 11, color: Color(0xFF6B8C7A))),
                ],
              ),
            ),
            trailing ?? Icon(Icons.chevron_right_rounded, size: 18, color: Colors.grey.shade400),
          ],
        ),
      ),
    );
  }

  Widget _buildToggleTile(IconData icon, String title, bool value, ValueChanged<bool> onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          Icon(icon, size: 20, color: const Color(0xFF1B5E45)),
          const SizedBox(width: 14),
          Expanded(child: Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Color(0xFF1A2E25)))),
          Switch(value: value, onChanged: onChanged, activeColor: _primaryGreen),
        ],
      ),
    );
  }

  Widget _colorDots() {
    return Row(
      children: [
        _dot(const Color(0xFF1B5E45)),
        const SizedBox(width: 4),
        _dot(const Color(0xFF2E7D5E)),
        const SizedBox(width: 4),
        _dot(const Color(0xFF3D5A4C)),
      ],
    );
  }

  Widget _dot(Color color) {
    return Container(
      width: 14, height: 14,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GestureDetector(
        onTap: () => _showLogoutDialog(context),
        child: Container(
          width: double.infinity,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.red.shade200),
            boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8)],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.logout_rounded, color: Colors.red.shade400, size: 18),
              const SizedBox(width: 8),
              Text('Logout', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.red.shade400)),
            ],
          ),
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 52, height: 52,
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F4EE),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.logout_rounded, color: _primaryGreen, size: 26),
              ),
              const SizedBox(height: 16),
              const Text('Confirm Logout',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: Color(0xFF1A2E25))),
              const SizedBox(height: 10),
              const Text(
                'Are you sure you want to logout? You will need to sign back in to access your spiritual progress and circles.',
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
                    context.read<AuthProvider>().logout();
                    context.go('/login');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _primaryGreen,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Stay', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                ),
              ),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: () async {
                  Navigator.of(ctx).pop();
                  await context.read<AuthProvider>().logout();
                  if (context.mounted) context.go('/login');
                },
                child: Text('Logout', style: TextStyle(fontSize: 13.5, color: Colors.red.shade400, fontWeight: FontWeight.w500)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getInitials(String name) {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    if (parts.isNotEmpty && parts[0].isNotEmpty) return parts[0][0].toUpperCase();
    return 'U';
  }
}