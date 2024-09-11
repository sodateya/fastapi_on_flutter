import 'dart:convert';

import 'package:fastapi_on_flutter/task_view.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('FastAPI Task Creator'),
        ),
        body: const TaskCreator(),
      ),
    );
  }
}

class TaskCreator extends StatefulWidget {
  const TaskCreator({super.key});

  @override
  _TaskCreatorState createState() => _TaskCreatorState();
}

class _TaskCreatorState extends State<TaskCreator> {
  final TextEditingController _controller = TextEditingController();
  final String _response = '';

  Future<void> createTask(String title) async {
    final url = Uri.parse('http://10.18.249.219:8000/tasks');
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({'title': title}),
    );

    if (response.statusCode == 200) {
      print('Task created: ${jsonDecode(response.body)['title']}');
    } else {
      print('Failed to create task: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextField(
            controller: _controller,
            decoration: const InputDecoration(labelText: 'Task Title'),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => createTask(_controller.text),
            child: const Text('Create Task'),
          ),
          const SizedBox(height: 20),
          Text(_response),
          const Expanded(child: TaskListView())
        ],
      ),
    );
  }
}
