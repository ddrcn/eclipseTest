// ignore_for_file: public_member_api_docs, sort_constructors_first

part of 'comments_cubit.dart';

enum CommentStates { loading, loaded, empty, error }

class CommentsState extends Equatable {
  final CommentStates state;
  final List<PostComment> comments;

  const CommentsState._({
    this.state = CommentStates.loading,
    this.comments = const <PostComment>[],
  });

  const CommentsState.loading() : this._();

  const CommentsState.loaded(List<PostComment> comments)
      : this._(comments: comments, state: CommentStates.loaded);

  const CommentsState.error() : this._(state: CommentStates.error);
  const CommentsState.empty() : this._(state: CommentStates.empty);

  CommentsState copyWith({
    CommentStates? state,
    Post? post,
    List<PostComment>? comments,
  }) {
    return CommentsState._(
      state: state ?? this.state,
      comments: comments ?? this.comments,
    );
  }

  @override
  List<Object?> get props => [state, comments];
}
