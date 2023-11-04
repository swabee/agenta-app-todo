// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'TaskDataHive.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TaskDataAdapter extends TypeAdapter<TaskData> {
  @override
  final int typeId = 0;

  @override
  TaskData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TaskData(
      id: fields[0] as int,
      taskName: fields[1] as String,
      time: fields[2] as String,
      isComplete: fields[3] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, TaskData obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.taskName)
      ..writeByte(2)
      ..write(obj.time)
      ..writeByte(3)
      ..write(obj.isComplete);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TaskDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
