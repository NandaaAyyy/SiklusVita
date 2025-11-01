import 'package:flutter/material.dart';
import 'page/dashboard.dart';
import 'page/nutrition.dart';
import 'page/notes.dart';
import 'page/login.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SiklusVita',
      theme: ThemeData(
        fontFamily: 'Poppins',
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFEFB1C7),
        ),
      ),
      home: const SiklusVitaHome(),
    );
  }
}

class SiklusVitaHome extends StatefulWidget {
  const SiklusVitaHome({super.key});

  @override
  State<SiklusVitaHome> createState() => _SiklusVitaHomeState();
}

class _SiklusVitaHomeState extends State<SiklusVitaHome> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    DashboardPage(),
    NutritionPage(),
    NotesPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF5F8),
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        selectedItemColor: const Color(0xFFD63384),
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Siklus'),
          BottomNavigationBarItem(icon: Icon(Icons.restaurant), label: 'Nutrisi'),
          BottomNavigationBarItem(icon: Icon(Icons.edit), label: 'Catatan'),
        ],
      ),
    );
  }
}
