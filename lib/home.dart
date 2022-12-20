import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:ToDoBeta/storage.dart';
import 'package:ToDoBeta/dialog_box.dart';
import 'package:ToDoBeta/task_tile.dart';
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

  void editTask() {
    showDialog(
      context: context,
      builder: (context) => DialogBox(
        controller: taskController,
        onSave: () {
          if (taskController.text.isNotEmpty) {
            setState(() {
              taskController.clear();
            });
            storage.updateLocalStorage();
            Navigator.pop(context);
          }
        },
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

  // TO DO
  void updateTask() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 87, 72, 202),
        title: const Center(
          child: Text(
            'Tasks',
            style: TextStyle(
              fontSize: 35,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 50, 43, 148),
      body: ListView.builder(
        itemCount: storage.toDoList.length,
        itemBuilder: (BuildContext context, int index) {
          return TaskTile(
            taskName: storage.toDoList[index][0],
            bTaskCompleted: storage.toDoList[index][1],
            onChanged: (value) => checkBoxChanged(value, index),
            deleteFunction: (value) => deleteTask(index),
            editTask: () => editTask(),
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Transform.scale(
        scale: 1.2,
        child: FloatingActionButton(
          onPressed: createTask,
          backgroundColor: Colors.yellowAccent,
          child: const Icon(
            Icons.add,
            color: Colors.black,
            size: 35,
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 10,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        color: Colors.white,
        child: Container(
          height: 45,
          color: const Color.fromARGB(255, 87, 72, 202),
        ),
      ),
    );
  }
}
