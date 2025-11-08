import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../db/db_service.dart';
import '../model/model_user.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});
  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _pass = TextEditingController();
  final _db = DBHelper();
  bool _loading = false;

  Future<void> _register() async {
    if (_name.text.isEmpty || _email.text.isEmpty || _pass.text.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Periksa input! Password min 6 karakter'),
      ));
      return;
    }

    setState(() => _loading = true);

    try {
      final existing = await _db.getUserByEmail(_email.text.trim());
      if (existing != null) {
        throw 'Email sudah terdaftar';
      }

      final userId = await _db.insertUser(
        UserModel(
          name: _name.text.trim(),
          email: _email.text.trim(),
          password: _pass.text.trim(),
        ),
      );

      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('currentUserId', userId);

      if (!mounted) return;
      Navigator.pushReplacementNamed(context, '/dashboard');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Gagal daftar: $e')));
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Daftar Akun')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(controller: _name, decoration: const InputDecoration(labelText: 'Nama')),
            const SizedBox(height: 12),
            TextField(controller: _email, decoration: const InputDecoration(labelText: 'Email')),
            const SizedBox(height: 12),
            TextField(controller: _pass, obscureText: true, decoration: const InputDecoration(labelText: 'Password')),
            const SizedBox(height: 18),
            _loading
                ? const CircularProgressIndicator()
                : ElevatedButton(onPressed: _register, child: const Text('Daftar')),
            TextButton(
              onPressed: () => Navigator.pushReplacementNamed(context, '/login'),
              child: const Text('Sudah punya akun? Masuk'),
            ),
          ],
        ),
      ),
    );
  }
}
