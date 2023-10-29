import 'package:fighting_games_memo/database_helper.dart';
import 'package:fighting_games_memo/todo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  final DatabaseHelper databaseHelper;

  TodoBloc({required this.databaseHelper}) : super(TodoInitial()) {
    on<AddTodoEvent>((event, emit) async {
      await databaseHelper.insertTodo(event.todo);
      emit(TodoAdded());
    });

    on<UpdateTodoEvent>((event, emit) async {
      Todo oldTodo = await databaseHelper.getTodoById(event.id);
      // データベースで指定されたTodoを更新
      // 空の場合は元々の値をそのまま使う。
      await databaseHelper.updateTodo(
        event.id,
        event.title ?? oldTodo.title,
        event.isCompleted ?? oldTodo.isCompleted,
      );
      final todos = await databaseHelper.getTodos();
      emit(TodosUpdates(todos));
    });

    on<LoadTodos>((event, emit) async {
      final todos = await databaseHelper.getTodos();
      emit(TodosLoaded(todos));
    });
  }
}

// イベント
abstract class TodoEvent extends Equatable {
  const TodoEvent();
  @override
  List<Object> get props => [];
}

class AddTodoEvent extends TodoEvent {
  final Todo todo;

  const AddTodoEvent({required this.todo});
}

class UpdateTodoEvent extends TodoEvent {
  final int id;
  final String? title;
  final int? isCompleted;

  const UpdateTodoEvent({
    required this.id,
    this.title,
    this.isCompleted,
  });
}

class LoadTodos extends TodoEvent {}

// ステート
abstract class TodoState extends Equatable {
  const TodoState();
  @override
  List<Object> get props => [];
}

class TodoInitial extends TodoState {}

class TodosLoaded extends TodoState {
  final List<Todo> todos;

  const TodosLoaded(this.todos);
}

class TodosUpdates extends TodoState {
  final List<Todo> todos;

  const TodosUpdates(this.todos);
}

class TodoAdded extends TodoState {}
