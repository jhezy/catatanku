import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class Task {
  String title;
  bool isDone;

  Task({required this.title, this.isDone = false});

  Map<String, dynamic> toJson() => {'title': title, 'isDone': isDone};

  static Task fromJson(Map<String, dynamic> json) =>
      Task(title: json['title'], isDone: json['isDone']);
}

class TodoPage extends StatefulWidget {
  @override
  _TodoPageState createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  List<Task> _tasks = [];
  final _controller = TextEditingController();
  SharedPreferences? _prefs;

  @override
  void initState() {
    super.initState();
    _initPrefsAndLoadTasks();
  }

  Future<void> _initPrefsAndLoadTasks() async {
    _prefs = await SharedPreferences.getInstance();
    final taskList = _prefs?.getStringList('tasks') ?? [];
    setState(() {
      _tasks = taskList.map((e) => Task.fromJson(json.decode(e))).toList();
    });
  }

  Future<void> _saveTasks() async {
    if (_prefs == null) return;
    final taskList = _tasks.map((e) => json.encode(e.toJson())).toList();
    await _prefs!.setStringList('tasks', taskList);
  }

  void _addTaskDialog() {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: Text("Tambah Tugas"),
            content: TextField(
              controller: _controller,
              autofocus: true,
              decoration: InputDecoration(hintText: "Masukkan nama tugas"),
              onSubmitted: (_) => _submitTask(),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  _controller.clear();
                  Navigator.pop(context);
                },
                child: Text("Batal"),
              ),
              ElevatedButton(onPressed: _submitTask, child: Text("Tambah")),
            ],
          ),
    );
  }

  void _submitTask() {
    final title = _controller.text.trim();
    if (title.isNotEmpty) {
      setState(() {
        _tasks.add(Task(title: title));
        _controller.clear();
      });
      _saveTasks();
      Navigator.pop(context);
    }
  }

  void _toggleTask(int index) {
    setState(() {
      _tasks[index].isDone = !_tasks[index].isDone;
    });
    _saveTasks();
  }

  void _deleteTask(int index) {
    setState(() {
      _tasks.removeAt(index);
    });
    _saveTasks();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF9FAFB),

      body:
          _tasks.isEmpty
              ? Center(child: Text("Belum ada tugas."))
              : ListView.builder(
                padding: EdgeInsets.all(12),
                itemCount: _tasks.length,
                itemBuilder: (context, index) {
                  final task = _tasks[index];
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    margin: EdgeInsets.symmetric(vertical: 6),
                    child: ListTile(
                      leading: Checkbox(
                        value: task.isDone,
                        onChanged: (_) => _toggleTask(index),
                        shape: CircleBorder(),
                      ),
                      title: Text(
                        task.title,
                        style: TextStyle(
                          fontSize: 16,
                          decoration:
                              task.isDone ? TextDecoration.lineThrough : null,
                          color: task.isDone ? Colors.grey : Colors.black,
                        ),
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.delete_outline, color: Colors.red),
                        onPressed: () => _deleteTask(index),
                      ),
                    ),
                  );
                },
              ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addTaskDialog,
        child: Icon(Icons.add),
        backgroundColor: Colors.lightBlue,
      ),
    );
  }
}
