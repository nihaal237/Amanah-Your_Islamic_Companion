// lib/features/calendar/providers/calendar_provider.dart

import 'package:flutter/foundation.dart';
import '../../../core/services/api_service.dart';
import '../../../core/constants/api_constants.dart';

class CalendarProvider extends ChangeNotifier {
  bool _isLoading = false;
  List<Map<String, dynamic>> _events = [];
  Map<String, dynamic>? _hijriData;

  bool get isLoading => _isLoading;
  List<Map<String, dynamic>> get events => _events;
  Map<String, dynamic>? get hijriData => _hijriData;

  Future<void> fetchEvents() async {
    _isLoading = true;
    notifyListeners();
    try {
      final eventsResp = await ApiService.get(ApiConstants.events);
      final hijriResp = await ApiService.get(ApiConstants.hijri);

      final data = eventsResp.data;
      if (data is List) {
        _events = data.cast<Map<String, dynamic>>();
      } else if (data is Map && data.containsKey('results')) {
        _events = (data['results'] as List).cast<Map<String, dynamic>>();
      }

      _hijriData = hijriResp.data as Map<String, dynamic>?;
    } catch (_) {
      _events = [];
    }
    _isLoading = false;
    notifyListeners();
  }
}