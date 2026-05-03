// lib/main.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'core/services/api_service.dart';
import 'features/auth/providers/auth_provider.dart';
import 'features/auth/screens/login_screen.dart';
import 'features/auth/screens/register_screen.dart';
import 'features/auth/screens/forgot_password_screen.dart';
import 'features/auth/screens/profile_screen.dart';
import 'features/auth/screens/change_password_screen.dart';
import 'features/auth/screens/privacy_settings_screen.dart';
import 'features/splash/screens/splash_screen.dart';
import 'features/home/screens/home_screen.dart';
import 'features/quran/screens/quran_screen.dart';
import 'features/quran/screens/surah_screen.dart';
import 'features/quran/screens/quran_bookmarks_screen.dart';
import 'features/calendar/screens/calendar_screen.dart';
import 'features/dhikr/screens/dhikr_screen.dart';
import 'features/legal/screens/legal_screens.dart';
import 'features/growth/screens/mood_screen.dart';
import 'features/growth/screens/grateful_guidance_screen.dart';
import 'features/growth/screens/progress_screen.dart';
import 'features/scholar/screens/scholar_screen.dart';
import 'features/scholar/screens/ask_sheikh_screen.dart';
import 'features/community/screens/circles_screen.dart';
import 'features/community/screens/circle_detail_screen.dart';
import 'features/support/screens/help_support_screen.dart';
import 'features/support/screens/email_support_screen.dart';
import 'features/support/screens/user_guide_screen.dart';
import 'features/prayer/providers/prayer_provider.dart';
import 'features/quran/providers/quran_provider.dart';
import 'features/calendar/providers/calendar_provider.dart';
import 'features/dhikr/providers/dhikr_provider.dart';
import 'features/growth/providers/growth_provider.dart';
import 'features/scholar/providers/scholar_provider.dart';
import 'features/community/providers/community_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ApiService.init();
  runApp(const AmanahApp());
}

class AmanahApp extends StatelessWidget {
  const AmanahApp({super.key});

  static final GoRouter _router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(path: '/',                        builder: (_, s) => const SplashScreen()),
      GoRoute(path: '/login',                   builder: (_, s) => const LoginScreen()),
      GoRoute(path: '/register',                builder: (_, s) => const RegisterScreen()),
      GoRoute(path: '/forgot-password',         builder: (_, s) => const ForgotPasswordScreen()),
      GoRoute(path: '/home',                    builder: (_, s) => const HomeScreen()),
      GoRoute(path: '/profile',                 builder: (_, s) => const ProfileScreen()),
      GoRoute(path: '/profile/password',        builder: (_, s) => const ChangePasswordScreen()),
      GoRoute(path: '/profile/privacy',         builder: (_, s) => const PrivacySettingsScreen()),
      GoRoute(path: '/quran',                   builder: (_, s) => const QuranScreen()),
      GoRoute(path: '/quran/bookmarks',         builder: (_, s) => const QuranBookmarksScreen()),
      GoRoute(
        path: '/quran/:id',
        builder: (_, s) => SurahScreen(surahId: int.tryParse(s.pathParameters['id'] ?? '1') ?? 1),
      ),
      GoRoute(path: '/calendar',                builder: (_, s) => const CalendarScreen()),
      GoRoute(path: '/dhikr',                   builder: (_, s) => const DhikrScreen()),
      GoRoute(path: '/privacy-policy',          builder: (_, s) => const PrivacyPolicyScreen()),
      GoRoute(path: '/terms-of-service',        builder: (_, s) => const TermsOfServiceScreen()),
      GoRoute(path: '/community-guidelines',    builder: (_, s) => const CommunityGuidelinesScreen()),
      GoRoute(path: '/growth/mood',             builder: (_, s) => const MoodScreen()),
      GoRoute(
        path: '/growth/mood/:type',
        builder: (_, s) => GratefulGuidanceScreen(mood: s.pathParameters['type'] ?? 'grateful'),
      ),
      GoRoute(path: '/progress',                builder: (_, s) => const ProgressScreen()),
      GoRoute(path: '/scholar',                 builder: (_, s) => const ScholarScreen()),
      GoRoute(path: '/scholar/ask',             builder: (_, s) => const AskSheikhScreen()),
      GoRoute(path: '/community',               builder: (_, s) => const CirclesScreen()),
      GoRoute(
        path: '/community/circle/:id',
        builder: (_, s) => CircleDetailScreen(circleId: s.pathParameters['id'] ?? '1'),
      ),
      GoRoute(path: '/support',                 builder: (_, s) => const HelpSupportScreen()),
      GoRoute(path: '/support/email',           builder: (_, s) => const EmailSupportScreen()),
      GoRoute(path: '/support/user-guide',      builder: (_, s) => const UserGuideScreen()),
      GoRoute(path: '/prayer',                  builder: (_, s) => const _PlaceholderScreen(title: 'Prayer Times')),
      GoRoute(path: '/growth/goals',            builder: (_, s) => const _PlaceholderScreen(title: 'Goals')),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => PrayerProvider()),
        ChangeNotifierProvider(create: (_) => QuranProvider()),
        ChangeNotifierProvider(create: (_) => CalendarProvider()),
        ChangeNotifierProvider(create: (_) => DhikrProvider()),
        ChangeNotifierProvider(create: (_) => GrowthProvider()),
        ChangeNotifierProvider(create: (_) => ScholarProvider()),
        ChangeNotifierProvider(create: (_) => CommunityProvider()),
      ],
      child: MaterialApp.router(
        title: 'Amanah',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1B5E45), brightness: Brightness.light),
          useMaterial3: true,
        ),
        routerConfig: _router,
      ),
    );
  }
}

class _PlaceholderScreen extends StatelessWidget {
  final String title;
  const _PlaceholderScreen({required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEFF4F1),
      appBar: AppBar(
        backgroundColor: const Color(0xFFEFF4F1),
        elevation: 0,
        leading: GestureDetector(
          onTap: () => context.pop(),
          child: const Icon(Icons.arrow_back_rounded, color: Color(0xFF1A2E25)),
        ),
        title: Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF1A2E25))),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.construction_rounded, size: 48, color: Color(0xFF1B5E45)),
            const SizedBox(height: 16),
            Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Color(0xFF1B5E45))),
            const SizedBox(height: 8),
            const Text('Coming soon', style: TextStyle(color: Color(0xFF6B8C7A))),
          ],
        ),
      ),
    );
  }
}