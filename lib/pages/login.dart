import 'package:flutter/material.dart';
import '../service/service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _email = TextEditingController();
  final _pass = TextEditingController();
  final AuthService _auth = AuthService();
  bool _loading = false;

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
            _loading ? const CircularProgressIndicator() : ElevatedButton(
              onPressed: () async {
                setState(() => _loading = true);
                try {
                  await _auth.signIn(_email.text.trim(), _pass.text.trim());
                  if (mounted) Navigator.pushReplacementNamed(context, '/dashboard');
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Login gagal: $e')));
                } finally {
                  if (mounted) setState(() => _loading = false);
                }
              },
              child: const Text('Masuk'),
            ),
            const SizedBox(height: 12),
            TextButton(onPressed: () => Navigator.pushNamed(context, '/forgot'), child: const Text('Lupa kata sandi?')),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              const Text('Belum punya akun?'),
              TextButton(onPressed: () => Navigator.pushNamed(context, '/register'), child: const Text('Daftar'))
            ])
          ]),
        ),
      ),
    );
  }
}
