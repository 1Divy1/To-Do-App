import 'package:hive/hive.dart';

class LocalStorage {
  List toDoList = [];
  var box = Hive.box('taskBox');
  
  void updateLocalStorage() {
    box.put('ToDoList', toDoList);
  }

  void loadData() {
    toDoList = box.get('ToDoList');
  }
}