// lib/features/quran/providers/quran_provider.dart

import 'package:flutter/foundation.dart';
import '../../../core/services/api_service.dart';
import '../../../core/constants/api_constants.dart';

class QuranProvider extends ChangeNotifier {
  bool _isLoading = false;
  List<Map<String, dynamic>> _surahs = [];
  List<Map<String, dynamic>> _bookmarks = [];
  Map<String, dynamic>? _lastRead;

  bool get isLoading => _isLoading;
  List<Map<String, dynamic>> get surahs => _surahs;
  List<Map<String, dynamic>> get bookmarks => _bookmarks;
  Map<String, dynamic>? get lastRead => _lastRead;

  // ── Fetch all surahs ────────────────────────────────────────────────────
  Future<void> fetchSurahs() async {
    if (_surahs.isNotEmpty) return; // Already loaded
    _isLoading = true;
    notifyListeners();
    try {
      final response = await ApiService.get(ApiConstants.surahs);
      final data = response.data;
      if (data is List) {
        _surahs = data.cast<Map<String, dynamic>>();
      } else if (data is Map && data.containsKey('results')) {
        _surahs = (data['results'] as List).cast<Map<String, dynamic>>();
      }
    } catch (_) {}
    _isLoading = false;
    notifyListeners();
  }

  // ── Fetch bookmarks ─────────────────────────────────────────────────────
  Future<void> fetchBookmarks() async {
    try {
      final response = await ApiService.get(ApiConstants.bookmarks);
      final data = response.data;
      if (data is List) {
        _bookmarks = data.cast<Map<String, dynamic>>();
      } else if (data is Map && data.containsKey('results')) {
        _bookmarks = (data['results'] as List).cast<Map<String, dynamic>>();
      }
      notifyListeners();
    } catch (_) {}
  }

  // ── Add bookmark ────────────────────────────────────────────────────────
  Future<void> addBookmark({
    required int surahNumber,
    required int ayahNumber,
    String? surahName,
  }) async {
    try {
      final response = await ApiService.post(ApiConstants.bookmark, data: {
        'surah_number': surahNumber,
        'ayah_number': ayahNumber,
      });
      _bookmarks.add(response.data as Map<String, dynamic>);
      notifyListeners();
    } catch (_) {}
  }

  // ── Delete bookmark ─────────────────────────────────────────────────────
  Future<void> deleteBookmark(String bookmarkId) async {
    try {
      await ApiService.delete('${ApiConstants.bookmark}$bookmarkId/');
      _bookmarks.removeWhere((b) => b['id'].toString() == bookmarkId);
      notifyListeners();
    } catch (_) {}
  }

  // ── Update last read (called by SurahScreen) ────────────────────────────
  void updateLastRead(Map<String, dynamic> data) {
    _lastRead = data;
    notifyListeners();
  }

  // ── Check if ayah is bookmarked ─────────────────────────────────────────
  bool isBookmarked(int surahNumber, int ayahNumber) {
    return _bookmarks.any(
      (b) => b['surah_number'] == surahNumber && b['ayah_number'] == ayahNumber,
    );
  }

  String? bookmarkIdFor(int surahNumber, int ayahNumber) {
    try {
      final bm = _bookmarks.firstWhere(
        (b) => b['surah_number'] == surahNumber && b['ayah_number'] == ayahNumber,
      );
      return bm['id']?.toString();
    } catch (_) {
      return null;
    }
  }
}