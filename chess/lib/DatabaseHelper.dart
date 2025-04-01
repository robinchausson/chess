import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('bdd.db');
    return _database!;
  }

  Future<Database> _initDB(String fileName) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, fileName);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        age INTEGER NOT NULL
      )
    ''');
  }

  Future<void> close() async {
    final db = await database;
    db.close();
  }

  // Ajouter un utilisateur
  Future<int> addUser(String name, int age) async {
    final db = await database;
    return await db.insert('users', {'name': name, 'age': age});
  }
  
  // Lire tous les utilisateurs
  Future<List<Map<String, dynamic>>> getUsers() async {
    final db = await database;
    return await db.query('users');
  }
  
  // Mettre à jour un utilisateur
  Future<int> updateUser(int id, String name, int age) async {
    final db = await database;
    return await db.update('users', {'name': name, 'age': age}, where: 'id = ?', whereArgs: [id]);
  }
  
  // Supprimer un utilisateur
  Future<int> deleteUser(int id) async {
    final db = await database;
    return await db.delete('users', where: 'id = ?', whereArgs: [id]);
  }
}
