part of 'home_bloc.dart';

@immutable
sealed class HomeEvent {}

class HomeInitialEvent extends HomeEvent {}

class HomeNewTaskAddButtonClickedEvent extends HomeEvent {}

class HomeTaskCompltedButtonClickedEvent extends HomeEvent {}

class HomeTaskDeletedEvent extends HomeEvent {}
