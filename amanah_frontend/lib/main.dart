// lib/main.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'core/services/api_service.dart';
import 'core/services/storage_service.dart';
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
import 'features/growth/screens/goals_screen.dart';
import 'features/scholar/screens/scholar_screen.dart';
import 'features/scholar/screens/ask_sheikh_screen.dart';
import 'features/scholar/screens/my_questions_screen.dart';
import 'features/community/screens/circles_screen.dart';
import 'features/community/screens/circle_detail_screen.dart';
import 'features/support/screens/help_support_screen.dart';
import 'features/support/screens/email_support_screen.dart';
import 'features/support/screens/user_guide_screen.dart';
import 'features/prayer/screens/prayer_screen.dart';
import 'features/prayer/screens/qibla_screen.dart';
import 'features/prayer/providers/prayer_provider.dart';
import 'features/quran/providers/quran_provider.dart';
import 'features/calendar/providers/calendar_provider.dart';
import 'features/dhikr/providers/dhikr_provider.dart';
import 'features/growth/providers/growth_provider.dart';
import 'features/scholar/providers/scholar_provider.dart';
import 'features/community/providers/community_provider.dart';
import 'shared/widgets/main_shell.dart';
import 'shared/widgets/connectivity_banner.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ApiService.init();
  runApp(const AmanahApp());
}

class AmanahApp extends StatelessWidget {
  const AmanahApp({super.key});

  static final GoRouter _router = GoRouter(
    initialLocation: '/',
    redirect: (context, state) async {
      // Only redirect from splash, login, register
      final isAuthRoute = ['/login', '/register', '/forgot-password', '/'].contains(state.matchedLocation);
      if (!isAuthRoute) return null;
      if (state.matchedLocation == '/') return null; // Let splash handle it
      final token = await StorageService.getAccessToken();
      if (token != null && isAuthRoute && state.matchedLocation != '/') return '/home';
      return null;
    },
    routes: [
      // ── No shell (full screen) ──
      GoRoute(path: '/',                     builder: (_, s) => const SplashScreen()),
      GoRoute(path: '/login',                builder: (_, s) => const LoginScreen()),
      GoRoute(path: '/register',             builder: (_, s) => const RegisterScreen()),
      GoRoute(path: '/forgot-password',      builder: (_, s) => const ForgotPasswordScreen()),

      // ── Shell routes (persistent bottom nav) ──
      ShellRoute(
        builder: (context, state, child) => ConnectivityBanner(child: MainShell(child: child)),
        routes: [
          GoRoute(path: '/home',             builder: (_, s) => const HomeScreen()),
          GoRoute(path: '/quran',            builder: (_, s) => const QuranScreen()),
          GoRoute(path: '/growth/mood',      builder: (_, s) => const MoodScreen()),
          GoRoute(path: '/dhikr',            builder: (_, s) => const DhikrScreen()),
          GoRoute(path: '/community',        builder: (_, s) => const CirclesScreen()),
          GoRoute(path: '/profile',          builder: (_, s) => const ProfileScreen()),
        ],
      ),

      // ── Sub-routes (no bottom nav — full screen push) ──
      GoRoute(path: '/profile/password',     builder: (_, s) => const ChangePasswordScreen()),
      GoRoute(path: '/profile/privacy',      builder: (_, s) => const PrivacySettingsScreen()),
      GoRoute(path: '/quran/bookmarks',      builder: (_, s) => const QuranBookmarksScreen()),
      GoRoute(
        path: '/quran/:id',
        builder: (_, s) => SurahScreen(surahId: int.tryParse(s.pathParameters['id'] ?? '1') ?? 1),
      ),
      GoRoute(path: '/calendar',             builder: (_, s) => const CalendarScreen()),
      GoRoute(path: '/prayer',               builder: (_, s) => const PrayerScreen()),
      GoRoute(path: '/prayer/qibla',         builder: (_, s) => const QiblaScreen()),
      GoRoute(path: '/privacy-policy',       builder: (_, s) => const PrivacyPolicyScreen()),
      GoRoute(path: '/terms-of-service',     builder: (_, s) => const TermsOfServiceScreen()),
      GoRoute(path: '/community-guidelines', builder: (_, s) => const CommunityGuidelinesScreen()),
      GoRoute(
        path: '/growth/mood/:type',
        builder: (_, s) => GratefulGuidanceScreen(mood: s.pathParameters['type'] ?? 'grateful'),
      ),
      GoRoute(path: '/growth/goals',         builder: (_, s) => const GoalsScreen()),
      GoRoute(path: '/progress',             builder: (_, s) => const ProgressScreen()),
      GoRoute(path: '/scholar',              builder: (_, s) => const ScholarScreen()),
      GoRoute(path: '/scholar/ask',          builder: (_, s) => const AskSheikhScreen()),
      GoRoute(path: '/scholar/my-questions', builder: (_, s) => const MyQuestionsScreen()),
      GoRoute(
        path: '/community/circle/:id',
        builder: (_, s) => CircleDetailScreen(circleId: s.pathParameters['id'] ?? '1'),
      ),
      GoRoute(path: '/support',              builder: (_, s) => const HelpSupportScreen()),
      GoRoute(path: '/support/email',        builder: (_, s) => const EmailSupportScreen()),
      GoRoute(path: '/support/user-guide',   builder: (_, s) => const UserGuideScreen()),
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
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF1B5E45),
            brightness: Brightness.light,
          ),
          useMaterial3: true,
          fontFamily: 'Roboto',
        ),
        routerConfig: _router,
      ),
    );
  }
}