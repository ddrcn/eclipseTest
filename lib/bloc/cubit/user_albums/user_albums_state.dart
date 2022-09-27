// ignore_for_file: public_member_api_docs, sort_constructors_first

part of 'user_albums_cubit.dart';

enum UserAlbumsStates { loading, loaded, empty, error }

class UserAlbumsState extends Equatable {
  final UserAlbumsStates state;
  final List<Album> albums;
  final int currentAlbum;

  const UserAlbumsState._({
    this.state = UserAlbumsStates.loading,
    this.albums = const <Album>[],
    this.currentAlbum = 0,
  });

  const UserAlbumsState.loading() : this._();
  const UserAlbumsState.loaded(List<Album> albums)
      : this._(state: UserAlbumsStates.loaded, albums: albums);
  const UserAlbumsState.error() : this._(state: UserAlbumsStates.error);
  const UserAlbumsState.empty() : this._(state: UserAlbumsStates.empty);

  @override
  List<Object> get props => [state, albums, currentAlbum];

  UserAlbumsState copyWith({
    UserAlbumsStates? state,
    List<Album>? albums,
    int? currentAlbum,
  }) {
    return UserAlbumsState._(
      state: state ?? this.state,
      albums: albums ?? this.albums,
      currentAlbum: currentAlbum ?? this.currentAlbum,
    );
  }
}
