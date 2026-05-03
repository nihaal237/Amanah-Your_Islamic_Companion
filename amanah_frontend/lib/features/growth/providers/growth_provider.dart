// lib/features/growth/providers/growth_provider.dart

import 'package:flutter/foundation.dart';
import '../../../core/services/api_service.dart';
import '../../../core/constants/api_constants.dart';

class GrowthProvider extends ChangeNotifier {
  bool _isLoading = false;
  int? _score;
  int? _streak;
  List<Map<String, dynamic>> _goals = [];
  List<Map<String, dynamic>> _moodHistory = [];

  bool get isLoading => _isLoading;
  int? get score => _score;
  int? get streak => _streak;
  List<Map<String, dynamic>> get goals => _goals;
  List<Map<String, dynamic>> get moodHistory => _moodHistory;

  Future<void> fetchProgress() async {
    _isLoading = true;
    notifyListeners();
    try {
      final scoreResp = await ApiService.get(ApiConstants.score);
      final goalsResp = await ApiService.get(ApiConstants.goals);
      _score = scoreResp.data['score'] ?? scoreResp.data['amanah_score'];
      _streak = scoreResp.data['streak'] ?? scoreResp.data['current_streak'];
      final gData = goalsResp.data;
      if (gData is List) _goals = gData.cast<Map<String, dynamic>>();
      else if (gData is Map && gData.containsKey('results')) _goals = (gData['results'] as List).cast<Map<String, dynamic>>();
    } catch (_) {}
    _isLoading = false;
    notifyListeners();
  }

  Future<void> logMood(String emotion, {String? note}) async {
    try {
      await ApiService.post(ApiConstants.mood, data: {
        'emotion': emotion,
        if (note != null) 'note': note,
        'logged_at': DateTime.now().toIso8601String(),
      });
    } catch (_) {}
  }

  Future<void> createGoal(String title) async {
    try {
      final resp = await ApiService.post(ApiConstants.goals, data: {'title': title});
      _goals.add(resp.data as Map<String, dynamic>);
      notifyListeners();
    } catch (_) {}
  }

  Future<void> completeGoal(int goalId) async {
    try {
      await ApiService.post('${ApiConstants.goals}$goalId/complete/');
      await fetchProgress();
    } catch (_) {}
  }
}