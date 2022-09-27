import 'package:eclipse_test/bloc/bloc/home/home_bloc.dart';
import 'package:eclipse_test/data/utils/clear_cache.dart';
import 'package:eclipse_test/services/repository/global_repo.dart';
import 'package:eclipse_test/ui/screens/user_screen/user_screen.dart';
import 'package:eclipse_test/ui/widgets/home_screen/user_card.dart';
import 'package:eclipse_test/data/utils/app_theme.dart';
import 'package:eclipse_test/ui/widgets/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

part 'user_grid_views.dart';

// Домашняя страница с отображением карточек всех пользователей
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<HomePageBloc>(
      create: (context) => HomePageBloc(context.read<GlobalRepo>()),
      child: Scaffold(
        appBar: AppBar(
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: Builder(builder: (context) {
                return GestureDetector(
                  onTap: () {
                    _clearCache(context);
                  },
                  child: const Icon(Icons.delete),
                );
              }),
            )
          ],
          title: Text(
            'Eclipse демо',
            style: GoogleFonts.montserrat(color: Colors.white),
          ),
          centerTitle: true,
        ),
        body: Container(
          //color: backgroundColor,
          padding: const EdgeInsets.all(10),
          decoration: const BoxDecoration(
              gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              gradientStartColor,
              gradientEndColor,
            ],
          )),
          //child: const UserGrid(),
          child: Builder(builder: (context) {
            return userGridBuilder(BlocProvider.of<HomePageBloc>(context));
          }),
        ),
      ),
    );
  }

  BlocBuilder<HomePageBloc, HomePageState> userGridBuilder(
      HomePageBloc homePageBloc) {
    return BlocBuilder<HomePageBloc, HomePageState>(builder: (context, state) {
      if (state is HomeEmptyState) {
        return _emptyView(state, homePageBloc);
      } else if (state is HomeLoadingState) {
        return _loadingView(state, homePageBloc);
      } else if (state is HomeLoadedState) {
        return _loadedView(state, homePageBloc);
      } else {
        return _errorView(state, homePageBloc);
      }
    });
  }

  void _clearCache(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      builder: (_) {
        return Container(
          height: 200,
          color: Colors.amber,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const Text('Вы действительно хотите очистить кэш приложения?'),
                const SizedBox(
                  height: 15,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  child: const Text('Очистить'),
                  onPressed: () async {
                    await clearCache();
                    // ignore: use_build_context_synchronously
                    BlocProvider.of<HomePageBloc>(context)
                        .add(HomeClearEvent());
                    // ignore: use_build_context_synchronously
                    Navigator.pop(context);
                    await Future.delayed(const Duration(milliseconds: 80));
                    SnackBar snackBar = SnackBar(
                        duration: const Duration(seconds: 1),
                        backgroundColor: Colors.green[300],
                        content: const Text(
                          'Кэш приложения был очищен!',
                          textAlign: TextAlign.center,
                        ));
                    // ignore: use_build_context_synchronously
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
