import 'package:ToDoBeta/dialog_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:ToDoBeta/home.dart';

class TaskTile extends StatelessWidget {
  bool bTaskCompleted = false;
  String taskName;
  Function(bool?)? onChanged;
  Function(BuildContext)? deleteFunction;
  VoidCallback? editTask;

  TaskTile({
    super.key,
    required this.taskName,
    required this.bTaskCompleted,
    required this.onChanged,
    required this.deleteFunction,
    required this.editTask,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 10,
        bottom: 10,
        right: 20,
        left: 20,
      ),
      child: Slidable(
        endActionPane: ActionPane(
          motion: DrawerMotion(),
          extentRatio: 0.30,
          children: [
            SlidableAction(
              onPressed: deleteFunction,
              icon: Icons.delete,
              backgroundColor: Colors.red.shade300,
              borderRadius: BorderRadius.circular(12),
            ),
          ],
        ),
        child: GestureDetector(
          onTap: editTask,
          child: Container(
            padding: const EdgeInsets.only(left: 20, right: 15),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.yellow,
            ),
            child: Padding(
              padding: const EdgeInsets.only(
                top: 10,
                bottom: 10,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(
                      taskName,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        decoration: bTaskCompleted
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                      ),
                    ),
                  ),
                  Transform.scale(
                    scale: 1.8,
                    child: Checkbox(
                      value: bTaskCompleted,
                      onChanged: onChanged,
                      checkColor: Colors.white,
                      activeColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
