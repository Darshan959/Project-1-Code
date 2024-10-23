import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper {
  static final DBHelper _instance = DBHelper._();
  static Database? _database;

  DBHelper._();

  static DBHelper get instance => _instance;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('mindfulness.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE user_preferences (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        notification BOOLEAN,
        hydration_reminder BOOLEAN
      )
    ''');

    await db.execute('''
      CREATE TABLE affirmations (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        text TEXT,
        saved BOOLEAN
      )
    ''');

    await db.execute('''
      CREATE TABLE hydration_log (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        date TEXT,
        amount INTEGER
      )
    ''');

    // Add additional tables for sleep log, meditation sessions, etc.
  }

  // CRUD operations for Preferences
  Future<void> updatePreferences(
      bool notification, bool hydrationReminder) async {
    final db = await instance.database;
    await db.insert('user_preferences', {
      'notification': notification ? 1 : 0,
      'hydration_reminder': hydrationReminder ? 1 : 0,
    });
  }

  Future<Map<String, dynamic>?> getPreferences() async {
    final db = await instance.database;
    final result = await db.query('user_preferences');
    return result.isNotEmpty ? result.first : null;
  }

  // CRUD operations for Affirmations
  Future<void> insertAffirmation(String text) async {
    final db = await instance.database;
    await db.insert('affirmations', {
      'text': text,
      'saved': 1,
    });
  }

  Future<List<Map<String, dynamic>>> getAffirmations() async {
    final db = await instance.database;
    return await db.query('affirmations');
  }

  // CRUD operations for Hydration Log
  Future<void> logHydration(String date, int amount) async {
    final db = await instance.database;
    await db.insert('hydration_log', {
      'date': date,
      'amount': amount,
    });
  }

  Future<List<Map<String, dynamic>>> getHydrationLog() async {
    final db = await instance.database;
    return await db.query('hydration_log');
  }

  // Add similar methods for meditation sessions, sleep log, etc.
}
