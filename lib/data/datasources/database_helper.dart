import 'package:sqflite/sqflite.dart';
import '../models/activity_session_model.dart';
import 'package:path/path.dart';


class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;

  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'activity_tracker.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE activitySessions(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        walkingDistance REAL,
        runningDistance REAL,
        cyclingDistance REAL,
        walkingTime INTEGER,
        runningTime INTEGER,
        cyclingTime INTEGER,
        steps INTEGER,
        startTime TEXT,
        endTime TEXT
      )
    ''');
  }

  Future<void> insertActivitySession(ActivitySession session) async {
    final db = await database;
    await db.insert('activitySessions', session.toJson());
  }

  Future<List<ActivitySession>> getActivitySessions() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('activitySessions');
    return List.generate(maps.length, (i) {
      return ActivitySession.fromJson(maps[i]);
    });
  }
}
