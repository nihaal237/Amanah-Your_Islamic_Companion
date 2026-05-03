class ApiConstants {
  // Change this to your machine's IP when testing on a physical device
  // Use 10.0.2.2 for Android emulator, 127.0.0.1 for iOS simulator
  static const String baseUrl = 'http://127.0.0.1:8000/api';

  // Auth
  static const String login = '$baseUrl/auth/login/';
  static const String register = '$baseUrl/auth/register/';
  static const String logout = '$baseUrl/auth/logout/';
  static const String profile = '$baseUrl/auth/profile/';
  static const String changePassword = '$baseUrl/auth/change-password/';
  static const String refreshToken = '$baseUrl/token/refresh/';

  // Prayer
  static const String prayerTimes = '$baseUrl/prayer/times/';
  static const String qibla = '$baseUrl/prayer/qibla/';
  static const String prayerLog = '$baseUrl/prayer/log/';
  static const String prayerHistory = '$baseUrl/prayer/history/';

  // Quran
  static const String surahs = '$baseUrl/quran/surahs/';
  static const String surah = '$baseUrl/quran/surah/'; // + {n}/
  static const String quranSearch = '$baseUrl/quran/search/';
  static const String bookmark = '$baseUrl/quran/bookmark/';
  static const String bookmarks = '$baseUrl/quran/bookmarks/';

  // Community
  static const String circles = '$baseUrl/community/circles/';
  static const String posts = '$baseUrl/community/circles/'; // + {id}/posts/

  // Scholar
  static const String ask = '$baseUrl/scholar/ask/';
  static const String scholarQuestions = '$baseUrl/scholar/questions/';
  static const String myQuestions = '$baseUrl/scholar/my-questions/';
  static const String archive = '$baseUrl/scholar/archive/';

  // Growth
  static const String mood = '$baseUrl/growth/mood/';
  static const String goals = '$baseUrl/growth/goals/';
  static const String score = '$baseUrl/growth/score/';

  // Calendar
  static const String hijri = '$baseUrl/calendar/hijri/';
  static const String events = '$baseUrl/calendar/events/';

  // Sync
  static const String batchSync = '$baseUrl/sync/batch/';
}