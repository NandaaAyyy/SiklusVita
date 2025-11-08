// lib/pages/dashboard_page.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../db/db_service.dart';
import '../model/model_user.dart';
import '../model/cycle_model.dart';
import '../model/cycle_ring.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});
  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final DBHelper _db = DBHelper();
  UserModel? _user;
  List<CycleModel> _cycles = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final id = prefs.getInt('currentUserId');
    if (id == null) {
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, '/login');
      return;
    }
    final u = await _db.getUserByEmail((await _db.getUserByEmail(''))?.email ?? ''); // harmless fallback
    // Better: fetch by id; DBHelper didn't implement getUserById — use getUserByEmail via prefs fallback not ideal.
    // We'll fetch cycles anyway:
    final cycles = await _db.fetchCycles(id);
    setState(() {
      _cycles = cycles;
      _loading = false;
    });

    // load user directly:
    final dbUser = await _db.database;
    final userRes = await dbUser.query('users', where: 'id=?', whereArgs: [id]);
    if (userRes.isNotEmpty) {
      setState(() {
        _user = UserModel.fromMap(userRes.first);
      });
    }
  }

  double _progressPercent() {
    if (_cycles.isEmpty) return 0.0;
    final latest = _cycles.first;
    final days = DateTime.now().difference(latest.startDate).inDays + 1;
    return (days / latest.length).clamp(0.0, 1.0);
  }

  String _statusText() {
    if (_cycles.isEmpty) return 'Belum ada data siklus. Tambah di Tracker.';
    final latest = _cycles.first;
    final days = DateTime.now().difference(latest.startDate).inDays + 1;
    final remain = latest.length - days;
    return 'Hari ke-$days • $remain hari tersisa';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [IconButton(onPressed: () => Navigator.pushNamed(context, '/profile'), icon: const Icon(Icons.person))],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('Halo, ${_user?.name ?? 'Pengguna'}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        const Text('Status Siklus', style: TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        Text(_statusText()),
                      ])),
                      CycleRing(percent: _progressPercent(), label: '${(_progressPercent() * 100).round()}%'),
                    ]),
                  ),
                ),
                const SizedBox(height: 12),
                Row(children: [
                  Expanded(child: ElevatedButton(onPressed: () => Navigator.pushNamed(context, '/tracker'), child: const Text('Tracker'))),
                  const SizedBox(width: 8),
                  Expanded(child: ElevatedButton(onPressed: () => Navigator.pushNamed(context, '/nutrition'), child: const Text('Nutrisi'))),
                ]),
                const SizedBox(height: 12),
                Card(child: ListTile(title: const Text('Artikel Rekomendasi'), subtitle: const Text('Tips mengelola PMS & nutrisi'), trailing: IconButton(icon: const Icon(Icons.arrow_forward), onPressed: () => Navigator.pushNamed(context, '/articles')))),
              ]),
            ),
    );
  }
}
