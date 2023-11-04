import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:my_manager/data/TaskDataHive.dart';

class TaskDataModel {
  List<List<TaskData>> taskDataGrid = [];

  // Function to add a new TaskData
  Future<void> addTask(TaskData taskData) async {
    try {
      // print(
      //     "${taskData.taskName}${taskData.time}${taskData.isComplete}${taskData.id}");

      final box = await Hive.openBox<TaskData>('taskDataBox');
      final uniqueIndex = await generateUniqueIndex(box);

      if (uniqueIndex != null) {
        taskData.id = uniqueIndex;
        box.put(uniqueIndex, taskData);
        taskDataGrid.add([taskData]);
      } else {}
    } catch (e) {
      print('erro $e');
    }
  }

  Future<int?> generateUniqueIndex(Box<TaskData> box) async {
    int currentIndex = 0;
    while (box.containsKey(currentIndex)) {
      currentIndex++;
      print('otp');
    }
    return currentIndex;
  }

  // Function to update a TaskData
  Future taskComplete(TaskData taskData, BuildContext context) async {
    final box = await Hive.openBox<TaskData>('taskDataBox');
    box.putAt(
        taskData.id,
        TaskData(
            id: taskData.id,
            taskName: taskData.taskName,
            time: taskData.time,
            isComplete: !taskData.isComplete));

    if (taskData.isComplete == true) {
    } else if (taskData.isComplete == false) {}
  }

  // Function to delete a TaskData
  void deleteRow(int taskId) async {
    final box = await Hive.openBox<TaskData>('taskDataBox');
    List<List<TaskData>> newTaskDataGrid = [];

    // Delete the specified task
    box.delete(taskId);

    // Reassign new IDs to the remaining tasks in the grid
    int newId = 0;
    for (var tasks in taskDataGrid) {
      List<TaskData> newTasks = [];
      for (var task in tasks) {
        if (task.id != taskId) {
          // If the task is not the one being deleted, reassign a new ID
          task.id = newId;
          newTasks.add(task);
          newId++;
        }
      }
      newTaskDataGrid.add(newTasks);
    }

    // Update the taskDataGrid with the modified data
    taskDataGrid = newTaskDataGrid;
  }

  int getCompletedCount(List<TaskData> taskDataList) {
    int num = 0;

    for (var taskData in taskDataList) {
      if (taskData.isComplete == true) {
        num++;
      }
    }

    return num;
  }

  int getnotCompletedCount(List<TaskData> taskDataList) {
    int num = 0;

    for (var taskData in taskDataList) {
      if (taskData.isComplete == false) {
        num++;
      }
    }

    return num;
  }
}
