class Task {
  final int id;
  final String title;
  final bool done;

  Task({required this.id, required this.title, required this.done});

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      title: json['title'],
      done: json['done'],
    );
  }
}
