import 'package:fighting_games_memo/todo_list_page.dart';
import 'package:fighting_games_memo/database_helper.dart';
import 'package:fighting_games_memo/todo_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  DatabaseHelper databaseHelper = DatabaseHelper();
  try {
    await databaseHelper.initializeDatabase();
  } catch (e) {
    debugPrint('Database initialization error: $e');
  }
  runApp(MyApp(databaseHelper: databaseHelper));
}

class MyApp extends StatelessWidget {
  final DatabaseHelper databaseHelper;

  const MyApp({super.key, required this.databaseHelper});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BlocProvider(
        create: (context) => TodoBloc(databaseHelper: databaseHelper),
        child: const TodoListPage(),
      ),
    );
  }
}
