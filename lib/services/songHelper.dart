import 'package:sqflite/sqflite.dart';
import '../model/song.dart';
import 'package:path_provider/path_provider.dart';

class SongDatabaseHelper {
  static final String tableName = 'songs';
  static Database? _database;

  static Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initializeDatabase();
    return _database!;
  }

  static Future<Database> initializeDatabase() async {
    final directory = await getApplicationDocumentsDirectory();
    final String dbPath = directory.path; // Corrected variable name

    // Open database or create if not exists
    final String customDbPath = '$dbPath/songs.db';

    return await openDatabase(
      customDbPath,
      version: 1,
      onCreate: (db, version) {
        // Create table
        db.execute('''
          CREATE TABLE $tableName(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            music TEXT, 
            name TEXT,
            title TEXT,
            url TEXT,
            collection TEXT
          )
        ''');
      },
    );
  }

  static Future<void> insertSong(Song song) async {
    final db = await database;
    await db.insert(tableName, song.toMap());
  }

  static Future<List<Song>> getSongs() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(tableName);
    return List.generate(maps.length, (index) {
      return Song.fromMap(maps[index]);
    });
  }

  // Method to get a song from the database based on its music URL
  static Future<Song?> getSongByMusic(String musicUrl) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      tableName,
      where: 'music = ?',
      whereArgs: [musicUrl],
      limit: 1, // Limit to only one result
    );
    if (maps.isNotEmpty) {
      return Song.fromMap(maps.first);
    } else {
      return null;
    }
  }

  // Method to check if a song exists in the database based on its music URL
  static Future<bool> songExists(String musicUrl) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      tableName,
      where: 'music = ?',
      whereArgs: [musicUrl],
      limit: 1, // Limit to only one result
    );
    return maps.isNotEmpty;
  }
}
