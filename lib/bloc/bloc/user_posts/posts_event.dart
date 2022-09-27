// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'posts_bloc.dart';

abstract class PostsUserEvent {}

class PostsLoadEvent extends PostsUserEvent {
  final int userId;
  PostsLoadEvent({
    required this.userId,
  });
}
