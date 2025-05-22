import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class databaseHelper {
  static final databaseHelper instance = databaseHelper._init();

  static Database? _database;

  databaseHelper._init();

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

  Future<List<Map<String, dynamic>>> getJoueurs({int limit = 0}) async {
    final db = await database;
    final limitClause = limit > 0 ? 'LIMIT $limit' : '';
    return await db.rawQuery('''
      SELECT 
        joueur.id, 
        joueur.pseudo, 
        COUNT(victoire.id) AS nb_victoires,
        RANK() OVER (ORDER BY COUNT(victoire.id) DESC) AS classement
      FROM joueur
      LEFT JOIN victoire ON joueur.id = victoire.id_joueur
      GROUP BY joueur.id
      ORDER BY nb_victoires DESC
      $limitClause
    ''');
  }

  Future<void> joueurAGagne(int idJoueur, int idPartie) async {
    final db = await database;
    final now = DateTime.now().toIso8601String();

    await db.insert('victoire', {
      'id_joueur': idJoueur,
      'id_partie': idPartie,
      'date': now,
    });
  }

  Future<int> insertJoueur(String pseudo) async {
    final db = await database;
    final now = DateTime.now().toIso8601String();

    // Vérifie si le pseudo existe déjà
    final existing = await db.query(
      'joueur',
      where: 'pseudo = ?',
      whereArgs: [pseudo],
    );
    if (existing.isNotEmpty) {
      // Retourne -1 pour indiquer que le pseudo existe déjà
      return -1;
    }

    return await db.insert('joueur', {
      'pseudo': pseudo,
      'date_creation': now,
    });
  }
}
