// lib/pages/auth/login_page.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../db/db_service.dart';
import '../../model/model_user.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with SingleTickerProviderStateMixin {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _pass = TextEditingController();
  final DBHelper _db = DBHelper();
  bool _loading = false;
  late AnimationController _anim;

  @override
  void initState() {
    super.initState();
    _anim = AnimationController(vsync: this, duration: const Duration(seconds: 2))..repeat(reverse: true);
    _checkAutoLogin();
  }

  @override
  void dispose() {
    _anim.dispose();
    _email.dispose();
    _pass.dispose();
    super.dispose();
  }

  Future<void> _checkAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    final int? id = prefs.getInt('currentUserId');
    if (id != null) {
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, '/dashboard');
    }
  }

  Future<void> _login() async {
    setState(() => _loading = true);
    try {
      final user = await _db.login(_email.text.trim(), _pass.text);
      await Future.delayed(const Duration(milliseconds: 400));
      if (user == null) {
        if (!mounted) return;
        showDialog(context: context, builder: (_) => AlertDialog(
          title: const Text('Login Gagal'),
          content: const Text('Email atau password salah.'),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Tutup'))
          ],
        ));
      } else {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setInt('currentUserId', user.id!);
        if (!mounted) return;
        Navigator.pushReplacementNamed(context, '/dashboard');
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Terjadi error: $e')));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    const gradient = LinearGradient(
      colors: [Color(0xFFFCE4EC), Color(0xFFFFF1F7)],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    );

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: gradient),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(28),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ScaleTransition(
                  scale: Tween(begin: 0.92, end: 1.05).animate(CurvedAnimation(parent: _anim, curve: Curves.easeInOut)),
                  child: Icon(Icons.favorite_rounded, size: 96, color: Theme.of(context).primaryColor),
                ),
                const SizedBox(height: 12),
                Text('SiklusVita', style: TextStyle(fontSize: 36, color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                const Text('Pantau siklus & kesehatanmu dengan nyaman', textAlign: TextAlign.center, style: TextStyle(color: Colors.black54)),
                const SizedBox(height: 24),
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18), boxShadow: [BoxShadow(color: Colors.pink.withOpacity(0.12), blurRadius: 12, offset: Offset(0,4))]),
                  child: Column(
                    children: [
                      TextField(controller: _email, decoration: const InputDecoration(prefixIcon: Icon(Icons.email_outlined, color: Colors.pink), labelText: 'Email')),
                      const SizedBox(height: 12),
                      TextField(controller: _pass, obscureText: true, decoration: const InputDecoration(prefixIcon: Icon(Icons.lock_outline, color: Colors.pink), labelText: 'Password')),
                      const SizedBox(height: 18),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _loading ? null : _login,
                          child: _loading ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)) : const Text('Masuk'),
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextButton(onPressed: () => Navigator.pushNamed(context, '/register'), child: const Text('Belum punya akun? Daftar', style: TextStyle(color: Colors.pink))),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
