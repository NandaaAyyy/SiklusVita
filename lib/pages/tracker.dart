// lib/pages/tracker_page.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../db/db_service.dart';
import '../model/cycle_model.dart';

class TrackerPage extends StatefulWidget {
  const TrackerPage({super.key});
  @override
  State<TrackerPage> createState() => _TrackerPageState();
}

class _TrackerPageState extends State<TrackerPage> {
  DateTime _start = DateTime.now();
  final TextEditingController _lengthCtrl = TextEditingController(text: '28');
  bool _isPCOS = false;
  final DBHelper _db = DBHelper();
  bool _saving = false;

  @override
  void dispose() {
    _lengthCtrl.dispose();
    super.dispose();
  }

  Future<void> _saveCycle() async {
    setState(() => _saving = true);
    try {
      final prefs = await SharedPreferences.getInstance();
      final int? userId = prefs.getInt('currentUserId');
      if (userId == null) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Silakan login terlebih dahulu')));
        return;
      }
      final length = int.tryParse(_lengthCtrl.text.trim()) ?? 28;
      final cycle = CycleModel(startDate: _start, length: length, isPCOS: _isPCOS);
      await _db.insertCycle(userId, cycle);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Siklus tersimpan')));
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Gagal: $e')));
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tracker Siklus')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(children: [
          ListTile(
            title: const Text('Tanggal Mulai Siklus'),
            subtitle: Text('${_start.toLocal().toIso8601String().split('T').first}'),
            trailing: IconButton(icon: const Icon(Icons.calendar_today), onPressed: () async {
              final dt = await showDatePicker(context: context, initialDate: _start, firstDate: DateTime(2010), lastDate: DateTime(2100));
              if (dt != null) setState(() => _start = dt);
            }),
          ),
          const SizedBox(height: 12),
          TextField(controller: _lengthCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Panjang Siklus (hari)')),
          SwitchListTile(title: const Text('PCOS Mode'), value: _isPCOS, onChanged: (v) => setState(() => _isPCOS = v)),
          const SizedBox(height: 12),
          _saving ? const CircularProgressIndicator() : SizedBox(width: double.infinity, child: ElevatedButton(onPressed: _saveCycle, child: const Text('Simpan Siklus'))),
        ]),
      ),
    );
  }
}
