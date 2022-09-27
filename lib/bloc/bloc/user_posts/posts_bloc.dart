import 'package:eclipse_test/data/models/post.dart';
import 'package:eclipse_test/services/repository/global_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'posts_event.dart';
part 'posts_state.dart';

class PostsUserBloc extends Bloc<PostsUserEvent, PostsUserState> {
  final GlobalRepo _userRepo;
  PostsUserBloc(this._userRepo) : super(PostsUserEmptyState()) {
    on<PostsLoadEvent>(
      (event, emit) async {
        emit(PostsUserLoadingState());
        try {
          final List<Post> loadedPosts =
              await _userRepo.getUserPosts(event.userId);
          if (isClosed) return;

          //await Future.delayed(const Duration(seconds: 3));
          emit(PostsUserLoadedState(posts: loadedPosts));
        } catch (e) {
          emit(PostsUserErrorState(e as Exception));
        }
      },
    );
  }
}
