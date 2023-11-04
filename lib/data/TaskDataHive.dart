import 'package:hive/hive.dart';

part 'TaskDataHive.g.dart';

@HiveType(typeId: 0)
class TaskData {
  @HiveField(0)
  int id;

  @HiveField(1)
  String taskName;

  @HiveField(2)
  String time;

  @HiveField(3)
  bool isComplete;

  TaskData({
    required this.id,
    required this.taskName,
    required this.time,
    required this.isComplete,
  });
}
