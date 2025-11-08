// lib/pages/articles_page.dart
import 'package:flutter/material.dart';
import '../db/db_service.dart';

class ArticlesPage extends StatefulWidget {
  const ArticlesPage({super.key});
  @override
  State<ArticlesPage> createState() => _ArticlesPageState();
}

class _ArticlesPageState extends State<ArticlesPage> {
  final DBHelper _db = DBHelper();
  List<Map<String, dynamic>> _articles = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final arts = await _db.fetchArticles();
    setState(() { _articles = arts; _loading = false; });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Artikel')),
      body: _loading ? const Center(child: CircularProgressIndicator()) : ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: _articles.length,
        itemBuilder: (_, i) {
          final a = _articles[i];
          return Card(
            child: ListTile(
              title: Text(a['title'] ?? ''),
              subtitle: Text(a['summary'] ?? ''),
              onTap: () => showDialog(context: context, builder: (_) => AlertDialog(
                title: Text(a['title'] ?? ''),
                content: SingleChildScrollView(child: Text(a['content'] ?? '')),
                actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Tutup'))],
              )),
            ),
          );
        },
      ),
    );
  }
}
