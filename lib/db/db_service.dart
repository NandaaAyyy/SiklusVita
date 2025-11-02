import 'dart:async';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import '../model/cycle_model.dart';
import '../model/model_user.dart';

class DBHelper {
  static final DBHelper _instance = DBHelper._internal();
  factory DBHelper() => _instance;
  DBHelper._internal();

  static Database? _db;

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDB('siklusvita.db');
    return _db!;
  }

  Future<Database> _initDB(String fileName) async {
    final dir = await getApplicationDocumentsDirectory();
    final path = join(dir.path, fileName);
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        email TEXT UNIQUE,
        password TEXT
      )
    ''');
    await db.execute('''
      CREATE TABLE cycles(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        userId INTEGER,
        startDate TEXT,
        length INTEGER,
        isPCOS INTEGER DEFAULT 0,
        FOREIGN KEY (userId) REFERENCES users(id)
      )
    ''');
    await db.execute('''
      CREATE TABLE articles(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT,
        summary TEXT,
        content TEXT,
        createdAt TEXT
      )
    ''');

    // insert sample articles
    await db.insert('articles', {
      'title': 'Mengurangi PMS Secara Alami',
      'summary': 'Tips makanan dan kebiasaan sehat untuk mengurangi PMS.',
      'content': 'Istirahat, makan bergizi, magnesium, dan olahraga ringan dapat membantu...',
      'createdAt': DateTime.now().toIso8601String()
    });
  }

  // User CRUD
  Future<int> insertUser(UserModel user) async {
    final db = await database;
    return await db.insert('users', user.toMap());
  }

  Future<UserModel?> getUserByEmail(String email) async {
    final db = await database;
    final res = await db.query('users', where: 'email = ?', whereArgs: [email]);
    if (res.isNotEmpty) return UserModel.fromMap(res.first);
    return null;
  }

  Future<UserModel?> getUserById(int id) async {
    final db = await database;
    final res = await db.query('users', where: 'id = ?', whereArgs: [id]);
    if (res.isNotEmpty) return UserModel.fromMap(res.first);
    return null;
  }

  // cycles
  Future<int> insertCycle(CycleModel cycle, int userId) async {
    final db = await database;
    return await db.insert('cycles', {
      'userId': userId,
      'startDate': cycle.startDate.toIso8601String(),
      'length': cycle.length,
      'isPCOS': cycle.isPCOS ? 1 : 0
    });
  }

  Future<List<CycleModel>> fetchCycles(int userId) async {
    final db = await database;
    final res = await db.query('cycles', where: 'userId = ?', whereArgs: [userId], orderBy: 'startDate DESC');
    return res.map((e) => CycleModel.fromMap(e)).toList();
  }

  // articles
  Future<List<Map<String, dynamic>>> fetchArticles() async {
    final db = await database;
    final res = await db.query('articles', orderBy: 'createdAt DESC');
    return res;
  }
}
