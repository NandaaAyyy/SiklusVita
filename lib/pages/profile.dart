// lib/pages/profile_page.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../db/db_service.dart';
import '../model/model_user.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final DBHelper _db = DBHelper();
  UserModel? _user;
  bool _loading = true;
  final TextEditingController _nameCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    final id = prefs.getInt('currentUserId');
    if (id == null) {
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, '/login');
      return;
    }
    final db = await _db.database;
    final res = await db.query('users', where: 'id=?', whereArgs: [id]);
    if (res.isNotEmpty) {
      _user = UserModel.fromMap(res.first);
      _nameCtrl.text = _user!.name;
    }
    if (mounted) setState(() => _loading = false);
  }

  Future<void> _saveName() async {
    // simple update via raw SQL for brevity
    if (_user == null) return;
    final db = await _db.database;
    await db.update('users', {'name': _nameCtrl.text.trim()}, where: 'id=?', whereArgs: [_user!.id]);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Profil disimpan')));
    await _loadUser();
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('currentUserId');
    if (!mounted) return;
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profil')),
      body: _loading ? const Center(child: CircularProgressIndicator()) : Padding(
        padding: const EdgeInsets.all(16),
        child: Column(children: [
          CircleAvatar(radius: 44, child: Text(_user?.name.substring(0,1).toUpperCase() ?? '?', style: const TextStyle(fontSize: 28))),
          const SizedBox(height: 12),
          Text(_user?.email ?? '-', style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          TextField(controller: _nameCtrl, decoration: const InputDecoration(labelText: 'Nama')),
          const SizedBox(height: 12),
          ElevatedButton(onPressed: _saveName, child: const Text('Simpan')),
          const SizedBox(height: 12),
          OutlinedButton(onPressed: _logout, child: const Text('Logout')),
        ]),
      ),
    );
  }
}
