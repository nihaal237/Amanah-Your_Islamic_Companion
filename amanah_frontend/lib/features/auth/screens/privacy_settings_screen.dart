// lib/features/auth/screens/privacy_settings_screen.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PrivacySettingsScreen extends StatefulWidget {
  const PrivacySettingsScreen({super.key});

  @override
  State<PrivacySettingsScreen> createState() => _PrivacySettingsScreenState();
}

class _PrivacySettingsScreenState extends State<PrivacySettingsScreen> {
  String _scoreVisibility = 'everyone';
  bool _discoverableByEmail = false;
  bool _showOnlineStatus = false;
  bool _prayerRequestAlerts = false;
  // ✅ Removed unused _anonymousGiving and _mosquePresence fields

  static const Color _primaryGreen = Color(0xFF1B5E45);
  static const Color _bgColor = Color(0xFFEFF4F1);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 32),
          child: Column(
            children: [
              _buildHeader(context),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeroCard(),
                    const SizedBox(height: 20),
                    _buildScoreVisibility(),
                    const SizedBox(height: 20),
                    _buildProfileVisibility(),
                    const SizedBox(height: 20),
                    _buildCommunitySettings(),
                    const SizedBox(height: 20),
                    _buildDataManagement(context),
                  ],
                ),
              ),
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
              child: Text('Privacy Preferences',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Color(0xFF1A2E25))),
            ),
          ),
          Icon(Icons.more_vert_rounded, color: Colors.grey.shade400),
        ],
      ),
    );
  }

  Widget _buildHeroCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8)],
      ),
      child: Column(
        children: [
          Container(
            width: 52, height: 52,
            decoration: BoxDecoration(color: const Color(0xFFE8F4EE), shape: BoxShape.circle),
            child: const Icon(Icons.shield_rounded, color: _primaryGreen, size: 26),
          ),
          const SizedBox(height: 12),
          const Text('Your Privacy, Your Amanah',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Color(0xFF1A2E25))),
          const SizedBox(height: 6),
          const Text(
            'Control how your spiritual journey and data are visible to the community while maintaining your trust.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12, color: Color(0xFF6B8C7A), height: 1.4),
          ),
        ],
      ),
    );
  }

  Widget _buildScoreVisibility() {
    return _sectionWidget(
      icon: Icons.star_rounded,
      title: 'Amanah Score Visibility',
      sub: 'Choose who can see your spiritual activity score and achievements.',
      child: Column(
        children: [
          _customRadioOption('everyone', 'Everyone', 'Visible to all Amanah users', Icons.public_rounded),
          _customRadioOption('circles', 'Circles', 'Only your trusted community circles', Icons.people_rounded),
          _customRadioOption('only_me', 'Only Me', 'Keep your progress private', Icons.lock_outline_rounded),
        ],
      ),
    );
  }

  // ✅ Custom radio tile — avoids deprecated Radio groupValue/onChanged/activeColor
  Widget _customRadioOption(String value, String label, String sub, IconData icon) {
    final isSelected = _scoreVisibility == value;
    return GestureDetector(
      onTap: () => setState(() => _scoreVisibility = value),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Row(
          children: [
            Container(
              width: 36, height: 36,
              decoration: BoxDecoration(color: const Color(0xFFE8F4EE), borderRadius: BorderRadius.circular(10)),
              child: Icon(icon, color: _primaryGreen, size: 18),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Color(0xFF1A2E25))),
                  Text(sub, style: const TextStyle(fontSize: 11, color: Color(0xFF6B8C7A))),
                ],
              ),
            ),
            // ✅ Custom circle indicator instead of Radio widget
            Container(
              width: 20, height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: isSelected ? _primaryGreen : Colors.grey.shade300, width: 2),
                color: isSelected ? _primaryGreen : Colors.transparent,
              ),
              child: isSelected
                  ? const Icon(Icons.check_rounded, size: 12, color: Colors.white)
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileVisibility() {
    return _sectionWidget(
      icon: Icons.person_outline_rounded,
      title: 'Profile Visibility',
      child: Column(
        children: [
          _toggleTile('Discoverable by Email',
              'Allow others to find your profile via contact sync.', _discoverableByEmail,
              (v) => setState(() => _discoverableByEmail = v)),
          _toggleTile('Show Online Status',
              'Let others know when you are active for prayers.', _showOnlineStatus,
              (v) => setState(() => _showOnlineStatus = v)),
          _toggleTile('Prayer Request Alerts',
              'Share your ad-hoc prayer requests to the community.', _prayerRequestAlerts,
              (v) => setState(() => _prayerRequestAlerts = v)),
        ],
      ),
    );
  }

  Widget _toggleTile(String title, String sub, bool value, ValueChanged<bool> onChanged) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Color(0xFF1A2E25))),
                Text(sub, style: const TextStyle(fontSize: 11, color: Color(0xFF6B8C7A), height: 1.4)),
              ],
            ),
          ),
          // ✅ activeThumbColor instead of deprecated activeColor
          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: Colors.white,
            activeTrackColor: _primaryGreen,
          ),
        ],
      ),
    );
  }

  Widget _buildCommunitySettings() {
    return _sectionWidget(
      icon: Icons.people_alt_rounded,
      title: 'Community Settings',
      child: Column(
        children: [
          _navTile(Icons.volunteer_activism_rounded, 'Anonymous Giving', 'Currently Private'),
          const SizedBox(height: 10),
          _navTile(Icons.mosque_rounded, 'Mosque Presence', 'Disabled',
              sub: 'Auto-share your location when arriving for Jemaah prayer.'),
        ],
      ),
    );
  }

  Widget _navTile(IconData icon, String title, String value, {String? sub}) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: const Color(0xFFF7FAF8), borderRadius: BorderRadius.circular(10)),
      child: Row(
        children: [
          Container(
            width: 32, height: 32,
            decoration: BoxDecoration(color: const Color(0xFFE8F4EE), borderRadius: BorderRadius.circular(8)),
            child: Icon(icon, color: _primaryGreen, size: 16),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Color(0xFF1A2E25))),
                if (sub != null) Text(sub, style: const TextStyle(fontSize: 10, color: Color(0xFF6B8C7A), height: 1.3)),
                Text(value, style: const TextStyle(fontSize: 11, color: Color(0xFF6B8C7A))),
              ],
            ),
          ),
          Icon(Icons.chevron_right_rounded, color: Colors.grey.shade400),
        ],
      ),
    );
  }

  Widget _buildDataManagement(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.red.shade100),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8)],
      ),
      child: Row(
        children: [
          Container(
            width: 36, height: 36,
            decoration: BoxDecoration(color: Colors.red.shade50, borderRadius: BorderRadius.circular(10)),
            child: Icon(Icons.delete_outline_rounded, color: Colors.red.shade400, size: 18),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Data Management', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF1A2E25))),
                Text('Delete account & permanently erase all your data', style: TextStyle(fontSize: 11, color: Color(0xFF6B8C7A))),
              ],
            ),
          ),
          GestureDetector(
            onTap: () => _showDeleteDialog(context),
            child: Icon(Icons.chevron_right_rounded, color: Colors.red.shade300),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(BuildContext context) {
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
                decoration: BoxDecoration(color: Colors.red.shade50, shape: BoxShape.circle),
                child: Icon(Icons.delete_outline_rounded, color: Colors.red.shade400, size: 26),
              ),
              const SizedBox(height: 16),
              const Text('Delete Account?',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: Color(0xFF1A2E25))),
              const SizedBox(height: 10),
              const Text(
                'This action is permanent and cannot be undone. All your dhikr history, community contributions, and earned goals will be erased forever.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 13, color: Color(0xFF6B8C7A), height: 1.5),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity, height: 46,
                child: ElevatedButton(
                  onPressed: () => Navigator.of(ctx).pop(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red.shade500,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Delete Permanently', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                ),
              ),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: () => Navigator.of(ctx).pop(),
                child: const Text('Cancel', style: TextStyle(fontSize: 13.5, color: Color(0xFF6B8C7A))),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionWidget({required IconData icon, required String title, String? sub, required Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 16, color: _primaryGreen),
            const SizedBox(width: 8),
            Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFF1A2E25))),
          ],
        ),
        if (sub != null) ...[
          const SizedBox(height: 4),
          Text(sub, style: const TextStyle(fontSize: 12, color: Color(0xFF6B8C7A))),
        ],
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8)],
          ),
          child: child,
        ),
      ],
    );
  }
}