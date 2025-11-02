import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../db/db_service.dart';
import '../model/cycle_model.dart';
import '../model/model_user.dart';

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
    _loadUserAndCycles();
  }

  Future<void> _loadUserAndCycles() async {
    final prefs = await SharedPreferences.getInstance();
    final int? id = prefs.getInt('currentUserId');
    if (id == null) {
      Navigator.pushReplacementNamed(context, '/login');
      return;
    }
    final u = await _db.getUserById(id);
    final cycles = await _db.fetchCycles(id);
    setState(() { _user = u; _cycles = cycles; _loading = false; });
  }

  String _nextInfo() {
    if (_cycles.isEmpty) return 'Belum ada data siklus. Tambahkan di Tracker.';
    final latest = _cycles.first;
    final daysSince = DateTime.now().difference(latest.startDate).inDays + 1;
    final percent = (daysSince / latest.length).clamp(0.0, 1.0);
    final remain = latest.length - daysSince;
    return 'Hari ke-$daysSince • $remain hari tersisa';
  }

  double _progress() {
    if (_cycles.isEmpty) return 0.0;
    final latest = _cycles.first;
    final daysSince = DateTime.now().difference(latest.startDate).inDays + 1;
    final percent = (daysSince / latest.length).clamp(0.0, 1.0);
    return percent;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard')),
      body: _loading ? const Center(child: CircularProgressIndicator()) : SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(children: [
          Align(alignment: Alignment.centerLeft, child: Text('Halo, ${_user?.name ?? 'Pengguna'}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
          const SizedBox(height: 12),
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(children: [
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const Text('Status Siklus', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text(_nextInfo()),
                ])),
                CircularPercentIndicator(radius: 60, lineWidth: 10, percent: _progress(), center: Text('${(_progress()*100).round()}%'), progressColor: Theme.of(context).primaryColor),
              ]),
            ),
          ),
          const SizedBox(height: 12),
          Row(children: [
            Expanded(child: ElevatedButton(onPressed: () => Navigator.pushNamed(context, '/tracker'), child: const Text('Tracker'))),
            const SizedBox(width: 8),
            Expanded(child: ElevatedButton(onPressed: () => Navigator.pushNamed(context, '/nutrition'), child: const Text('Nutrisi')))
          ]),
          const SizedBox(height: 12),
          Card(child: ListTile(title: const Text('Artikel Rekomendasi'), subtitle: const Text('Tips mengelola PMS & nutrisi'), trailing: IconButton(icon: const Icon(Icons.arrow_forward), onPressed: () => Navigator.pushNamed(context, '/articles')))),
          const SizedBox(height: 12),
          ElevatedButton.icon(onPressed: () async {
            final prefs = await SharedPreferences.getInstance();
            await prefs.remove('currentUserId');
            if (mounted) Navigator.pushReplacementNamed(context, '/login');
          }, icon: const Icon(Icons.logout), label: const Text('Logout'))
        ]),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        onTap: (i) {
          if (i == 1) Navigator.pushNamed(context, '/articles');
          if (i == 2) Navigator.pushNamed(context, '/profile');
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.article), label: 'Articles'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
