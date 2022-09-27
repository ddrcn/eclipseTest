import 'dart:convert';

import 'package:eclipse_test/data/models/models_with_adapters.dart';
import 'package:flutter/services.dart';

import 'package:http/http.dart' as http;

/// Взаимодействует с внешним API
class ApiProvider {
  static const String apiUrl = 'jsonplaceholder.typicode.com';

  Future<List<User>> getUsersFromApi() async {
    const String urlPath = '/users';

    final Uri url = Uri(scheme: 'https', host: apiUrl, path: urlPath);
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final List<dynamic> resultJson = json.decode(response.body);
      return resultJson.map((json) => User.fromJson(json)).toList();
    } else {
      throw Exception(
          'Ошибка при получении пользователей с сервера: ${response.statusCode}');
    }
  }

  Future<List<Post>> getUserPostsFromApi(int userId) async {
    const String urlPath = '/posts';

    final Uri url = Uri(
        scheme: 'https',
        host: apiUrl,
        path: urlPath,
        queryParameters: {'userId': userId.toString()});
    final response = await http.get(url);

    //await Future.delayed(const Duration(seconds: 3));

    if (response.statusCode == 200) {
      final List<dynamic> resultJson = json.decode(response.body);
      return resultJson.map((json) => Post.fromJson(json)).toList();
    } else {
      throw Exception(
          'Ошибка при получении постов с сервера: ${response.statusCode}');
    }
  }

  Future<List<PostComment>> getPostCommentsFromApi(int postId) async {
    const String urlPath = '/comments';

    final Uri url = Uri(
        scheme: 'https',
        host: apiUrl,
        path: urlPath,
        queryParameters: {'postId': postId.toString()});
    final response = await http.get(url);

    //await Future.delayed(const Duration(seconds: 3));

    if (response.statusCode == 200) {
      final List<dynamic> resultJson = json.decode(response.body);
      return resultJson.map((json) => PostComment.fromJson(json)).toList();
    } else {
      throw Exception(
          'Ошибка при получении комментариев с сервера: ${response.statusCode}');
    }
  }

  Future<List<Album>> getUserAlbums(int userId) async {
    const String urlPath = '/albums';

    final Uri url = Uri(
        scheme: 'https',
        host: apiUrl,
        path: urlPath,
        queryParameters: {'userId': userId.toString()});
    final response = await http.get(url);

    //await Future.delayed(const Duration(seconds: 3));

    if (response.statusCode == 200) {
      final List<dynamic> resultJson = json.decode(response.body);
      return resultJson.map((json) => Album.fromJson(json)).toList();
    } else {
      throw Exception(
          'Ошибка при получении альбомов с сервера: ${response.statusCode}');
    }
  }

  Future<List<Photo>> getAlbumPhotos(int albumId) async {
    const String urlPath = '/photos';

    final Uri url = Uri(
        scheme: 'https',
        host: apiUrl,
        path: urlPath,
        queryParameters: {'albumId': albumId.toString()});
    final response = await http.get(url);

    //await Future.delayed(const Duration(seconds: 3));

    if (response.statusCode == 200) {
      final List<dynamic> resultJson = json.decode(response.body);
      return resultJson.map((json) => Photo.fromJson(json)).toList();
    } else {
      throw Exception(
          'Ошибка при получении фото с сервера: ${response.statusCode}');
    }
  }

  Future<Uint8List> getAlbumPhoto(String url) async {
    final u = Uri.parse(url);
    final response = await http.get(u);
    //TODO: Attention Required! | Cloudflare исправить
    if (response.statusCode == 200) {
      return response.bodyBytes;
    } else {
      throw Exception('Ошибка при получении фото с сервера: ${response.body}');
    }
  }

  Future<PostComment?> postPostCommentsToApi(
      {required int postId, required PostComment comment}) async {
    const String urlPath = '/comments';

    final Uri url = Uri(
        scheme: 'https',
        host: apiUrl,
        path: urlPath,
        queryParameters: {'postId': postId.toString()});
    final response = await http.post(url, body: json.encode(comment.toJson()));

    //await Future.delayed(const Duration(seconds: 3));

    if (response.statusCode == 201) {
      return comment..id = json.decode(response.body)['id'];
    } else {
      throw Exception(
          'Ошибка при получении id с сервера: ${response.statusCode}');
    }
  }
}
