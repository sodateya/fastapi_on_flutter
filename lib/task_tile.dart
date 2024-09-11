import 'package:fastapi_on_flutter/task.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class TaskTile extends StatelessWidget {
  const TaskTile({super.key, required this.task});
  final Task task;

  @override
  Widget build(BuildContext context) {
    Future<void> markTaskAsDone(int taskId) async {
      final url = Uri.parse('http://10.18.249.219:8000/tasks/$taskId/done');
      final response = await http.put(url); // http.putが正しく呼び出されているか確認

      if (response.statusCode == 200) {
        print('Task marked as done');
      } else {
        print('Failed to mark task as done: ${response.statusCode}');
      }
    }

    Future<void> unmarkTaskAsDone(int taskId) async {
      final url = Uri.parse('http://10.18.249.219:8000/tasks/$taskId/done');
      final response = await http.delete(url); // http.putが正しく呼び出されているか確認

      if (response.statusCode == 200) {
        print('Task marked as done');
      } else {
        print('Failed to mark task as done: ${response.statusCode}');
      }
    }

    Future<void> deleteTask(int taskId) async {
      final url = Uri.parse('http://10.18.249.219:8000/tasks/$taskId');
      final response = await http.delete(url); // http.putが正しく呼び出されているか確認
      if (response.statusCode == 200) {
        print('DELETE');
      } else {
        print('FAILED :${response.statusCode}');
      }
    }

    return ListTile(
      title: Text(task.title),
      subtitle: Text('ID: ${task.id}'),
      trailing: Icon(
        task.done ? Icons.check_circle : Icons.circle_outlined,
        color: task.done ? Colors.green : Colors.grey,
      ),
      onTap: () {
        task.done ? unmarkTaskAsDone(task.id) : markTaskAsDone(task.id);
      },
      onLongPress: () => deleteTask(task.id),
    );
  }
}
