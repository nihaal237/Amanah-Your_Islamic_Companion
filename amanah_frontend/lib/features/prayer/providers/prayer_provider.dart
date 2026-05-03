// lib/features/prayer/providers/prayer_provider.dart

import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import '../../../core/services/api_service.dart';
import '../../../core/constants/api_constants.dart';

class PrayerProvider extends ChangeNotifier {
  bool _isLoading = false;
  String? _errorMessage;

  // Raw prayer times from API
  Map<String, dynamic>? _prayerData;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Ordered prayer names
  static const _prayerOrder = ['Fajr', 'Dhuhr', 'Asr', 'Maghrib', 'Isha'];

  // ── Fetch prayer times ──────────────────────────────────────────────────
  Future<void> fetchPrayerTimes() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await ApiService.get(ApiConstants.prayerTimes);
      _prayerData = response.data;
    } catch (e) {
      _errorMessage = 'Could not load prayer times.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ── Log a completed prayer ──────────────────────────────────────────────
  Future<void> logPrayer(String prayerName) async {
    try {
      await ApiService.post(ApiConstants.prayerLog, data: {
        'prayer_name': prayerName,
        'logged_at': DateTime.now().toIso8601String(),
      });
      // Mark locally as logged
      if (_prayerData != null) {
        final timings = _prayerData!['timings'] as Map? ?? {};
        if (timings.containsKey(prayerName)) {
          // Refresh to get updated history
          fetchPrayerTimes();
        }
      }
    } catch (_) {}
  }

  // ── Today's prayers list for UI ─────────────────────────────────────────
  List<Map<String, dynamic>> get todaysPrayers {
    if (_prayerData == null) return [];
    final timings = _prayerData!['timings'] as Map? ?? {};
    final logged = _prayerData!['logged_today'] as List? ?? [];

    return _prayerOrder
        .where((name) => timings.containsKey(name))
        .map((name) => {
              'name': name,
              'time': _formatTime(timings[name]?.toString() ?? ''),
              'logged': logged.contains(name),
            })
        .toList();
  }

  // ── Next prayer ─────────────────────────────────────────────────────────
  String? get nextPrayer {
    if (_prayerData == null) return null;
    return _prayerData!['next_prayer']?.toString();
  }

  String? get nextPrayerTime {
    if (_prayerData == null) return null;
    final timings = _prayerData!['timings'] as Map? ?? {};
    final next = nextPrayer;
    if (next == null) return null;
    return _formatTime(timings[next]?.toString() ?? '');
  }

  String? get timeUntilNextPrayer {
    if (_prayerData == null) return null;
    final next = nextPrayer;
    if (next == null) return null;
    final timings = _prayerData!['timings'] as Map? ?? {};
    final timeStr = timings[next]?.toString();
    if (timeStr == null) return null;

    try {
      final parts = timeStr.split(':');
      final prayerDt = DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
        int.parse(parts[0]),
        int.parse(parts[1]),
      );
      final diff = prayerDt.difference(DateTime.now());
      if (diff.isNegative) return 'Passed';
      final h = diff.inHours;
      final m = diff.inMinutes % 60;
      if (h > 0) return 'in ${h}h ${m}m';
      return 'in ${m}m';
    } catch (_) {
      return null;
    }
  }

  // ── Helpers ─────────────────────────────────────────────────────────────
  String _formatTime(String raw) {
    // raw may be "HH:mm" or "HH:mm (EET)"
    try {
      final clean = raw.split(' ').first;
      final parts = clean.split(':');
      final hour = int.parse(parts[0]);
      final minute = int.parse(parts[1]);
      final dt = DateTime(2000, 1, 1, hour, minute);
      return DateFormat('h:mm a').format(dt);
    } catch (_) {
      return raw;
    }
  }
}