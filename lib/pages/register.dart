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
    final name = _name.text.trim();
    final email = _email.text.trim();
    final pass = _pass.text;

    if (name.isEmpty || email.isEmpty || pass.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Periksa input (min pass 6 karakter)')));
      return;
    }

    setState(() => _loading = true);
    try {
      final existing = await _db.getUserByEmail(email);
      if (existing != null) throw 'Email sudah terdaftar';
      final userId = await _db.insertUser(UserModel(name: name, email: email, password: pass));
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('currentUserId', userId);
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
      appBar: AppBar(title: const Text('Daftar')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(children: [
          TextField(controller: _name, decoration: const InputDecoration(labelText: 'Nama')),
          const SizedBox(height: 12),
          TextField(controller: _email, decoration: const InputDecoration(labelText: 'Email')),
          const SizedBox(height: 12),
          TextField(controller: _pass, obscureText: true, decoration: const InputDecoration(labelText: 'Kata Sandi')),
          const SizedBox(height: 18),
          _loading ? const CircularProgressIndicator() : ElevatedButton(onPressed: _register, child: const Text('Daftar')),
          const SizedBox(height: 12),
          TextButton(onPressed: () => Navigator.pushReplacementNamed(context, '/login'), child: const Text('Sudah punya akun? Masuk'))
        ]),
      ),
    );
  }
}
