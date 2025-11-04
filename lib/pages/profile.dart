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
  final _db = DBHelper();
  UserModel? _user;
  final _nameCtrl = TextEditingController();
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final id = prefs.getInt('currentUserId');
    if (id == null) { Navigator.pushReplacementNamed(context, '/login'); return; }
    final u = await _db.getUserById(id);
    setState(() { _user = u; _nameCtrl.text = u?.name ?? ''; _loading = false; });
  }

  Future<void> _save() async {
    // simple update: delete+recreate or implement update query — for simplicity show snackbar
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Fitur edit profil sederhana.')));
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
          ElevatedButton(onPressed: _save, child: const Text('Simpan')),
          const SizedBox(height: 12),
          OutlinedButton(onPressed: () async {
            final prefs = await SharedPreferences.getInstance();
            await prefs.remove('currentUserId');
            if (mounted) Navigator.pushReplacementNamed(context, '/login');
          }, child: const Text('Logout')),
        ]),
      ),
    );
  }
}
