import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../modals/reminder.dart';

class ReminderDBHelper {
  ReminderDBHelper._();

  static final ReminderDBHelper reminderDBHelper = ReminderDBHelper._();

  String tableName = "reminder";
  String colId = "id";
  String colTask = "task";
  String colDescription = "taskDesc";
  String colEndTime = "endTime";

  Database? db;

// Todo: initDB
  Future<Database> initDatabase() async {
    var db = await openDatabase("myDb.db");

    String dataBasePath = await getDatabasesPath();

    String path = join(dataBasePath, "myDB.db");

    db = await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int vision) async {
        await db.execute(
            "CREATE TABLE IF NOT EXISTS $tableName($colId INTEGER PRIMARY KEY AUTOINCREMENT,$colTask TEXT,$colDescription TEXT,$colEndTime TEXT);");
      },
    );
    return db;
  }

// Todo: insertData
  Future<int> insertData({required Reminder data}) async {
    db = await initDatabase();

    String query = "INSERT INTO $tableName VALUES (?, ?, ?, ?);";
    List arg = [
      data.id,
      data.task,
      data.taskDesc,
      data.endTime,
    ];

    return await db!.rawInsert(query, arg);
  }

// Todo: updateData
  Future<int> updateData({required Reminder data,int? id}) async {
    db = await initDatabase();

    String query = "UPDATE $tableName SET $colTask = ?, $colDescription = ?, $colEndTime = ? WHERE id=?;";

    List args = [data.task,data.taskDesc,data.endTime,id];

    return await db!.rawUpdate(query,args);
  }

// Todo: fetchAllData
  Future<List<Reminder>> fetchAllData() async {
    db = await initDatabase();

    String query = "SELECT * FROM $tableName";

    List<Map<String, dynamic>> res = await db!.rawQuery(query);

    List<Reminder> reminderData = res.map((e) => Reminder.fromMap(data: e)).toList();

    return reminderData;
  }

// Todo: fetchSingleData

// Todo: deleteOneData
  Future<int> deleteSingleData({required int? id}) async {
    db = await initDatabase();

    String query = "DELETE FROM $tableName WHERE id=$id";
    return await db!.rawDelete(query);

  }

// Todo: deleteAllData
  Future<int> deleteAllData() async {
    db = await initDatabase();

    String query = "DELETE FROM $tableName";

    return await db!.rawDelete(query);
  }
}


























// import 'package:path/path.dart';
// import 'package:sqflite/sqflite.dart';
// import 'package:todo_app/modals/reminder.dart';
// import 'dart:developer';
//
// class ToDoDBHelper {
//   ToDoDBHelper._();
//
//   static final ToDoDBHelper toDoDBHelper = ToDoDBHelper._();
//
//   String colId = "id";
//   String tableName = "TODO";
//   String colStartTime = "startTime";
//   String colEndTime = "endTime";
//   String colNote = "note";
//
//   Database? db;
//
//   // Todo: initDB
//   Future<Database> initDatabase() async {
//     var db = await openDatabase("myDB.db");
//
//     String dataBasePath = await getDatabasesPath();
//
//     String path = join(dataBasePath, "myDB.db");
//
//     db = await openDatabase(
//       path,
//       version: 1,
//       onCreate: (Database db, int vision) async {
//         await db.execute('CREATE TABLE IF NOT EXISTS $tableName(id INTEGER PRIMARY KEY AUTOINCREMENT);');
//       },
//     );
//     return db;
//   }
//
//   // Todo: insertData
//   Future<int> insertData({required ToDo data}) async {
//     db = await initDatabase();
//
//     String query = "INSERT INTO $tableName VALUES (?,?,?,?);";
//     List arg = [data.id, data.startTime, data.endTime, data.myToDo];
//     log(query, name: "Data insert");
//     return await db!.rawInsert(query, arg);
//   }
//
//   // Todo: fetchAllData
//   Future<List<ToDo>> fetchAllData() async {
//     db = await initDatabase();
//     log(db.toString(), name: "DB");
//
//     String query = "SELECT * FROM $tableName";
//
//     List<Map<String, dynamic>> res = await db!.rawQuery(query);
//
//     List<ToDo> taskData = res.map((e) => ToDo.fromMap(data: e)).toList();
//
//     return taskData;
//   }
// }
