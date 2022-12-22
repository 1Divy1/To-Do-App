import 'package:flutter/material.dart';
import 'package:to_do_app/storage.dart';
import 'package:to_do_app/dialog_box.dart';
import 'package:to_do_app/task_tile.dart';
import 'package:hive/hive.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  LocalStorage storage = LocalStorage();
  var taskController = TextEditingController();
  var box = Hive.box('taskBox');

  @override
  void initState() {
    super.initState();

    if (box.get('ToDoList') != null) {
      storage.loadData();
    }
  }

  // changes checkbox' bool value to the opposite
  // then updates the local storage value
  void checkBoxChanged(bool? value, int index) {
    setState(() {
      storage.toDoList[index][1] = !storage.toDoList[index][1];
      storage.updateLocalStorage();
    });
  }

  void createTask() {
    showDialog(
      context: context,
      builder: (context) => DialogBox(
        controller: taskController,
        onSave: saveTask,
      ),
    );
  }

  void saveTask() {
    if (taskController.text.isNotEmpty) {
      setState(() {
        storage.toDoList.add([taskController.text, false]);
        taskController.clear();
      });
      storage.updateLocalStorage();
      Navigator.pop(context);
    }
  }

  void deleteTask(int index) {
    setState(() {
      storage.toDoList.removeAt(index);
      storage.updateLocalStorage();
    });
  }

  void updateTask() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 50, 43, 148),
      body: ListView.builder(
        itemCount: storage.toDoList.length,
        itemBuilder: (BuildContext context, int index) {
          return TaskTile(
            taskName: storage.toDoList[index][0],
            bTaskCompleted: storage.toDoList[index][1],
            onChanged: (value) => checkBoxChanged(value, index),
            deleteFunction: (p0) => deleteTask(index),
          );
        },
      ),
      floatingActionButton: Transform.scale(
        scale: 1.2,
        child: FloatingActionButton(
          onPressed: createTask,
          backgroundColor: Colors.yellow,
          child: const Icon(
            Icons.add,
            color: Colors.black,
            size: 35,
          ),
        ),
      ),
    );
  }
}
