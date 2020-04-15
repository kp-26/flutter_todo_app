import 'package:fluttertodoapp/Utils/ToDoModel.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';


class DatabaseHelper {
  static final DatabaseHelper _instance = new DatabaseHelper.internal();

  factory DatabaseHelper() => _instance;
  static Database _db;

  Future<Database> get db async {
    if (_db != null) return _db;
    _db = await initDb();
    return _db;
  }

  DatabaseHelper.internal();

  //MARK: Initialize Database
  initDb() async {
    String path = join(await getDatabasesPath(), "todo_database.db");
    print("PATH : " + path);
    var theDb = await openDatabase(path, version: 1, onCreate: _onCreate);
    return theDb;
  }

  //MARK: Create Table
  void _onCreate(Database db, int version) async {
    await db.execute(
        "CREATE TABLE Todo(id INTEGER PRIMARY KEY, title TEXT, description TEXT, createdDate DATETIME, isCompleted BOOLEAN)");
  }

  //Add Item
  Future<int> saveItem(ToDoModel toDoModel) async {
    var dbClient = await db;
    toDoModel.isCompleted = false;
    int result = await dbClient.insert("Todo", toDoModel.toMap());
    return result;
  }


  //MARK: Get All Items
  Future<List<ToDoModel>> getAllItem() async {
    var dbClient = await db;
    List<Map> list = await dbClient.rawQuery("SELECT * FROM Todo ORDER BY createdDate DESC");
    print("List : " + list.toString());
    List<ToDoModel> todoList = new List();
    list.forEach((map) {
      ToDoModel toDoModel = ToDoModel.toModel(map);

      todoList.add(toDoModel);
    });
    return todoList;
  }

  //MARK: Update Item Data
  Future<int> updateItem(ToDoModel toDoModel, int id) async {
    var dbClient = await db;
    print("Passed Data :" + toDoModel.title);
    int res = await dbClient.rawUpdate(
        "UPDATE Todo SET title = ?, description = ?, createdDate = ? WHERE id = ?",
        [ toDoModel.title, toDoModel.description, toDoModel.createdDate, id]);
    print("Response : " + res.toString());
    return res;
  }

  //MARK: Delete Item Data
  Future<int> deleteItem(int id) async {
    var dbClient = await db;
    int res = await dbClient.rawDelete('DELETE FROM Todo WHERE id = ?', [id]);
    print("Response : " + res.toString());
    return res;
  }

  //MARK: Update Status
  Future<int> updateItemStatus(int id, bool status) async{
    var dbClient = await db;
    int res = await dbClient.rawUpdate(
        "UPDATE Todo SET isCompleted = ? WHERE id = ?",
        [status, id]);
    print("Response : " + res.toString());
    return res;
  }

}