import 'package:flutter/material.dart';
import 'app_theme.dart';
import 'pages/auth/login_page.dart';
import 'pages/auth/register_page.dart';
import 'pages/dashboard_page.dart';
import 'pages/tracker_page.dart';
import 'pages/nutrition_page.dart';
import 'pages/articles_page.dart';
import 'pages/profile_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const SiklusVitaApp());
}

class SiklusVitaApp extends StatelessWidget {
  const SiklusVitaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SiklusVita',
      theme: AppTheme.lightTheme,
      initialRoute: '/login',
      routes: {
        '/login': (_) => const LoginPage(),
        '/register': (_) => const RegisterPage(),
        '/dashboard': (_) => const DashboardPage(),
        '/tracker': (_) => const TrackerPage(),
        '/nutrition': (_) => const NutritionPage(),
        '/articles': (_) => const ArticlesPage(),
        '/profile': (_) => const ProfilePage(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
