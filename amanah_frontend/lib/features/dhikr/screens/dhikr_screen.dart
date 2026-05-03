// lib/features/dhikr/screens/dhikr_screen.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../providers/dhikr_provider.dart';

class DhikrScreen extends StatelessWidget {
  const DhikrScreen({super.key});

  static const Color _primaryGreen = Color(0xFF1B5E45);
  static const Color _bgColor = Color(0xFFEFF4F1);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgColor,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: Consumer<DhikrProvider>(
                builder: (context, provider, _) {
                  return SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
                    child: Column(
                      children: [
                        ...provider.dhikrs.map((d) => _DhikrCard(dhikr: d)),
                        const SizedBox(height: 16),
                        _buildAddCustomButton(context),
                      ],
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
              child: Text('Dhikr', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Color(0xFF1A2E25))),
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

  Widget _buildAddCustomButton(BuildContext context) {
    return GestureDetector(
      onTap: () => _showAddCustomSheet(context),
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
            Icon(Icons.add_circle_outline_rounded, color: _primaryGreen, size: 18),
            SizedBox(width: 8),
            Text('Add Custom Dhikr',
                style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w500, color: _primaryGreen)),
          ],
        ),
      ),
    );
  }

  void _showAddCustomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const _AddCustomDhikrSheet(),
    );
  }
}

// ── Dhikr Card ─────────────────────────────────────────────────────────────
class _DhikrCard extends StatelessWidget {
  final DhikrItem dhikr;
  const _DhikrCard({required this.dhikr});

  static const Color _primaryGreen = Color(0xFF1B5E45);

  @override
  Widget build(BuildContext context) {
    final provider = context.read<DhikrProvider>();
    final progress = dhikr.target > 0 ? dhikr.count / dhikr.target : 0.0;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 2))],
      ),
      child: Column(
        children: [
          // Title row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(dhikr.name,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Color(0xFF1A2E25))),
                  Text(dhikr.subtitle,
                      style: const TextStyle(fontSize: 12, color: Color(0xFF6B8C7A))),
                ],
              ),
              Text(
                dhikr.arabicText,
                style: const TextStyle(
                  fontSize: 20,
                  color: _primaryGreen,
                  fontWeight: FontWeight.w500,
                ),
                textDirection: TextDirection.rtl,
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Counter circle
          GestureDetector(
            onTap: () => provider.increment(dhikr.id),
            child: Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _primaryGreen,
                boxShadow: [
                  BoxShadow(
                    color: _primaryGreen.withValues(alpha: 0.3),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${dhikr.count}',
                    style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: Colors.white, height: 1),
                  ),
                  const Text('COUNT', style: TextStyle(fontSize: 8, color: Colors.white70, letterSpacing: 1)),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Progress bar
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Progress', style: TextStyle(fontSize: 11, color: Color(0xFF6B8C7A))),
                  Text('${dhikr.count}/${dhikr.target}',
                      style: const TextStyle(fontSize: 11, color: Color(0xFF6B8C7A))),
                ],
              ),
              const SizedBox(height: 6),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: progress.clamp(0.0, 1.0),
                  backgroundColor: const Color(0xFFE0EBE5),
                  valueColor: const AlwaysStoppedAnimation<Color>(_primaryGreen),
                  minHeight: 6,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Reset button
          GestureDetector(
            onTap: () => _showResetDialog(context, dhikr, provider),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.refresh_rounded, size: 14, color: Colors.grey.shade400),
                const SizedBox(width: 4),
                Text('Reset', style: TextStyle(fontSize: 12, color: Colors.grey.shade400)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showResetDialog(BuildContext context, DhikrItem dhikr, DhikrProvider provider) {
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
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.red.shade300, width: 2),
                ),
                child: Icon(Icons.refresh_rounded, color: Colors.red.shade400, size: 24),
              ),
              const SizedBox(height: 16),
              const Text('Reset Counter?',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: Color(0xFF1A2E25))),
              const SizedBox(height: 10),
              const Text(
                'Are you sure you want to reset this counter? This action cannot be undone and will clear your current session progress.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 13, color: Color(0xFF6B8C7A), height: 1.5),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 46,
                child: ElevatedButton(
                  onPressed: () {
                    provider.reset(dhikr.id);
                    Navigator.of(ctx).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1B5E45),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Reset', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
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
}

// ── Add Custom Dhikr Bottom Sheet ──────────────────────────────────────────
class _AddCustomDhikrSheet extends StatefulWidget {
  const _AddCustomDhikrSheet();

  @override
  State<_AddCustomDhikrSheet> createState() => _AddCustomDhikrSheetState();
}

class _AddCustomDhikrSheetState extends State<_AddCustomDhikrSheet> {
  final _nameController = TextEditingController();
  final _arabicController = TextEditingController();
  int _target = 100;

  static const Color _primaryGreen = Color(0xFF1B5E45);

  @override
  void dispose() {
    _nameController.dispose();
    _arabicController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle
          Center(
            child: Container(
              width: 40, height: 4,
              decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2)),
            ),
          ),
          const SizedBox(height: 20),

          // Header
          Row(
            children: [
              Container(
                width: 32, height: 32,
                decoration: BoxDecoration(color: const Color(0xFFE8F4EE), borderRadius: BorderRadius.circular(8)),
                child: const Icon(Icons.add_rounded, color: _primaryGreen, size: 18),
              ),
              const SizedBox(width: 10),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Add Custom Dhikr', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Color(0xFF1A2E25))),
                  Text('Set your personal spiritual goal', style: TextStyle(fontSize: 11, color: Color(0xFF6B8C7A))),
                ],
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Dhikr Name
          const Text('Dhikr Name', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Color(0xFF3D5A4C))),
          const SizedBox(height: 8),
          _buildInput(_nameController, 'e.g., Astaghfirullah'),

          const SizedBox(height: 16),

          // Arabic Text
          const Text('Arabic Text (optional)', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Color(0xFF3D5A4C))),
          const SizedBox(height: 8),
          TextField(
            controller: _arabicController,
            maxLines: 3,
            textDirection: TextDirection.rtl,
            style: const TextStyle(fontSize: 18, color: Color(0xFF1A2E25), height: 1.6),
            decoration: _inputDeco('أستغفر الله'),
          ),

          const SizedBox(height: 16),

          // Target Count
          const Text('Target Count', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Color(0xFF3D5A4C))),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF7FAF8),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: const Color(0xFFE0EBE5)),
                  ),
                  child: Text('$_target', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF1A2E25))),
                ),
              ),
              const SizedBox(width: 12),
              _counterBtn(Icons.remove_rounded, () => setState(() => _target = (_target - 10).clamp(10, 9999))),
              const SizedBox(width: 8),
              _counterBtn(Icons.add_rounded, () => setState(() => _target = (_target + 10).clamp(10, 9999))),
            ],
          ),

          const SizedBox(height: 24),

          // Buttons
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: Container(
                    height: 46,
                    decoration: BoxDecoration(
                      border: Border.all(color: const Color(0xFFD0E5D8)),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Center(child: Text('Cancel', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Color(0xFF6B8C7A)))),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    if (_nameController.text.trim().isEmpty) return;
                    context.read<DhikrProvider>().addCustomDhikr(
                      name: _nameController.text.trim(),
                      arabicText: _arabicController.text.trim(),
                      target: _target,
                    );
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _primaryGreen,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    minimumSize: const Size(0, 46),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Add Dhikr', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInput(TextEditingController controller, String hint) {
    return TextField(
      controller: controller,
      style: const TextStyle(fontSize: 14, color: Color(0xFF1A2E25)),
      decoration: _inputDeco(hint),
    );
  }

  InputDecoration _inputDeco(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Color(0xFFADBFB5), fontSize: 13.5),
      filled: true,
      fillColor: const Color(0xFFF7FAF8),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFFE0EBE5))),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFFE0EBE5))),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFF2E7D5E), width: 1.5)),
    );
  }

  Widget _counterBtn(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40, height: 40,
        decoration: BoxDecoration(
          color: const Color(0xFFE8F4EE),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, size: 18, color: _primaryGreen),
      ),
    );
  }
}