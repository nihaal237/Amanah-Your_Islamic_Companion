// lib/features/prayer/providers/prayer_provider.dart

import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import '../../../core/services/api_service.dart';
import '../../../core/constants/api_constants.dart';

class PrayerProvider extends ChangeNotifier {
  bool _isLoading = false;
  String? _errorMessage;
  Map<String, dynamic>? _prayerData;
  List<int> _weekHistory = List.filled(7, 0); // prayers logged per day this week

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  List<int> get weekHistory => _weekHistory;

  static const _prayerOrder = ['Fajr', 'Dhuhr', 'Asr', 'Maghrib', 'Isha'];

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

  Future<void> fetchPrayerHistory() async {
    try {
      final response = await ApiService.get(ApiConstants.prayerHistory);
      final data = response.data;
      // Backend returns list of {prayer_name, logged_at}
      // We count how many prayers were logged each day this week
      final history = data is List ? data : (data is Map && data.containsKey('results') ? data['results'] : []);
      final now = DateTime.now();
      final weekStart = now.subtract(Duration(days: now.weekday - 1)); // Monday

      final counts = List<int>.filled(7, 0);
      for (final entry in history) {
        try {
          final loggedAt = DateTime.parse(entry['logged_at'].toString());
          final dayIndex = loggedAt.difference(weekStart).inDays;
          if (dayIndex >= 0 && dayIndex < 7) {
            counts[dayIndex]++;
          }
        } catch (_) {}
      }
      _weekHistory = counts;
      notifyListeners();
    } catch (_) {}
  }

  Future<void> logPrayer(String prayerName) async {
    try {
      await ApiService.post(ApiConstants.prayerLog, data: {
        'prayer_name': prayerName,
        'logged_at': DateTime.now().toIso8601String(),
      });
      // Update today's count locally
      final todayIdx = DateTime.now().weekday - 1;
      if (todayIdx >= 0 && todayIdx < 7) {
        _weekHistory[todayIdx]++;
      }
      // Refresh to get updated logged_today list
      fetchPrayerTimes();
    } catch (_) {}
  }

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
    final timings = _prayerData!['timings'] as Map? ?? {};
    final next = nextPrayer;
    if (next == null) return null;
    final timeStr = timings[next]?.toString();
    if (timeStr == null) return null;
    try {
      final parts = timeStr.split(':');
      final prayerDt = DateTime(
        DateTime.now().year, DateTime.now().month, DateTime.now().day,
        int.parse(parts[0]), int.parse(parts[1]),
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

  String _formatTime(String raw) {
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