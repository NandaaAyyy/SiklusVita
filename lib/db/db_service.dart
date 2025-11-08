// lib/db/db_service.dart
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../model/model_user.dart';
import '../model/cycle_model.dart';

class DBHelper {
  static final DBHelper _instance = DBHelper._internal();
  factory DBHelper() => _instance;
  DBHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('siklusvita.db');
    return _database!;
  }

  Future<Database> _initDB(String fileName) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, fileName);
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        email TEXT UNIQUE NOT NULL,
        password TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE cycles(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        userId INTEGER NOT NULL,
        startDate TEXT NOT NULL,
        length INTEGER NOT NULL,
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

    // sample article
    await db.insert('articles', {
      'title': 'Mengurangi PMS Secara Alami',
      'summary': 'Tips makanan dan kebiasaan sehat untuk mengurangi PMS.',
      'content':
          'Istirahat cukup, olahraga ringan, asupan magnesium dan vitamin dapat membantu meredakan gejala PMS.',
      'createdAt': DateTime.now().toIso8601String()
    });
  }

  // User operations
  Future<int> insertUser(UserModel user) async {
    final db = await database;
    return await db.insert('users', user.toMap());
  }

  Future<UserModel?> getUserByEmail(String email) async {
    final db = await database;
    final res = await db.query('users', where: 'email=?', whereArgs: [email]);
    if (res.isNotEmpty) return UserModel.fromMap(res.first);
    return null;
  }

  Future<UserModel?> login(String email, String password) async {
    final db = await database;
    final res = await db.query('users',
        where: 'email=? AND password=?', whereArgs: [email, password]);
    if (res.isNotEmpty) return UserModel.fromMap(res.first);
    return null;
  }

  // Cycle operations
  Future<int> insertCycle(int userId, CycleModel cycle) async {
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
    final res =
        await db.query('cycles', where: 'userId=?', whereArgs: [userId], orderBy: 'startDate DESC');
    return res.map((e) => CycleModel.fromMap(e)).toList();
  }

  // Articles
  Future<List<Map<String, dynamic>>> fetchArticles() async {
    final db = await database;
    final res = await db.query('articles', orderBy: 'createdAt DESC');
    return res;
  }
}
