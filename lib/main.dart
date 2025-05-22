import 'package:catatanku/components/notes_View.dart';
import 'package:flutter/material.dart';
import 'components/todo_View.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'To-Do & Catatan',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: Text("Manajemen Harian"),
            centerTitle: true,
            bottom: TabBar(
              tabs: [
                Tab(text: "To-Do List", icon: Icon(Icons.check_circle_outline)),
                Tab(text: "Catatan", icon: Icon(Icons.note_alt_outlined)),
                // Tab(text: "Catatan", icon: Icon(Icons.note_alt_outlined)),
              ],
            ),
          ),
          body: TabBarView(children: [TodoPage(), NotesPage()]),
        ),
      ),
    );
  }
}
