// lib/features/growth/providers/growth_provider.dart

import 'package:flutter/foundation.dart';
import '../../../core/services/api_service.dart';
import '../../../core/constants/api_constants.dart';

class GrowthProvider extends ChangeNotifier {
  bool _isLoading = false;
  int? _score;
  int? _streak;
  List<Map<String, dynamic>> _goals = [];
  List<Map<String, dynamic>> _completedGoals = [];
  List<Map<String, dynamic>> _moodHistory = [];

  bool get isLoading => _isLoading;
  int? get score => _score;
  int? get streak => _streak;
  List<Map<String, dynamic>> get goals => _goals;
  List<Map<String, dynamic>> get completedGoals => _completedGoals;
  List<Map<String, dynamic>> get moodHistory => _moodHistory;

  Future<void> fetchProgress() async {
    _isLoading = true;
    notifyListeners();
    try {
      final scoreResp = await ApiService.get(ApiConstants.score);
      _score = scoreResp.data['score'] ?? scoreResp.data['amanah_score'];
      _streak = scoreResp.data['streak'] ?? scoreResp.data['current_streak'];
    } catch (_) {}
    _isLoading = false;
    notifyListeners();
  }

  Future<void> fetchGoals() async {
    _isLoading = true;
    notifyListeners();
    try {
      final resp = await ApiService.get(ApiConstants.goals);
      final data = resp.data;
      final all = data is List
          ? data.cast<Map<String, dynamic>>()
          : (data is Map && data.containsKey('results'))
              ? (data['results'] as List).cast<Map<String, dynamic>>()
              : <Map<String, dynamic>>[];
      _goals = all.where((g) => g['is_active'] != false).toList();
      _completedGoals = all.where((g) => g['is_active'] == false || g['completed'] == true).toList();
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

  Future<void> fetchMoodHistory() async {
    try {
      final resp = await ApiService.get(ApiConstants.mood);
      final data = resp.data;
      if (data is List) {
        _moodHistory = data.cast<Map<String, dynamic>>();
      } else if (data is Map && data.containsKey('results')) {
        _moodHistory = (data['results'] as List).cast<Map<String, dynamic>>();
      }
      notifyListeners();
    } catch (_) {}
  }

  Future<void> createGoal(String title) async {
    try {
      final resp = await ApiService.post(ApiConstants.goals, data: {'title': title});
      _goals.add(resp.data as Map<String, dynamic>);
      notifyListeners();
    } catch (_) {}
  }

  Future<void> completeGoal(dynamic goalId) async {
    try {
      await ApiService.post('${ApiConstants.goals}$goalId/complete/');
      final idx = _goals.indexWhere((g) => g['id'].toString() == goalId.toString());
      if (idx != -1) {
        final goal = Map<String, dynamic>.from(_goals[idx]);
        goal['is_active'] = false;
        goal['completed'] = true;
        _goals.removeAt(idx);
        _completedGoals.insert(0, goal);
        notifyListeners();
      }
    } catch (_) {}
  }

  Future<void> deleteGoal(String goalId) async {
    try {
      await ApiService.delete('${ApiConstants.goals}$goalId/');
      _goals.removeWhere((g) => g['id'].toString() == goalId);
      notifyListeners();
    } catch (_) {}
  }
}