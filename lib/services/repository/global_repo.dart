// ignore_for_file: avoid_print, depend_on_referenced_packages

import 'dart:io';
import 'package:universal_io/io.dart' as web_io;
import 'package:eclipse_test/data/models/models_with_adapters.dart';
import 'package:eclipse_test/services/provider/api_provider.dart';
import 'package:eclipse_test/services/provider/hive_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

class GlobalRepo {
  final ApiProvider _apiProvider = ApiProvider();
  final HiveProvider _hiveProvider = HiveProvider();

  ///Получает список всех постов пользователя [userId].
  ///
  ///При наличии кэша берет данные оттуда,
  ///а если кэша нет, то берет данные из сети и параллельно записывает их в кэш-хранилище Hive
  Future<List<Post>> getUserPosts(int userId) async {
    String boxName = 'UserPosts$userId';
    List<Post> result = [];
    if (await _hiveProvider.isExists(boxName: boxName)) {
      print('Посты из кэша');
      try {
        result = await _hiveProvider.getBoxes<Post>(boxName);
      } catch (e) {
        print(e.toString());
      }
    } else {
      try {
        result = await _apiProvider.getUserPostsFromApi(userId);
        await _hiveProvider.addBoxes(result, boxName);
        print('Посты с сервера');
      } catch (e) {
        print(e.toString());
      }
    }
    return result;
    //await _apiProvider.getUserPostsFromApi(userId);
  }

  ///Получает список всех пользователей
  ///
  ///При наличии кэша берет данные оттуда,
  ///а если кэша нет, то берет данные из сети и параллельно записывает их в кэш-хранилище Hive
  Future<List<User>> getUsers() async {
    String boxName = 'Users';
    List<User> result = [];
    if (await _hiveProvider.isExists(boxName: boxName)) {
      print('Данные из кэша');
      try {
        result = await _hiveProvider.getBoxes<User>(boxName);
      } catch (e) {
        print(e.toString());
      }
    } else {
      try {
        result = await _apiProvider.getUsersFromApi();
        await _hiveProvider.addBoxes(result, boxName);
        print('Данные с сервера');
      } catch (e) {
        print(e.toString());
      }
    }
    return result;
  }

  /// Получает список всех комментариев к посту [postId].
  ///
  ///При наличии кэша берет данные оттуда,
  ///а если кэша нет, то берет данные из сети и параллельно записывает их в кэш-хранилище Hive
  Future<List<PostComment>> getPostComments(int postId) async {
    String boxName = 'Comments$postId';
    List<PostComment> result = [];
    if (await _hiveProvider.isExists(boxName: boxName)) {
      print('Комменты из кэша');
      try {
        result = await _hiveProvider.getBoxes<PostComment>(boxName);
      } catch (e) {
        print(e.toString());
      }
    } else {
      try {
        result = await _apiProvider.getPostCommentsFromApi(postId);
        await _hiveProvider.addBoxes(result, boxName);
        print('Комменты с сервера');
      } catch (e) {
        print(e.toString());
      }
    }
    return result;
  }

  /// Получает список всех альбомов пользователя [userId].
  ///
  /// При наличии кэша берет данные оттуда,
  ///а если кэша нет, то берет данные из сети и параллельно записывает их в кэш-хранилище Hive
  Future<List<Album>> getUserAlbums(int userId) async {
    String boxName = 'User${userId}Albums';
    List<Album> result = [];
    if (await _hiveProvider.isExists(boxName: boxName)) {
      print('Альбомы из кэша');
      try {
        result = await _hiveProvider.getBoxes<Album>(boxName);
      } catch (e) {
        print(e.toString());
      }
    } else {
      try {
        result = await _apiProvider.getUserAlbums(userId);
        await _hiveProvider.addBoxes(result, boxName);
        print('Альбомы с сервера');
      } catch (e) {
        print(e.toString());
      }
    }
    return result;
  }

  /// Получает список всех фото в альбоме [albumId].
  ///
  /// При наличии кэша берет данные оттуда,
  ///а если кэша нет, то берет данные из сети и параллельно записывает их в кэш-хранилище Hive
  Future<List<Photo>> getAlbumPhotos(int albumId) async {
    String boxName = 'Albums$albumId';
    List<Photo> result = [];
    if (await _hiveProvider.isExists(boxName: boxName)) {
      print('Фото в Альбомы из кэша');
      try {
        result = await _hiveProvider.getBoxes<Photo>(boxName);
      } catch (e) {
        print(e.toString());
      }
    } else {
      try {
        result = await _apiProvider.getAlbumPhotos(albumId);
        await _hiveProvider.addBoxes(result, boxName);
        print('Фото в Альбомы с сервера');
      } catch (e) {
        print(e.toString());
      }
    }
    return result;
  }

  ///Получает фото в виде файла.
  ///
  ///Если в локальном хранилище уже есть экземпляр фото, берет его.
  ///Иначе скачивает фото из интернета.
  ///
  ///Уникальным идентификатором фото является хэш от ссылки на фото.
  Future<File?> getPhoto(String photoUrl) async {
    if (kIsWeb) {
      //File webFile = File(photoUrl);
      //TODO: доделать отображение фото в браузере
      final webPhotoBytes = await _apiProvider.getAlbumPhoto(photoUrl);
      return web_io.File.fromRawPath(webPhotoBytes);
    }
    final appDirectory = await path_provider.getApplicationDocumentsDirectory();
    final photoDir = '${appDirectory.path}/Cache/photo';
    final String fname = '$photoDir/${photoUrl.hashCode.toString()}';
    if (!await Directory(photoDir).exists()) {
      await Directory(photoDir).create(recursive: true);
    }
    if (await File(fname).exists()) {
      print('фото из кэша');
      return File(fname);
    }
    try {
      final photoBytes = await _apiProvider.getAlbumPhoto(photoUrl);
      File file = File(fname);
      print('фото из сети');
      await file.writeAsBytes(photoBytes);
      return file;
    } catch (e) {
      print('error getPhoto: ${e.toString()}');
    }
    return null;
  }

  Future<bool> postComment(
      {required int postId, required PostComment comment}) async {
    String boxName = 'Comments$postId';
    List<PostComment> result = [];
    final postComment = await _apiProvider.postPostCommentsToApi(
        postId: postId, comment: comment);
    if (postComment == null) {
      print('ошибка при добавлении комментария');
      return false;
    }

    if (await _hiveProvider.isExists(boxName: boxName)) {
      try {
        // result = await _hiveProvider.getBoxes<PostComment>(boxName);
        // result.add(postComment);
        await _hiveProvider.addBoxes([postComment], boxName);
        return true;
      } catch (e) {
        print(e.toString());
      }
    } else {
      try {
        result = await _apiProvider.getPostCommentsFromApi(postId);
        result.add(postComment);
        await _hiveProvider.addBoxes(result, boxName);
        print('Комменты с сервера');
        return true;
      } catch (e) {
        print(e.toString());
      }
    }
    return false;
  }
}
