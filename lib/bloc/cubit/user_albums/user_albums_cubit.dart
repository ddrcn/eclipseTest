import 'package:eclipse_test/data/models/album.dart';
import 'package:eclipse_test/data/models/user.dart';
import 'package:eclipse_test/services/repository/global_repo.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'user_albums_state.dart';

class UserAlbumsCubit extends Cubit<UserAlbumsState> {
  final GlobalRepo repo;
  final User user;

  UserAlbumsCubit({required this.repo, required this.user})
      : super(const UserAlbumsState.loading());

  Future<void> getAlbums() async {
    emit(const UserAlbumsState.loading());
    try {
      final List<Album> albums = await repo.getUserAlbums(user.id);
      if (isClosed) return;
      if (albums.isEmpty) {
        emit(const UserAlbumsState.empty());
      } else {
        emit(UserAlbumsState.loaded(albums));
      }
    } catch (e) {
      emit(const UserAlbumsState.error());
    }
  }

  void setCurrentAlbum(int num) {
    emit(state.copyWith(currentAlbum: num));
    // ignore: avoid_print
    print('album # ${state.currentAlbum}');
  }
}
