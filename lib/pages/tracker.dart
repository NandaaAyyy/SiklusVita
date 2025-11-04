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
  final _lengthCtrl = TextEditingController(text: '28');
  bool _pcos = false;
  final _db = DBHelper();
  bool _saving = false;

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    final int? userId = prefs.getInt('currentUserId');
    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Silakan login terlebih dahulu')));
      return;
    }
    setState(() => _saving = true);
    try {
      final cycle = CycleModel(startDate: _start, length: int.tryParse(_lengthCtrl.text) ?? 28, isPCOS: _pcos);
      await _db.insertCycle(cycle, userId);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Siklus tersimpan')));
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Gagal: $e')));
    } finally {
      setState(() => _saving = false);
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
            title: const Text('Tanggal Mulai'),
            subtitle: Text('${_start.toLocal().toIso8601String().split('T').first}'),
            trailing: IconButton(icon: const Icon(Icons.calendar_today), onPressed: () async {
              final dt = await showDatePicker(context: context, initialDate: _start, firstDate: DateTime(2015), lastDate: DateTime(2100));
              if (dt != null) setState(() => _start = dt);
            }),
          ),
          const SizedBox(height: 8),
          TextField(controller: _lengthCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Panjang Siklus (hari)')),
          SwitchListTile(title: const Text('PCOS Mode'), value: _pcos, onChanged: (v) => setState(() => _pcos = v)),
          const SizedBox(height: 12),
          _saving ? const CircularProgressIndicator() : ElevatedButton(onPressed: _save, child: const Text('Simpan')),
        ]),
      ),
    );
  }
}
