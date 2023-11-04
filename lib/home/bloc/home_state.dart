part of 'home_bloc.dart';

@immutable
sealed class HomeState {}

abstract class HomeActionState extends HomeState {}

final class HomeInitial extends HomeState {}

class HomeLoadSuccessState extends HomeState {
  final List<TaskData> taskDataList;

  HomeLoadSuccessState(this.taskDataList);
}

class HomeErrorState extends HomeState {}

class HomeLoadingState extends HomeState {}

class HomeNewTaskAddButtonClickedState extends HomeActionState {}

class HomeTaskCompltedButtonClickedState extends HomeActionState {}

class HomeTaskDeletedState extends HomeActionState {}
