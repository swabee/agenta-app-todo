import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:meta/meta.dart';
import 'package:my_manager/data/TaskDataHive.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeInitial()) {
    on<HomeInitialEvent>(homeInitialEvent);
    on<HomeNewTaskAddButtonClickedEvent>(homeNewTaskAddButtonClickedEvent);
    on<HomeTaskCompltedButtonClickedEvent>(homeTaskCompltedButtonClickedEvent);
    on<HomeTaskDeletedEvent>(homeTaskDeletedEvent);
  }

  FutureOr<void> homeInitialEvent(
      HomeInitialEvent event, Emitter<HomeState> emit) async {
    // Hive.registerAdapter(TaskDataAdapter());
    emit(HomeLoadingState());
    await Future.delayed(const Duration(seconds: 2));
    try {
      // Step 1: Open the Hive box
      final box = await Hive.openBox<TaskData>('taskDataBox');

      // Step 2: Retrieve the data from the box
      final List<TaskData> taskDataList = box.values.toList();

      emit(HomeLoadSuccessState(taskDataList));
    } catch (e) {
      // Handle errors if any
      emit(HomeErrorState());
    }
  }

  FutureOr<void> homeTaskCompltedButtonClickedEvent(
      HomeTaskCompltedButtonClickedEvent event, Emitter<HomeState> emit) async {
    try {
      final box = await Hive.openBox<TaskData>('taskDataBox');

      final List<TaskData> taskDataList = box.values.toList();

      emit(HomeTaskCompltedButtonClickedState());
      emit(HomeLoadSuccessState(taskDataList));
    } catch (e) {
      // Handle errors if any
      emit(HomeErrorState());
    }
  }

  FutureOr<void> homeNewTaskAddButtonClickedEvent(
      HomeNewTaskAddButtonClickedEvent event, Emitter<HomeState> emit) async {
    try {
      final box = await Hive.openBox<TaskData>('taskDataBox');

      final List<TaskData> taskDataList = box.values.toList();

      emit(HomeTaskCompltedButtonClickedState());
      emit(HomeLoadSuccessState(taskDataList));
    } catch (e) {
      // Handle errors if any
      emit(HomeErrorState());
    }
  }

  FutureOr<void> homeTaskDeletedEvent(
      HomeTaskDeletedEvent event, Emitter<HomeState> emit) async {
    try {
      final box = await Hive.openBox<TaskData>('taskDataBox');

      final List<TaskData> taskDataList = box.values.toList();

      emit(HomeTaskDeletedState());
      emit(HomeLoadSuccessState(taskDataList));
    } catch (e) {
      // Handle errors if any
      emit(HomeErrorState());
    }
  }
}
