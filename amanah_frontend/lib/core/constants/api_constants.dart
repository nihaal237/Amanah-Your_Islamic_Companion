// lib/core/constants/api_constants.dart

import 'package:flutter/foundation.dart' show kIsWeb;

class ApiConstants {
  static String get baseUrl {
    if (kIsWeb) return 'http://127.0.0.1:8000/api';
    // For real device on same WiFi, change to your PC's local IP:
    // return 'http://192.168.X.X:8000/api';
    return 'http://10.0.2.2:8000/api'; // Android emulator default
  }

  // ── Auth ──────────────────────────────────────────────────────────────────
  static String get login =>            '$baseUrl/auth/login/';
  static String get register =>         '$baseUrl/auth/register/';
  static String get logout =>           '$baseUrl/auth/logout/';
  static String get profile =>          '$baseUrl/auth/profile/';
  static String get changePassword =>   '$baseUrl/auth/change-password/';
  static String get refreshToken =>     '$baseUrl/token/refresh/';

  // ── Prayer ────────────────────────────────────────────────────────────────
  static String get prayerTimes =>      '$baseUrl/prayer/times/';
  static String get qibla =>            '$baseUrl/prayer/qibla/';
  static String get prayerLog =>        '$baseUrl/prayer/log/';
  static String get prayerHistory =>    '$baseUrl/prayer/history/';

  // ── Quran ─────────────────────────────────────────────────────────────────
  static String get surahs =>           '$baseUrl/quran/surahs/';
  static String get surah =>            '$baseUrl/quran/surah/';
  static String get quranSearch =>      '$baseUrl/quran/search/';
  static String get bookmark =>         '$baseUrl/quran/bookmark/';
  static String get bookmarks =>        '$baseUrl/quran/bookmarks/';

  // ── Community ─────────────────────────────────────────────────────────────
  static String get circles =>          '$baseUrl/community/circles/';
  static String get posts =>            '$baseUrl/community/posts/';

  // ── Scholar ───────────────────────────────────────────────────────────────
  static String get ask =>              '$baseUrl/scholar/ask/';
  static String get scholarQuestions => '$baseUrl/scholar/questions/';
  static String get myQuestions =>      '$baseUrl/scholar/my-questions/';
  static String get archive =>          '$baseUrl/scholar/archive/';

  // ── Growth ────────────────────────────────────────────────────────────────
  static String get mood =>             '$baseUrl/growth/mood/';
  static String get goals =>            '$baseUrl/growth/goals/';
  static String get score =>            '$baseUrl/growth/score/';

  // ── Calendar ──────────────────────────────────────────────────────────────
  static String get hijri =>            '$baseUrl/calendar/hijri/';
  static String get events =>           '$baseUrl/calendar/events/';

  // ── Sync ──────────────────────────────────────────────────────────────────
  static String get batchSync =>        '$baseUrl/sync/batch/';
}