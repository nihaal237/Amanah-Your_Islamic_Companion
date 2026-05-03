// lib/features/scholar/providers/scholar_provider.dart

import 'package:flutter/foundation.dart';
import '../../../core/services/api_service.dart';
import '../../../core/constants/api_constants.dart';

class ScholarProvider extends ChangeNotifier {
  bool _isLoading = false;
  List<Map<String, dynamic>> _scholars = [];
  List<Map<String, dynamic>> _archive = [];
  List<Map<String, dynamic>> _myQuestions = [];

  bool get isLoading => _isLoading;
  List<Map<String, dynamic>> get scholars => _scholars;
  List<Map<String, dynamic>> get archive => _archive;
  List<Map<String, dynamic>> get myQuestions => _myQuestions;

  Future<void> fetchScholars() async {
    try {
      final resp = await ApiService.get(ApiConstants.scholarQuestions);
      final data = resp.data;
      if (data is List) _scholars = data.cast<Map<String, dynamic>>();
      notifyListeners();
    } catch (_) {}
  }

  Future<void> fetchArchive() async {
    try {
      final resp = await ApiService.get(ApiConstants.archive);
      final data = resp.data;
      if (data is List) _archive = data.cast<Map<String, dynamic>>();
      else if (data is Map && data.containsKey('results')) _archive = (data['results'] as List).cast<Map<String, dynamic>>();
      notifyListeners();
    } catch (_) {}
  }

  Future<void> fetchMyQuestions() async {
    try {
      final resp = await ApiService.get(ApiConstants.myQuestions);
      final data = resp.data;
      if (data is List) _myQuestions = data.cast<Map<String, dynamic>>();
      notifyListeners();
    } catch (_) {}
  }

  Future<bool> askQuestion(String question) async {
    _isLoading = true;
    notifyListeners();
    try {
      await ApiService.post(ApiConstants.ask, data: {'question': question});
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (_) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
}