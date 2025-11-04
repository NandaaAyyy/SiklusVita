import 'package:flutter/material.dart';

class NutritionPage extends StatelessWidget {
  const NutritionPage({super.key});

  @override
  Widget build(BuildContext context) {
    final items = [
      {'name': 'Salmon', 'hint': 'Omega-3 membantu regulasi hormon'},
      {'name': 'Biji Labu', 'hint': 'Zinc & magnesium'},
      {'name': 'Sayuran Hijau', 'hint': 'Zat besi & vitamin'},
      {'name': 'Yogurt (Probiotik)', 'hint': 'Baik untuk keseimbangan hormon'}
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Pustaka Nutrisi')),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: ListView.builder(itemCount: items.length, itemBuilder: (_, i) {
          final it = items[i];
          return Card(
            child: ListTile(
              leading: CircleAvatar(child: Text(it['name']![0]), backgroundColor: Theme.of(context).colorScheme.secondary),
              title: Text(it['name']!),
              subtitle: Text(it['hint']!),
            ),
          );
        }),
      ),
    );
  }
}
