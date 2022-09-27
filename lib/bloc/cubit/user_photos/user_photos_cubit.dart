// ignore_for_file: avoid_print

import 'dart:io';

import 'package:eclipse_test/data/models/album.dart';
import 'package:eclipse_test/data/models/photo.dart';
import 'package:eclipse_test/services/repository/global_repo.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'user_photos_state.dart';

class UserPhotosCubit extends Cubit<UserPhotosState> {
  final GlobalRepo repo;
  final Album album;

  UserPhotosCubit({required this.repo, required this.album})
      : super(const UserPhotosState.loading());

  Future<void> getPhotos({bool preload = true}) async {
    emit(const UserPhotosState.loading());
    try {
      final List<Photo> photos = await repo.getAlbumPhotos(album.id);
      if (isClosed) return;
      if (photos.isEmpty) {
        emit(const UserPhotosState.empty());
      } else {
        //emit(UserPhotosState.loaded(photos));
        emit(state.copyWith(
            photos: photos, state: UserPhotosStates.loadingPhoto));
      }
      if (preload) {
        setCurrentPhoto(0, getPreview: true);
      }
    } catch (e) {
      emit(const UserPhotosState.error());
    }
  }

  void setCurrentPhoto(int photoNum, {bool getPreview = false}) async {
    if (!isClosed) {
      emit(state.copyWith(currentPhoto: photoNum));
    }
    print('photo # ${state.currentPhoto}');

    if (getPreview) {
      Map<String, File> filesCache = {};

      //предзагрузка фото и очистка старых фото из памяти.
      //по умолчанию держит в памяти только 5 фото:
      //текущую фотографию и по две с каждой стороны карусели.
      //можно изменить путем редактирования значения [previewStep] в состоянии
      for (var i = photoNum; i <= photoNum + state.previewStep; i++) {
        if (i >= state.photos.length) break;
        if (state.imagesFilesMap
            .containsKey(state.photos[i].thumbnailUrl.hashCode.toString())) {
          //emit(state.copyWith(state: state.state));
          filesCache[state.photos[i].thumbnailUrl.hashCode.toString()] =
              state.imagesFilesMap[
                  state.photos[i].thumbnailUrl.hashCode.toString()]!;
          continue;
        }
        await getPhotoPreview(state.photos[i].thumbnailUrl);
        if (isClosed) return;
        if (!(state.imagesFilesMap[
                state.photos[i].thumbnailUrl.hashCode.toString()] ==
            null)) {
          filesCache[state.photos[i].thumbnailUrl.hashCode.toString()] =
              state.imagesFilesMap[
                  state.photos[i].thumbnailUrl.hashCode.toString()]!;
        }
      }
      for (var i = photoNum - state.previewStep; i < photoNum; i++) {
        if (i < 0) continue;
        if (state.imagesFilesMap
            .containsKey(state.photos[i].thumbnailUrl.hashCode.toString())) {
          //emit(state.copyWith(state: state.state));
          filesCache[state.photos[i].thumbnailUrl.hashCode.toString()] =
              state.imagesFilesMap[
                  state.photos[i].thumbnailUrl.hashCode.toString()]!;
          continue;
        }
        await getPhotoPreview(state.photos[i].thumbnailUrl);
        if (isClosed) return;

        if (!(state.imagesFilesMap[
                state.photos[i].thumbnailUrl.hashCode.toString()] ==
            null)) {
          filesCache[state.photos[i].thumbnailUrl.hashCode.toString()] =
              state.imagesFilesMap[
                  state.photos[i].thumbnailUrl.hashCode.toString()]!;
        }
      }

      //debug для проверки фото в памяти
      //перезапись хранилища фото, дабы уменьшить потребляемую память
      if (!isClosed) {
        emit(state.copyWith(imagesFilesMap: Map.of(filesCache)));
      }
      print('фото в памяти:${state.imagesFilesMap.length}');
    }
  }

  Future<bool> getPhotoPreview(String photoUrl) async {
    print('--загрузка фото операция');
    final hash = photoUrl.hashCode.toString();
    emit(state.copyWith(state: UserPhotosStates.loadingPhoto));
    if (state.imagesFilesMap.containsKey(hash)) {
      emit(state.copyWith(state: UserPhotosStates.loaded));
      return true;
    }
    final result = await repo.getPhoto(photoUrl);
    if (isClosed) return false;
    if (result != null) {
      Map<String, File> imgs = Map.of(state.imagesFilesMap);
      imgs[hash] = result;
      emit(
          state.copyWith(state: UserPhotosStates.loaded, imagesFilesMap: imgs));
    } else {
      emit(state.copyWith(state: UserPhotosStates.loadingPhoto));
      return false;
    }
    return true;
  }
}
