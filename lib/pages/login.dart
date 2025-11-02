import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../db/db_service.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _email = TextEditingController();
  final _pass = TextEditingController();
  final _db = DBHelper();
  bool _loading = false;

  Future<void> _login() async {
    final email = _email.text.trim();
    final pass = _pass.text;
    if (email.isEmpty || pass.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Isi email & password')));
      return;
    }
    setState(() => _loading = true);
    try {
      final user = await _db.getUserByEmail(email);
      if (user == null || user.password != pass) throw 'Email atau password salah';
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('currentUserId', user.id!);
      Navigator.pushReplacementNamed(context, '/dashboard');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Login gagal: $e')));
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  void initState() {
    super.initState();
    _checkAutoLogin();
  }

  Future<void> _checkAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    final id = prefs.getInt('currentUserId');
    if (id != null) {
      // user already logged in
      if (mounted) Navigator.pushReplacementNamed(context, '/dashboard');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            const Text('SiklusVita', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            TextField(controller: _email, decoration: const InputDecoration(labelText: 'Email')),
            const SizedBox(height: 12),
            TextField(controller: _pass, decoration: const InputDecoration(labelText: 'Kata Sandi'), obscureText: true),
            const SizedBox(height: 18),
            _loading ? const CircularProgressIndicator() : ElevatedButton(onPressed: _login, child: const Text('Masuk')),
            const SizedBox(height: 12),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              const Text('Belum punya akun?'),
              TextButton(onPressed: () => Navigator.pushReplacementNamed(context, '/register'), child: const Text('Daftar'))
            ])
          ]),
        ),
      ),
    );
  }
}
