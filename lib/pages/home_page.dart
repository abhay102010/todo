import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../data/database.dart';
import '../util/dialog_box.dart';
import '../util/todo_tile.dart';


class HomePage extends StatefulWidget {

  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _my_box = Hive.box('lwp');
  TodoDataBase db = TodoDataBase();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  @override
  void initState() {
      db.loadData();
    super.initState();
  }

  final _controller = TextEditingController();

  void checkBoxChanged(bool? value, int index) {
    setState(() {
      db.todoList[index]["isDone"] = !db.todoList[index]["isDone"];
    });
    db.updateDatabase();
  }
  Future<void> addTodoToFirebase() async {
    await _firestore.collection('Todo').add({
      'title': _controller.text,
      'isDone': false,
    });
    _controller.clear();
  }
  void saveNewTask() {
    setState(() {
      db.todoList.add({
        'title': _controller.text,
        'isDone': false,
      });
      addTodoToFirebase();
    });
    Navigator.of(context).pop();
    db.updateDatabase();
  }

  Future<void> deleteTask(int index) async {
    QuerySnapshot querySnapshot = await _firestore.collection('Todo').get();
    for (QueryDocumentSnapshot doc in querySnapshot.docs) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      if(db.todoList[index]["title"]==data["title"]){
        await _firestore.collection('Todo').doc(doc.id).delete();
      }
    }
    setState(() {
      db.todoList.removeAt(index);
    });
    db.updateDatabase();
  }

  void createNewTask() {
    showDialog(
        context: context,
        builder: (context) {
          return DialogBox(
              controller: _controller,
              onSave: saveNewTask,
              onCancel: () => Navigator.of(context).pop());
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[200],
      appBar: AppBar(
        title: const Text('TO DO'),
        elevation: 0,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: createNewTask,
        child: const Icon(Icons.add),
      ),
      body:db.todoList.isEmpty?Center(child: Text("No data"),): ListView.builder(
        itemCount: db.todoList.length,
        itemBuilder: (context, index) {
          return ToDoTile(
            taskName: db.todoList[index]["title"],
            taskCompleted: db.todoList[index]["isDone"],
            onChanged: (value) => checkBoxChanged(value, index),
            deleteFunction: (context) => deleteTask(index),
          );
        },
      ),
    );
  }
}
