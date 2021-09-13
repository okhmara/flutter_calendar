import 'package:flutter_calendar/model/dayTasks_model.dart';
import 'package:flutter_calendar/model/task_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

final String qryTasks = 'tasks';

class TasksDatabase {
  static final TasksDatabase instance = TasksDatabase._init();

  static Database? _database;

  TasksDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('tasks.db');
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
        ${TaskFields.date} $textType,
        ${TaskFields.duration} $textType
        )
      ''');
  }

  Future<Task> create(Task task) async {
    final db = await instance.database;
    final id = await db.insert(qryTasks, task.toJson());
    return task.copy(id: id);
  }

  Future<Task> readTask(int id) async {
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

  Future<List<Task>> readAllTasks(DateTime date) async {
    final db = await instance.database;

    final day = date.toString().substring(0, 10);
    final orderBy = '${TaskFields.date} ASC';

    final result = await db.query(
      qryTasks,
      columns: TaskFields.values,
      where: '${TaskFields.date} = ?',
      whereArgs: [day],
      orderBy: orderBy,
    );

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

  Future<List<DayTasks>> getTasksAmount(DateTime start, DateTime end) async {
    final db = await instance.database;
    final from = start.toString().substring(0, 10);
    final to = end.toString().substring(0, 10);
    final res = await db.query(
      qryTasks,
      columns: [
        TaskAmountFields.date,
        'COUNT(*) as ${TaskAmountFields.amount}'
      ],
      where: '${TaskFields.date} BETWEEN ? AND ?',
      whereArgs: [from, to],
      groupBy: '${TaskFields.date}',
    );
    List<DayTasks> list = res.isNotEmpty
        ? res.map((c) => DayTasks.fromMap(c)).toList().toList()
        : <DayTasks>[];
    return list;
  }

// http://sqlfiddle.com/#!5/ecc60/2
// to slow !!!
// this is just an example of getting calendar days using SQL
  Future<List<DayTasks>> getTaskCountWithDays(
      DateTime start, DateTime end) async {
    final db = await instance.database;
    final startDate = start.toString().substring(0, 10);
    final endDate = end.toString().substring(0, 10);
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
      CASE IFNULL(${TaskFields.description}, ?3)
          WHEN ?3 THEN 0
          ELSE count(*)
      END as ${TaskAmountFields.amount}
      FROM dates d
      LEFT JOIN $qryTasks t on t.${TaskFields.date} = d.date
      GROUP BY d.date    
      ORDER BY d.date; 
      ''', [startDate, endDate, uniqueString]);
    List<DayTasks> list = res.isNotEmpty
        ? res.map((c) => DayTasks.fromMap(c)).toList().toList()
        : <DayTasks>[];
    return list;
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
}
