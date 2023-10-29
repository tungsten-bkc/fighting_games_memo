import 'package:fighting_games_memo/todo_add_dialog.dart';
import 'package:fighting_games_memo/todo_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TodoListPage extends StatelessWidget {
  const TodoListPage({super.key});

  @override
  // ignore: avoid_renaming_method_parameters
  Widget build(BuildContext todolistContext) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todoアプリ'),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.plus_one),
        onPressed: () {
          showDialog(
            context: todolistContext,
            builder: (BuildContext context) {
              return TodoAddDialog(
                todoBloc: BlocProvider.of<TodoBloc>(todolistContext),
              ); // カスタムのダイアログを表示
            },
          );
        },
      ),
      body: BlocBuilder<TodoBloc, TodoState>(
        builder: (context, state) {
          if (state is TodoInitial) {
            BlocProvider.of<TodoBloc>(context).add(LoadTodos());
            return const Center(child: CircularProgressIndicator());
          } else if (state is TodosLoaded) {
            final todos = state.todos;
            return ListView.builder(
              itemCount: todos.length,
              itemBuilder: (context, index) {
                var todo = todos[index];
                return ListTile(
                  title: Text(todo.title),
                  subtitle: Text('ID: ${todo.id}'),
                  trailing: Checkbox(
                    value: todo.isCompleted == 1,
                    onChanged: (bool? value) {
                      debugPrint("リストがタップされました。 ${todo.isCompleted}");
                      BlocProvider.of<TodoBloc>(context).add(UpdateTodoEvent(
                          id: todo.id!,
                          isCompleted: todo.isCompleted == 1 ? 0 : 1));
                      BlocProvider.of<TodoBloc>(context).add(LoadTodos());
                    },
                  ),
                );
              },
            );
          } else if (state is TodosUpdates) {
            final todos = state.todos;
            return ListView.builder(
              itemCount: todos.length,
              itemBuilder: (context, index) {
                var todo = todos[index];
                return ListTile(
                  title: Text(todo.title),
                  subtitle: Text('ID: ${todo.id}'),
                  trailing: Checkbox(
                    value: todo.isCompleted == 1,
                    onChanged: (bool? value) {
                      debugPrint("リストがタップされました。 ${todo.isCompleted}");
                      BlocProvider.of<TodoBloc>(context).add(UpdateTodoEvent(
                          id: todo.id!,
                          isCompleted: todo.isCompleted == 1 ? 0 : 1));
                      BlocProvider.of<TodoBloc>(context).add(LoadTodos());
                    },
                  ),
                );
              },
            );
          } else {
            BlocProvider.of<TodoBloc>(context).add(LoadTodos());
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
