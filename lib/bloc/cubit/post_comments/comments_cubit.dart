import 'package:eclipse_test/data/models/post.dart';
import 'package:eclipse_test/data/models/post_comment.dart';
import 'package:eclipse_test/services/repository/global_repo.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'comments_state.dart';

class CommentsCubit extends Cubit<CommentsState> {
  final Post post;
  final GlobalRepo repo;

  CommentsCubit({required this.repo, required this.post})
      : super(const CommentsState.loading());

  Future<void> getComments() async {
    emit(const CommentsState.loading());
    try {
      final List<PostComment> comments = await repo.getPostComments(post.id);
      if (isClosed) return;
      if (comments.isEmpty) {
        emit(const CommentsState.empty());
      } else {
        emit(CommentsState.loaded(comments));
      }
    } catch (e) {
      emit(const CommentsState.error());
    }
  }
}
