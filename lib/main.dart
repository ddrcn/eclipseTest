// ignore_for_file: depend_on_referenced_packages

import 'package:eclipse_test/data/models/models_with_adapters.dart';
import 'package:eclipse_test/services/repository/global_repo.dart';
import 'package:eclipse_test/ui/screens/home_screen/home_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:eclipse_test/data/utils/app_theme.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Hive.initFlutter();
  } else {
    final appDirectory = await path_provider.getApplicationDocumentsDirectory();
    Hive.init('${appDirectory.path}/Cache/hiveCache');
  }
  registerHiveAdapters();

  runApp(const MyApp());
}

void registerHiveAdapters() {
  Hive.registerAdapter(UserAdapter());
  Hive.registerAdapter(AddressAdapter());
  Hive.registerAdapter(GeoAdapter());
  Hive.registerAdapter(PostAdapter());
  Hive.registerAdapter(CompanyAdapter());
  Hive.registerAdapter(PhotoAdapter());
  Hive.registerAdapter(AlbumAdapter());
  Hive.registerAdapter(PostCommentAdapter());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => GlobalRepo(),
      child: MaterialApp(
        title: 'Eclipse Test',
        theme: getThemeData(context),
        home: const HomeScreen(),
      ),
    );
  }
}
