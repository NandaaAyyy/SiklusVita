// lib/pages/nutrition_page.dart
import 'package:flutter/material.dart';

class NutritionPage extends StatefulWidget {
  const NutritionPage({super.key});
  @override
  State<NutritionPage> createState() => _NutritionPageState();
}

class _NutritionPageState extends State<NutritionPage> {
  bool _pcosMode = false;

  final List<Map<String, String>> common = [
    {'name': 'Salmon', 'benefit': 'Omega-3 membantu regulasi hormon'},
    {'name': 'Biji Labu', 'benefit': 'Sumber zinc & magnesium'},
    {'name': 'Sayuran Hijau', 'benefit': 'Zat besi & vitamin'},
    {'name': 'Yogurt (Probiotik)', 'benefit': 'Mendukung kesehatan pencernaan'}
  ];

  final List<Map<String, String>> pcos = [
    {'name': 'Oat', 'benefit': 'Serat & stabil gula darah'},
    {'name': 'Kacang-kacangan', 'benefit': 'Protein & indeks glikemik rendah'}
  ];

  @override
  Widget build(BuildContext context) {
    final list = _pcosMode ? [...pcos, ...common] : common;

    return Scaffold(
      appBar: AppBar(title: const Text('Pustaka Nutrisi')),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(children: [
          SwitchListTile(title: const Text('PCOS Mode'), value: _pcosMode, onChanged: (v) => setState(() => _pcosMode = v)),
          const SizedBox(height: 8),
          Expanded(
            child: ListView.builder(
              itemCount: list.length,
              itemBuilder: (_, i) {
                final it = list[i];
                return Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: ListTile(
                    leading: CircleAvatar(child: Text(it['name']!.substring(0,1)), backgroundColor: Theme.of(context).colorScheme.secondary),
                    title: Text(it['name']!),
                    subtitle: Text(it['benefit']!),
                    onTap: () => showModalBottomSheet(context: context, builder: (_) => Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text(it['name']!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        const SizedBox(height: 8),
                        Text(it['benefit']!),
                        const SizedBox(height: 12),
                        ElevatedButton(onPressed: () => Navigator.pop(context), child: const Text('Tutup'))
                      ]),
                    )),
                  ),
                );
              },
            ),
          )
        ]),
      ),
    );
  }
}
