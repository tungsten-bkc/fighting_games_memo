class Todo {
  int? id;
  final String title;
  final int isCompleted;

  Todo({this.id, required this.title, required this.isCompleted});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'isCompleted': isCompleted,
    };
  }
}
