// lib/features/prayer/screens/qibla_screen.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'dart:math' as math;

class QiblaScreen extends StatefulWidget {
  const QiblaScreen({super.key});

  @override
  State<QiblaScreen> createState() => _QiblaScreenState();
}

class _QiblaScreenState extends State<QiblaScreen> with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  double _qiblaDegrees = 0; // Will be replaced with real qibla data from provider

  static const Color _primaryGreen = Color(0xFF1B5E45);
  static const Color _bgColor = Color(0xFFEFF4F1);

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(vsync: this, duration: const Duration(seconds: 2))..repeat(reverse: true);
    _loadQibla();
  }

  Future<void> _loadQibla() async {
    // In a real implementation, use flutter_qiblah:
    // final qibla = await FlutterQiblah.getQibla();
    // setState(() => _qiblaDegrees = qibla.qibla);
    // For now, use a default (Makkah is roughly 90° from most places as placeholder)
    setState(() => _qiblaDegrees = 90.0);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
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
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
                child: Column(
                  children: [
                    _buildCompass(),
                    const SizedBox(height: 24),
                    _buildInfoCard(),
                    const SizedBox(height: 16),
                    _buildTip(),
                  ],
                ),
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
              child: Text('Qibla Direction',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Color(0xFF1A2E25))),
            ),
          ),
          const SizedBox(width: 36),
        ],
      ),
    );
  }

  Widget _buildCompass() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 16)],
      ),
      child: Column(
        children: [
          const Text('Point toward Makkah', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Color(0xFF1A2E25))),
          const SizedBox(height: 6),
          Text('${_qiblaDegrees.toStringAsFixed(1)}° from North',
              style: const TextStyle(fontSize: 12, color: Color(0xFF6B8C7A))),
          const SizedBox(height: 32),

          // Compass
          SizedBox(
            width: 240,
            height: 240,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Outer ring
                Container(
                  width: 240, height: 240,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: const Color(0xFFE0EBE5), width: 2),
                  ),
                ),
                // Pulse animation
                AnimatedBuilder(
                  animation: _pulseController,
                  builder: (_, __) => Container(
                    width: 200 + (_pulseController.value * 10),
                    height: 200 + (_pulseController.value * 10),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: _primaryGreen.withValues(alpha: 0.15 + _pulseController.value * 0.1),
                        width: 1,
                      ),
                    ),
                  ),
                ),
                // Inner circle
                Container(
                  width: 180, height: 180,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFFF7FAF8),
                    border: Border.all(color: const Color(0xFFD0E5D8), width: 1.5),
                  ),
                ),
                // Cardinal directions
                ..._buildCardinalLabels(),
                // Qibla needle
                Transform.rotate(
                  angle: _qiblaDegrees * math.pi / 180,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Needle up (pointing to Qibla)
                      Container(
                        width: 4,
                        height: 72,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [_primaryGreen, Color(0xFF2E7D5E)],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      // Center dot
                      Container(
                        width: 12, height: 12,
                        decoration: const BoxDecoration(color: _primaryGreen, shape: BoxShape.circle),
                      ),
                      // Needle down (opposite)
                      Container(
                        width: 4,
                        height: 72,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ],
                  ),
                ),
                // Kaaba icon at top of needle direction
                Positioned(
                  top: 16,
                  child: Transform.rotate(
                    angle: _qiblaDegrees * math.pi / 180,
                    child: const Icon(Icons.mosque_rounded, color: _primaryGreen, size: 22),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          // Degree display
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(color: const Color(0xFFE8F4EE), borderRadius: BorderRadius.circular(20)),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.explore_rounded, color: _primaryGreen, size: 16),
                const SizedBox(width: 8),
                Text('${_qiblaDegrees.toStringAsFixed(0)}°',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: _primaryGreen)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildCardinalLabels() {
    const labels = ['N', 'E', 'S', 'W'];
    const offsets = [
      Offset(0, -98),
      Offset(98, 0),
      Offset(0, 98),
      Offset(-98, 0),
    ];
    return List.generate(4, (i) => Positioned(
      left: 120 + offsets[i].dx - 8,
      top: 120 + offsets[i].dy - 8,
      child: Text(labels[i], style: TextStyle(
        fontSize: 12, fontWeight: FontWeight.w700,
        color: i == 0 ? _primaryGreen : Colors.grey.shade400,
      )),
    ));
  }

  Widget _buildInfoCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8)],
      ),
      child: Row(
        children: [
          Container(
            width: 44, height: 44,
            decoration: BoxDecoration(color: const Color(0xFFE8F4EE), borderRadius: BorderRadius.circular(12)),
            child: const Icon(Icons.location_on_rounded, color: _primaryGreen, size: 22),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Makkah Al-Mukarramah', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFF1A2E25))),
                Text('21.3891° N, 39.8579° E', style: TextStyle(fontSize: 11, color: Color(0xFF6B8C7A))),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Text('Distance', style: TextStyle(fontSize: 10, color: Color(0xFF6B8C7A))),
              const Text('~4,200 km', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: _primaryGreen)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTip() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFE8F4EE),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFD0E5D8)),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline_rounded, size: 16, color: _primaryGreen),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              'Hold your device flat and away from metal objects for the most accurate reading. The green needle points toward the Qibla.',
              style: TextStyle(fontSize: 12, color: Color(0xFF3D5A4C), height: 1.4),
            ),
          ),
        ],
      ),
    );
  }
}