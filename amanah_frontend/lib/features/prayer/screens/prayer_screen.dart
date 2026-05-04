// lib/features/prayer/screens/prayer_screen.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:hijri/hijri_calendar.dart';
import '../providers/prayer_provider.dart';

class PrayerScreen extends StatefulWidget {
  const PrayerScreen({super.key});

  @override
  State<PrayerScreen> createState() => _PrayerScreenState();
}

class _PrayerScreenState extends State<PrayerScreen> {
  static const Color _primaryGreen = Color(0xFF1B5E45);
  static const Color _bgColor = Color(0xFFEFF4F1);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PrayerProvider>().fetchPrayerTimes();
      context.read<PrayerProvider>().fetchPrayerHistory();
    });
  }

  @override
  Widget build(BuildContext context) {
    final hijri = HijriCalendar.now();
    final hijriStr = '${hijri.hDay} ${hijri.longMonthName} ${hijri.hYear}';
    final gregStr = DateFormat('EEEE, MMMM d').format(DateTime.now());

    return Scaffold(
      backgroundColor: _bgColor,
      body: SafeArea(
        child: RefreshIndicator(
          color: _primaryGreen,
          onRefresh: () => context.read<PrayerProvider>().fetchPrayerTimes(),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              children: [
                _buildHeader(context),
                const SizedBox(height: 16),
                _buildDateCard(hijriStr, gregStr),
                const SizedBox(height: 16),
                _buildNextPrayerHero(),
                const SizedBox(height: 20),
                _buildAllPrayers(),
                const SizedBox(height: 20),
                _buildQiblaCard(context),
                const SizedBox(height: 20),
                _buildHistoryCard(),
                const SizedBox(height: 24),
              ],
            ),
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
              child: Text('Prayer Times',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Color(0xFF1A2E25))),
            ),
          ),
          GestureDetector(
            onTap: () => context.push('/prayer/qibla'),
            child: Container(
              width: 36, height: 36,
              decoration: BoxDecoration(
                color: _primaryGreen,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.explore_rounded, color: Colors.white, size: 18),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateCard(String hijriStr, String gregStr) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8)],
        ),
        child: Row(
          children: [
            const Icon(Icons.calendar_today_rounded, size: 16, color: _primaryGreen),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(gregStr, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF1A2E25))),
                Text(hijriStr, style: const TextStyle(fontSize: 11, color: Color(0xFF6B8C7A))),
              ],
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(color: const Color(0xFFE8F4EE), borderRadius: BorderRadius.circular(12)),
              child: const Row(
                children: [
                  Icon(Icons.location_on_outlined, size: 12, color: _primaryGreen),
                  SizedBox(width: 4),
                  Text('Auto-detect', style: TextStyle(fontSize: 11, color: _primaryGreen, fontWeight: FontWeight.w500)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNextPrayerHero() {
    return Consumer<PrayerProvider>(
      builder: (context, provider, _) {
        final next = provider.nextPrayer ?? 'Asr';
        final time = provider.nextPrayerTime ?? '--:--';
        final until = provider.timeUntilNextPrayer ?? '';

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF1B5E45), Color(0xFF2E7D5E)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(color: const Color(0xFF1B5E45).withValues(alpha: 0.35), blurRadius: 20, offset: const Offset(0, 8)),
              ],
            ),
            child: Column(
              children: [
                Text('Next Prayer', style: TextStyle(fontSize: 12, color: Colors.white.withValues(alpha: 0.7), letterSpacing: 0.5)),
                const SizedBox(height: 8),
                Text(next, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: Colors.white)),
                const SizedBox(height: 4),
                Text(time, style: const TextStyle(fontSize: 44, fontWeight: FontWeight.w300, color: Colors.white, height: 1.1)),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(until, style: const TextStyle(fontSize: 13, color: Colors.white, fontWeight: FontWeight.w500)),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildAllPrayers() {
    return Consumer<PrayerProvider>(
      builder: (context, provider, _) {
        if (provider.isLoading) {
          return const Center(child: Padding(
            padding: EdgeInsets.all(24),
            child: CircularProgressIndicator(color: _primaryGreen),
          ));
        }

        final prayers = provider.todaysPrayers;
        if (prayers.isEmpty) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
              child: const Center(
                child: Column(
                  children: [
                    Icon(Icons.wifi_off_rounded, color: Color(0xFF6B8C7A), size: 32),
                    SizedBox(height: 8),
                    Text('Could not load prayer times.\nCheck your connection.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Color(0xFF6B8C7A), fontSize: 13)),
                  ],
                ),
              ),
            ),
          );
        }

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Today's Prayers",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Color(0xFF1A2E25))),
              const SizedBox(height: 12),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10)],
                ),
                child: ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: prayers.length,
                  separatorBuilder: (_, __) => Divider(height: 1, color: Colors.grey.shade100, indent: 56),
                  itemBuilder: (context, i) {
                    final p = prayers[i];
                    final isNext = p['name'] == provider.nextPrayer;
                    final isLogged = p['logged'] == true;
                    return _PrayerTile(
                      name: p['name'],
                      time: p['time'],
                      isNext: isNext,
                      isLogged: isLogged,
                      onLog: () => provider.logPrayer(p['name']),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildQiblaCard(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GestureDetector(
        onTap: () => context.push('/prayer/qibla'),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8)],
          ),
          child: Row(
            children: [
              Container(
                width: 48, height: 48,
                decoration: BoxDecoration(color: const Color(0xFFE8F4EE), borderRadius: BorderRadius.circular(14)),
                child: const Icon(Icons.explore_rounded, color: _primaryGreen, size: 26),
              ),
              const SizedBox(width: 14),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Qibla Direction', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFF1A2E25))),
                    Text('Find the direction of the Kaaba', style: TextStyle(fontSize: 12, color: Color(0xFF6B8C7A))),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(color: _primaryGreen, borderRadius: BorderRadius.circular(20)),
                child: const Text('Open', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHistoryCard() {
    return Consumer<PrayerProvider>(
      builder: (context, provider, _) {
        final history = provider.weekHistory;
        final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('This Week', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Color(0xFF1A2E25))),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8)],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: List.generate(7, (i) {
                    final count = history.length > i ? history[i] : 0;
                    final isToday = i == DateTime.now().weekday - 1;
                    return Column(
                      children: [
                        Text(days[i], style: TextStyle(fontSize: 10, color: isToday ? _primaryGreen : Colors.grey.shade400,
                            fontWeight: isToday ? FontWeight.w700 : FontWeight.w400)),
                        const SizedBox(height: 6),
                        Container(
                          width: 32, height: 32,
                          decoration: BoxDecoration(
                            color: count >= 5 ? _primaryGreen : count > 0 ? const Color(0xFFB8D9C8) : Colors.grey.shade100,
                            shape: BoxShape.circle,
                            border: isToday ? Border.all(color: _primaryGreen, width: 2) : null,
                          ),
                          child: Center(
                            child: Text('$count', style: TextStyle(
                              fontSize: 11, fontWeight: FontWeight.w700,
                              color: count >= 5 ? Colors.white : count > 0 ? _primaryGreen : Colors.grey.shade400,
                            )),
                          ),
                        ),
                      ],
                    );
                  }),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// ── Prayer Tile ────────────────────────────────────────────────────────────
class _PrayerTile extends StatelessWidget {
  final String name, time;
  final bool isNext, isLogged;
  final VoidCallback onLog;

  const _PrayerTile({required this.name, required this.time, required this.isNext, required this.isLogged, required this.onLog});

  static const Color _primaryGreen = Color(0xFF1B5E45);

  // Arabic names for each prayer
  static const Map<String, String> _arabicNames = {
    'Fajr': 'الفجر', 'Dhuhr': 'الظهر', 'Asr': 'العصر', 'Maghrib': 'المغرب', 'Isha': 'العشاء',
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: isNext ? _primaryGreen.withValues(alpha: 0.04) : null,
        borderRadius: isNext ? BorderRadius.circular(0) : null,
      ),
      child: Row(
        children: [
          Container(
            width: 38, height: 38,
            decoration: BoxDecoration(
              color: isNext ? _primaryGreen.withValues(alpha: 0.12) : Colors.grey.shade100,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(Icons.mosque_rounded, size: 18, color: isNext ? _primaryGreen : Colors.grey.shade400),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: TextStyle(fontSize: 14, fontWeight: isNext ? FontWeight.w700 : FontWeight.w500,
                    color: isNext ? _primaryGreen : const Color(0xFF1A2E25))),
                Text(_arabicNames[name] ?? '', style: TextStyle(fontSize: 12, color: isNext ? _primaryGreen.withValues(alpha: 0.7) : Colors.grey.shade400)),
              ],
            ),
          ),
          Text(time, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600,
              color: isNext ? _primaryGreen : const Color(0xFF3D5A4C))),
          const SizedBox(width: 12),
          GestureDetector(
            onTap: isLogged ? null : onLog,
            child: Container(
              width: 30, height: 30,
              decoration: BoxDecoration(
                color: isLogged ? _primaryGreen : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(isLogged ? Icons.check_rounded : Icons.add_rounded, size: 16,
                  color: isLogged ? Colors.white : Colors.grey.shade400),
            ),
          ),
        ],
      ),
    );
  }
}