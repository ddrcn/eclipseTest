part of 'home_bloc.dart';

abstract class HomePageState {}

class HomeEmptyState extends HomePageState {}

class HomeLoadingState extends HomePageState {}

class HomeLoadedState extends HomePageState {
  List<User> users;
  HomeLoadedState({
    required this.users,
  });
}

class HomeErrorState extends HomePageState {
  final Exception e;
  HomeErrorState(this.e);
}
