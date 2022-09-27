part of 'posts_bloc.dart';

abstract class PostsUserState {}

class PostsUserEmptyState extends PostsUserState {}

class PostsUserLoadingState extends PostsUserState {}

class PostsUserLoadedState extends PostsUserState {
  List<Post> posts;
  PostsUserLoadedState({
    required this.posts,
  });
}

class PostsUserErrorState extends PostsUserState {
  final Exception e;
  PostsUserErrorState(this.e);
}
