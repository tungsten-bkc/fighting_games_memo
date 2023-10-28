import 'package:fighting_games_memo/database_helper.dart';
import 'package:fighting_games_memo/todo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  final DatabaseHelper databaseHelper;

  TodoBloc({required this.databaseHelper}) : super(TodoInitial()) {
    on<AddTodo>((event, emit) async {
      await databaseHelper.insertTodo(event.todo);
      emit(TodoAdded());
    });

    on<LoadTodos>((event, emit) async {
      final todos = await databaseHelper.getTodos();
      emit(TodosLoaded(todos));
    });
  }
}

// イベント
abstract class TodoEvent {}

class AddTodo extends TodoEvent {
  final Todo todo;

  AddTodo({required this.todo});
}

class LoadTodos extends TodoEvent {}

// ステート
abstract class TodoState {}

class TodoInitial extends TodoState {}

class TodosLoaded extends TodoState {
  final List<Todo> todos;

  TodosLoaded(this.todos);
}

class TodoAdded extends TodoState {}
