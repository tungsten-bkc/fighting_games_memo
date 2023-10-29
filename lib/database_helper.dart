import 'package:fighting_games_memo/todo.dart';
import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  Database? _database;

  Future<void> initializeDatabase() async {
    _database = await openDatabase(
      'todo_database.db',
      version: 1,
      onCreate: (db, version) {
        db.execute('''
          CREATE TABLE todos(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT,
            isCompleted INTEGER
          )
        ''');
      },
    );
    debugPrint('Success');
  }

  Future<List<Todo>> getTodos() async {
    if (!_isDatabaseInitialized()) {
      throw Exception("Database not initialized!");
    }
    final List<Map<String, dynamic>> maps = await _database!.query('todos');
    return List.generate(maps.length, (i) {
      return Todo(
        id: maps[i]['id'],
        title: maps[i]['title'],
        isCompleted: maps[i]['isCompleted'],
      );
    });
  }

  Future<Todo> getTodoById(int id) async {
    // データベースから指定したIDのTodoを取得
    List<Map<String, dynamic>> maps = await _database!.query(
      'todos',
      where: 'id = ?',
      whereArgs: [id],
    );

    // データベースからのクエリ結果をTodoオブジェクトに変換
    if (maps.isNotEmpty) {
      return Todo.fromMap(maps.first);
      // Todoオブジェクトを返す
    } else {
      throw Exception('Todo not found'); // Todoが見つからない場合は例外をスロー
    }
  }

  Future<void> insertTodo(Todo todo) async {
    await _database?.insert('todos', todo.toMap());
  }

  Future<void> updateTodo(int id, String title, int isCompleted) async {
    final db = _database;
    final values = <String, dynamic>{
      "title": title,
      "isCompleted": isCompleted,
    };
    await db!.update(
      "todos",
      values,
      where: "id=?",
      whereArgs: [id],
    );
  }

  bool _isDatabaseInitialized() {
    return (_database != null) && _database!.isOpen;
  }
}
