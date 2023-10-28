import 'package:fighting_games_memo/todo.dart';
import 'package:fighting_games_memo/todo_bloc.dart';
import 'package:flutter/material.dart';

class TodoAddDialog extends StatelessWidget {
  final TextEditingController _textFieldController = TextEditingController();
  final TodoBloc todoBloc;

  TodoAddDialog({super.key, required this.todoBloc});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Todoを追加'),
      content: TextField(
        controller: _textFieldController,
        decoration: const InputDecoration(hintText: 'Todoのタイトルを入力してください'),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('キャンセル'),
          onPressed: () {
            Navigator.of(context).pop(); // ダイアログを閉じる
          },
        ),
        TextButton(
          child: const Text('追加'),
          onPressed: () {
            String todoTitle = _textFieldController.text;
            todoBloc.add(
              AddTodo(
                todo: Todo(title: todoTitle, isCompleted: 0),
              ),
            );
            todoBloc.add(LoadTodos());

            Navigator.of(context).pop(); // ダイアログを閉じる
          },
        ),
      ],
    );
  }
}
