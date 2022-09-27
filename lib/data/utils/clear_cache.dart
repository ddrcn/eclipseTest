// ignore_for_file: depend_on_referenced_packages

import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

///Очищает кэш приложения, полностью удаляя директорию с
///хранилищем Hive и всеми фотографиями
Future<void> clearCache({String path = '/Cache'}) async {
  if (kIsWeb) return;
  final appDirectory = await path_provider.getApplicationDocumentsDirectory();
  final cacheDir = Directory('${appDirectory.path}$path');
  try {
    if (await cacheDir.exists()) {
      if (true) {
        int fileNum = 0;
        int totalSize = 0;
        cacheDir
            .listSync(recursive: true, followLinks: true)
            .forEach((FileSystemEntity entity) {
          if (entity is File) {
            fileNum++;
            totalSize += entity.lengthSync();
          }
        });
        log('*** Было очищено кэша: ${totalSize * 0.000001} MB; файлов удалено: $fileNum');
      }
      await cacheDir.delete(recursive: true);
    } else {
      if (kDebugMode) {
        print('*** кэша нет');
      }
    }
  } catch (e) {
    if (kDebugMode) {
      print('*** Ошибка очистки кэша: ${e.toString()}');
    }
  }
}
