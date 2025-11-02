import 'package:flutter/material.dart';
import 'theme.dart';
import 'pages/login.dart';
import 'pages/register.dart';




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
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
