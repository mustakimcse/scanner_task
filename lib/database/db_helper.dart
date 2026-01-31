import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/file_item.dart';

class DBHelper {
  static Database? _db;

  Future<Database> get database async {
    _db ??= await _initDB();
    return _db!;
  }

  Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'files.db');

    return openDatabase(
      path,
      version: 1,
      onCreate: (db, _) async {
        await db.execute('''
        CREATE TABLE files(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT,
          path TEXT UNIQUE,
          size INTEGER,
          type TEXT,
          created_at TEXT,
          is_favorite INTEGER
        )
        ''');
      },
    );
  }

  Future<List<FileItem>> fetchFiles() async {
    final db = await database;
    final res = await db.query('files', orderBy: 'id DESC');
    return res.map((e) => FileItem.fromMap(e)).toList();
  }

  Future<void> insertFile(FileItem file) async {
    final db = await database;
    await db.insert(
      'files',
      file.toMap(),
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
  }

  Future<void> deleteFile(int id) async {
    final db = await database;
    await db.delete('files', where: 'id=?', whereArgs: [id]);
  }

  Future<void> toggleFavorite(int id, bool fav) async {
    final db = await database;
    await db.update(
      'files',
      {'is_favorite': fav ? 1 : 0},
      where: 'id=?',
      whereArgs: [id],
    );
  }
}
