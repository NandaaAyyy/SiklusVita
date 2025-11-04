import 'package:flutter/material.dart';
import '../db/db_service.dart';

class ArticlesPage extends StatefulWidget {
  const ArticlesPage({super.key});
  @override
  State<ArticlesPage> createState() => _ArticlesPageState();
}

class _ArticlesPageState extends State<ArticlesPage> {
  final _db = DBHelper();
  List<Map<String, dynamic>> _arts = [];
  bool _loading = true;

  @override
  void initState() { super.initState(); _load(); }

  Future<void> _load() async {
    final data = await _db.fetchArticles();
    setState(() { _arts = data; _loading = false; });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Artikel')),
      body: _loading ? const Center(child: CircularProgressIndicator()) : ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: _arts.length,
        itemBuilder: (_, i) {
          final a = _arts[i];
          return Card(
            child: ListTile(
              title: Text(a['title']),
              subtitle: Text(a['summary']),
              onTap: () => showDialog(context: context, builder: (_) => AlertDialog(title: Text(a['title']), content: SingleChildScrollView(child: Text(a['content'])))),
            ),
          );
        },
      ),
    );
  }
}
