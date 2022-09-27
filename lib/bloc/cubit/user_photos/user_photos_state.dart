// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'user_photos_cubit.dart';

enum UserPhotosStates { loading, loaded, empty, error, loadingPhoto }

class UserPhotosState extends Equatable {
  final UserPhotosStates state;
  final List<Photo> photos;
  final int currentPhoto;
  final int previewStep;
  final Map<String, File> imagesFilesMap;

  const UserPhotosState._({
    this.state = UserPhotosStates.loading,
    this.photos = const <Photo>[],
    this.currentPhoto = 0,
    this.imagesFilesMap = const <String, File>{},
    this.previewStep = 2,
  });

  const UserPhotosState.loading() : this._();
  const UserPhotosState.error() : this._(state: UserPhotosStates.error);
  const UserPhotosState.empty() : this._(state: UserPhotosStates.empty);
  const UserPhotosState.loaded(List<Photo> photos)
      : this._(state: UserPhotosStates.loaded, photos: photos);
  const UserPhotosState.loadingPhoto()
      : this._(state: UserPhotosStates.loadingPhoto);

  @override
  List<Object> get props =>
      [state, photos, currentPhoto, imagesFilesMap, previewStep];

  UserPhotosState copyWith({
    UserPhotosStates? state,
    List<Photo>? photos,
    int? currentPhoto,
    Map<String, File>? imagesFilesMap,
    int? previewStep,
  }) {
    return UserPhotosState._(
      state: state ?? this.state,
      photos: photos ?? this.photos,
      currentPhoto: currentPhoto ?? this.currentPhoto,
      imagesFilesMap: imagesFilesMap ?? this.imagesFilesMap,
      previewStep: previewStep ?? this.previewStep,
    );
  }
}
