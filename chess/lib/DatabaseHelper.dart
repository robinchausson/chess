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

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    // Table joueur
    await db.execute('''
      CREATE TABLE joueur (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        pseudo TEXT NOT NULL,
        date_creation TEXT NOT NULL
      );
    ''');

    // Table partie
    await db.execute('''
      CREATE TABLE partie (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        id_joueur1 INTEGER NOT NULL,
        id_joueur2 INTEGER NOT NULL,
        date_creation TEXT NOT NULL,
        FOREIGN KEY (id_joueur1) REFERENCES joueur (id),
        FOREIGN KEY (id_joueur2) REFERENCES joueur (id)
      );
    ''');

    // Table victoire
    await db.execute('''
      CREATE TABLE victoire (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        id_joueur INTEGER NOT NULL,
        id_partie INTEGER,
        date TEXT NOT NULL,
        FOREIGN KEY (id_joueur) REFERENCES joueur (id),
        FOREIGN KEY (id_partie) REFERENCES partie (id)
      );
    ''');

    // Table defaite
    await db.execute('''
      CREATE TABLE defaite (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        id_joueur INTEGER NOT NULL,
        id_partie INTEGER,
        date TEXT NOT NULL,
        FOREIGN KEY (id_joueur) REFERENCES joueur (id),
        FOREIGN KEY (id_partie) REFERENCES partie (id)
      );
    ''');

     print('Creating database...');
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
