// lib/features/auth/screens/change_password_screen.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _currentController = TextEditingController();
  final _newController = TextEditingController();
  final _confirmController = TextEditingController();

  bool _obscureCurrent = true;
  bool _obscureNew = true;
  bool _obscureConfirm = true;

  static const Color _primaryGreen = Color(0xFF1B5E45);
  static const Color _bgColor = Color(0xFFEFF4F1);
  static const Color _hintColor = Color(0xFFADBFB5);

  @override
  void dispose() {
    _currentController.dispose();
    _newController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  String _getStrength(String pw) {
    if (pw.isEmpty) return '';
    if (pw.length < 6) return 'Weak';
    if (pw.length < 10) return 'Fair';
    final hasUpper = pw.contains(RegExp(r'[A-Z]'));
    final hasDigit = pw.contains(RegExp(r'[0-9]'));
    final hasSpecial = pw.contains(RegExp(r'[!@#\$%^&*]'));
    if (hasUpper && hasDigit && hasSpecial) return 'Strong';
    return 'Good';
  }

  Color _strengthColor(String s) {
    switch (s) {
      case 'Weak': return Colors.red;
      case 'Fair': return Colors.orange;
      case 'Good': return Colors.amber;
      case 'Strong': return _primaryGreen;
      default: return Colors.grey.shade300;
    }
  }

  double _strengthValue(String s) {
    switch (s) {
      case 'Weak': return 0.25;
      case 'Fair': return 0.5;
      case 'Good': return 0.75;
      case 'Strong': return 1.0;
      default: return 0;
    }
  }

  Future<void> _handleUpdate() async {
    if (!_formKey.currentState!.validate()) return;
    final provider = context.read<AuthProvider>();
    final success = await provider.changePassword(
      oldPassword: _currentController.text,
      newPassword: _newController.text,
    );
    if (!mounted) return;
    if (success) {
      _showSuccessDialog();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(provider.errorMessage ?? 'Failed to update password.'),
          backgroundColor: Colors.red.shade600,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 60, height: 60,
                decoration: const BoxDecoration(color: _primaryGreen, shape: BoxShape.circle),
                child: const Icon(Icons.check_rounded, color: Colors.white, size: 30),
              ),
              const SizedBox(height: 16),
              const Text('Password Updated',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Color(0xFF1A2E25))),
              const SizedBox(height: 10),
              const Text(
                'Your account security has been successfully updated with your new credentials.',
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
                  child: const Text('Back to Profile', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
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
    final strength = _getStrength(_newController.text);
    final provider = context.watch<AuthProvider>();

    return Scaffold(
      backgroundColor: _bgColor,
      body: SafeArea(
        child: SingleChildScrollView(
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
                        child: Text('Change Password',
                            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Color(0xFF1A2E25))),
                      ),
                    ),
                    Container(
                      width: 32, height: 32,
                      decoration: BoxDecoration(color: _primaryGreen, borderRadius: BorderRadius.circular(8)),
                      child: const Icon(Icons.lock_outline_rounded, size: 16, color: Colors.white),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // Shield icon
              Container(
                width: 64, height: 64,
                decoration: BoxDecoration(color: const Color(0xFFE8F4EE), shape: BoxShape.circle),
                child: const Icon(Icons.shield_outlined, size: 32, color: _primaryGreen),
              ),
              const SizedBox(height: 16),
              const Text('Secure Your Amanah',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: Color(0xFF1A2E25))),
              const SizedBox(height: 6),
              const Text(
                'Update your credentials to ensure your\naccount stays protected.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 13, color: Color(0xFF6B8C7A), height: 1.5),
              ),

              const SizedBox(height: 32),

              // Form
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildLabel('Current Password'),
                      const SizedBox(height: 8),
                      _buildField(
                        controller: _currentController,
                        hint: '••••••••',
                        obscure: _obscureCurrent,
                        onToggle: () => setState(() => _obscureCurrent = !_obscureCurrent),
                        validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                      ),

                      const SizedBox(height: 16),
                      _buildLabel('New Password'),
                      const SizedBox(height: 8),
                      _buildField(
                        controller: _newController,
                        hint: '••••••••',
                        obscure: _obscureNew,
                        onToggle: () => setState(() => _obscureNew = !_obscureNew),
                        onChanged: (_) => setState(() {}),
                        validator: (v) {
                          if (v == null || v.isEmpty) return 'Required';
                          if (v.length < 8) return 'Minimum 8 characters';
                          return null;
                        },
                      ),

                      // Strength indicator
                      if (_newController.text.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(4),
                                child: LinearProgressIndicator(
                                  value: _strengthValue(strength),
                                  backgroundColor: Colors.grey.shade200,
                                  valueColor: AlwaysStoppedAnimation(_strengthColor(strength)),
                                  minHeight: 4,
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Text(strength,
                                style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: _strengthColor(strength))),
                            const SizedBox(width: 8),
                            Text('At least 8 characters',
                                style: TextStyle(fontSize: 10, color: Colors.grey.shade400)),
                          ],
                        ),
                      ],

                      const SizedBox(height: 16),
                      _buildLabel('Confirm New Password'),
                      const SizedBox(height: 8),
                      _buildField(
                        controller: _confirmController,
                        hint: '••••••••',
                        obscure: _obscureConfirm,
                        onToggle: () => setState(() => _obscureConfirm = !_obscureConfirm),
                        validator: (v) {
                          if (v == null || v.isEmpty) return 'Required';
                          if (v != _newController.text) return 'Passwords do not match';
                          return null;
                        },
                      ),

                      const SizedBox(height: 16),

                      // Tip
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE8F4EE),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.info_outline_rounded, size: 16, color: _primaryGreen),
                            const SizedBox(width: 8),
                            const Expanded(
                              child: Text(
                                'Strong passwords include a mix of uppercase letters, numbers, and special symbols like @, # or \$.',
                                style: TextStyle(fontSize: 11, color: Color(0xFF3D5A4C), height: 1.4),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 28),

                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton(
                          onPressed: provider.isLoading ? null : _handleUpdate,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _primaryGreen,
                            foregroundColor: Colors.white,
                            disabledBackgroundColor: _primaryGreen.withValues(alpha: 0.6),
                            elevation: 0,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          child: provider.isLoading
                              ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5))
                              : const Text('Update Password', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                        ),
                      ),

                      const SizedBox(height: 16),

                      Center(
                        child: GestureDetector(
                          onTap: () => context.push('/forgot-password'),
                          child: const Text('Forgot your password?',
                              style: TextStyle(fontSize: 13, color: Color(0xFF2E7D5E), fontWeight: FontWeight.w500)),
                        ),
                      ),

                      const SizedBox(height: 28),

                      // Bottom info row
                      Row(
                        children: [
                          Expanded(child: _infoCard(Icons.devices_rounded, 'Active Devices', '3 currently logged in')),
                          const SizedBox(width: 12),
                          Expanded(child: _infoCard(Icons.history_rounded, 'Last Changed', '4 months ago')),
                        ],
                      ),

                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(text, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Color(0xFF3D5A4C)));
  }

  Widget _buildField({
    required TextEditingController controller,
    required String hint,
    required bool obscure,
    required VoidCallback onToggle,
    ValueChanged<String>? onChanged,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      onChanged: onChanged,
      style: const TextStyle(fontSize: 14, color: Color(0xFF1A2E25)),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: _hintColor, fontSize: 13.5),
        prefixIcon: const Icon(Icons.lock_outline_rounded, color: _hintColor, size: 18),
        suffixIcon: GestureDetector(
          onTap: onToggle,
          child: Icon(obscure ? Icons.visibility_outlined : Icons.visibility_off_outlined, color: _hintColor, size: 20),
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFFE0EBE5))),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFFE0EBE5))),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFF2E7D5E), width: 1.5)),
        errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.red.shade300)),
        focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.red.shade400, width: 1.5)),
      ),
      validator: validator,
    );
  }

  Widget _infoCard(IconData icon, String title, String sub) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8)],
      ),
      child: Row(
        children: [
          Icon(icon, size: 18, color: const Color(0xFF1B5E45)),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF1A2E25))),
                Text(sub, style: const TextStyle(fontSize: 10, color: Color(0xFF6B8C7A))),
              ],
            ),
          ),
        ],
      ),
    );
  }
}