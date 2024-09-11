import 'dart:async'; // Stream用
import 'dart:convert';

import 'package:fastapi_on_flutter/task.dart';
import 'package:fastapi_on_flutter/task_tile.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class TaskListView extends StatefulWidget {
  const TaskListView({super.key});

  @override
  _TaskListViewState createState() => _TaskListViewState();
}

class _TaskListViewState extends State<TaskListView> {
  final StreamController<List<Task>> _taskController =
      StreamController<List<Task>>();

  // タスクの取得関数
  Future<void> _getTask() async {
    final url = Uri.parse('http://10.18.249.219:8000/tasks/');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final decodedBody = utf8.decode(response.bodyBytes);
      List<dynamic> jsonData = jsonDecode(decodedBody);
      List<Task> tasks = jsonData.map((item) => Task.fromJson(item)).toList();
      _taskController.sink.add(tasks); // データをStreamに追加
    } else {
      print('Failed to load tasks. Status code: ${response.statusCode}');
    }
  }

  @override
  void initState() {
    super.initState();
    _getTaskPeriodically(); // 定期的にタスクを取得
  }

  // 一定間隔でタスクを取得する
  void _getTaskPeriodically() {
    Timer.periodic(const Duration(seconds: 5), (timer) {
      _getTask(); // 5秒ごとにデータを取得
    });
  }

  @override
  void dispose() {
    _taskController.close(); // StreamControllerを閉じる
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task List'),
      ),
      body: StreamBuilder<List<Task>>(
        stream: _taskController.stream, // StreamControllerのstreamを使う
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No tasks found'));
          } else {
            final tasks = snapshot.data!;
            return ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                return TaskTile(task: tasks[index]);
              },
            );
          }
        },
      ),
    );
  }
}
