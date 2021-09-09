import 'package:flutter_calendar/model/model_day.dart';
import 'package:flutter_calendar/model/model_task.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

final String qryTasks = 'notes';

class TasksDatabase {
  static final TasksDatabase instance = TasksDatabase._init();

  static Database? _database;

  TasksDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('notes.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    final idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    final textType = 'TEXT NOT NULL';

    await db.execute('''
      CREATE TABLE $qryTasks ( 
        ${TaskFields.id} $idType, 
        ${TaskFields.description} $textType,
        ${TaskFields.time} $textType,
        ${TaskFields.duration} $textType,
        )
      ''');
  }

  Future<Task> create(Task task) async {
    final db = await instance.database;
    final id = await db.insert(qryTasks, task.toJson());
    return task.copy(id: id);
  }

  Future<Task> readTask(int id) async {
    // await TasksDatabase.instance.readTask(task);
    final db = await instance.database;

    final maps = await db.query(
      qryTasks,
      columns: TaskFields.values,
      where: '$id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Task.fromJson(maps.first);
    } else {
      throw Exception('ID $id not found');
    }
  }

  Future<List<Task>> readAllNotes() async {
    final db = await instance.database;

    final orderBy = '${TaskFields.time} ASC';
    // final result =
    //     await db.rawQuery('SELECT * FROM $tableNotes ORDER BY $orderBy');

    final result = await db.query(qryTasks, orderBy: orderBy);

    return result.map((json) => Task.fromJson(json)).toList();
  }

  Future<int> update(Task task) async {
    final db = await instance.database;

    return db.update(
      qryTasks,
      task.toJson(),
      where: '${TaskFields.id} = ?',
      whereArgs: [task.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await instance.database;

    return await db.delete(
      qryTasks,
      where: '${TaskFields.id} = ?',
      whereArgs: [id],
    );
  }

  Future close() async {
    final db = await instance.database;

    db.close();
  }

// http://sqlfiddle.com/#!5/ecc60/2
  Future<List<DayWithTask>> getTaskCountByDay(
      DateTime start, DateTime end) async {
    final db = await instance.database;
    final startDate = DateFormat.yMMMd().format(start);
    final endDate = DateFormat.yMMMd().format(end);
    final uniqueString = '\$ someUniqueStringOrValue \$';
    var res = await db.rawQuery('''
      WITH RECURSIVE dates(date) AS (
        VALUES(?1)
        UNION ALL
        SELECT date(date, '+1 day')
        FROM dates
        WHERE date < ?2
      )
      SELECT d.date, 
      CASE IFNULL(description, ?3)
          WHEN ?3 THEN 0
          ELSE count(*)
      END as count FROM dates d
      LEFT JOIN task t on t.day = d.date
      GROUP BY d.date    
      ORDER BY d.date; 
      ''', [startDate, endDate, uniqueString]);
    List list = res.isNotEmpty
        ? res.map((c) => DayWithTask.fromMap(c)).toList().toList()
        : [];
    return list as List<DayWithTask>;
  }
}
