import 'package:eclipse_test/bloc/bloc/user_posts/posts_bloc.dart';
import 'package:eclipse_test/bloc/cubit/user_albums/user_albums_cubit.dart';
import 'package:eclipse_test/data/models/user.dart';
import 'package:eclipse_test/services/repository/global_repo.dart';
import 'package:eclipse_test/ui/screens/album_screen/album_screen.dart';
import 'package:eclipse_test/ui/screens/post_screen/post_screen.dart';
import 'package:eclipse_test/ui/screens/posts_screen/posts_screen.dart';
import 'package:eclipse_test/ui/widgets/card_slider.dart';
import 'package:eclipse_test/ui/widgets/loading_widget.dart';
import 'package:eclipse_test/data/utils/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:eclipse_test/ui/animations/navigator_route.dart';
part 'user_screen_states.dart';

class UserScreen extends StatelessWidget {
  const UserScreen(this.user, {super.key});
  //final GlobalRepo _userRepo = GlobalRepo();
  final User user;

  @override
  Widget build(BuildContext context) {
    final GlobalRepo repo = context.read<GlobalRepo>();
    return MultiBlocProvider(
      providers: [
        BlocProvider<PostsUserBloc>(
          create: ((_) =>
              PostsUserBloc(repo)..add(PostsLoadEvent(userId: user.id))),
        ),
        BlocProvider(
          create: (_) => UserAlbumsCubit(repo: repo, user: user)..getAlbums(),
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            user.username,
            style: GoogleFonts.montserrat(color: Colors.white),
          ),
          centerTitle: true,
        ),
        body: Container(
          padding: const EdgeInsets.all(10),
          height: MediaQuery.of(context).size.height,
          //color: backgroundColor,
          decoration: const BoxDecoration(
              gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              gradientStartColor,
              gradientEndColor,
            ],
          )),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              //crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //Info
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    const SizedBox(height: 30),
                    _getInfoFormatRow(text: user.name, ico: Icons.person),
                    const SizedBox(height: 30),
                    _getInfoFormatRow(text: user.email, ico: Icons.mail),
                    const SizedBox(height: 30),
                    _getInfoFormatRow(text: user.phone, ico: Icons.phone),
                    const SizedBox(height: 30),
                    _getInfoFormatRow(text: user.website, ico: Icons.web),
                    const Divider(
                        thickness: 3, height: 30, color: secondaryColor),
                  ],
                ),

                //Work
                Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Работа:',
                        style: GoogleFonts.montserrat(
                            color: Colors.white,
                            fontSize: 25,
                            fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ]),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    const SizedBox(height: 30),
                    _getInfoFormatRow(text: user.company.name, title: 'name:'),
                    const SizedBox(height: 30),
                    _getInfoFormatRow(text: user.company.bs, title: 'bs:'),
                    const SizedBox(height: 30),
                    _getInfoFormatRow(
                        text: '„${user.company.catchPhrase}”',
                        title: 'phrase:',
                        fontStyle: FontStyle.italic),
                    const Divider(
                        thickness: 3, height: 30, color: secondaryColor),
                  ],
                ),

                //Address
                Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Адрес:',
                        style: GoogleFonts.montserrat(
                            color: Colors.white,
                            fontSize: 25,
                            fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ]),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    const SizedBox(height: 30),
                    _getInfoFormatRow(text: user.address.city, title: 'city:'),
                    const SizedBox(height: 30),
                    _getInfoFormatRow(
                        text: user.address.street, title: 'street:'),
                    const SizedBox(height: 30),
                    _getInfoFormatRow(
                        text: user.address.zipcode, title: 'zipcode:'),
                    const SizedBox(height: 30),
                    _getInfoFormatRow(
                        text: user.address.suite, title: 'suite:'),
                    const SizedBox(height: 30),
                    _getInfoFormatRow(
                        text: user.address.street, title: 'street:'),
                    const SizedBox(height: 30),
                    _getInfoFormatRow(
                        text:
                            '${user.address.geo.lat}, ${user.address.geo.lng}',
                        title: 'geo lat, lng:'),
                  ],
                ),
                const Divider(thickness: 3, height: 30, color: secondaryColor),

                //Posts
                _getPostsContent(context, user),
                const Divider(thickness: 3, height: 30, color: secondaryColor),

                //Albums
                _getAlbumsContent(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  ///Отображение альбомов пользователя
  Column _getAlbumsContent() {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            'Альбомы:',
            style: GoogleFonts.montserrat(
                color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          BlocBuilder<UserAlbumsCubit, UserAlbumsState>(
              builder: (context, state) {
            switch (state.state) {
              case UserAlbumsStates.loading:
                return const LoadingWidget();

              case UserAlbumsStates.empty:
                return _textEmptyState('Альбомы отсутсвуют...');
              case UserAlbumsStates.loaded:
                return userAlbumsLoadedState(state, context);

              case UserAlbumsStates.error:
              default:
                return _getDataErrorState(context, () {
                  BlocProvider.of<UserAlbumsCubit>(context).getAlbums();
                });
            }
          }),
        ]);
  }

  ///Возвращает форматированную строку с информацией
  Widget _getInfoFormatRow(
          {required String text,
          IconData? ico,
          String? title,
          double fontSize = 20,
          FontStyle fontStyle = FontStyle.normal}) =>
      Row(
        children: <Widget>[
          (ico == null)
              ? ((title == null)
                  ? const SizedBox(
                      width: 0,
                    )
                  : Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.fade,
                      softWrap: false,
                      style: GoogleFonts.montserrat(
                          color: Colors.white,
                          fontSize: fontSize,
                          fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ))
              : Icon(ico),
          const SizedBox(width: 25),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.montserrat(
                  color: Colors.white,
                  fontSize: fontSize,
                  fontStyle: fontStyle),
              textAlign: TextAlign.start,
            ),
          ),
        ],
      );

  ///Возвращает отображение постов пользователя
  Widget _getPostsContent(BuildContext context, User user) {
    return Builder(builder: (context) {
      return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Посты:',
              style: GoogleFonts.montserrat(
                  color: Colors.white,
                  fontSize: 25,
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            BlocBuilder<PostsUserBloc, PostsUserState>(
                builder: (context, state) {
              if (state is PostsUserLoadedState) {
                return _postsLoadedState(state, context, user);
              } else if (state is PostsUserLoadingState) {
                //return const Text('LOADING...');
                return _postsLoadingSate();
              } else if (state is PostsUserErrorState) {
                return _getDataErrorState(
                  context,
                  () => BlocProvider.of<PostsUserBloc>(context)
                      .add(PostsLoadEvent(userId: user.id)),
                );
              } else {
                return _textEmptyState('Посты пользователя отсутствуют');
              }
            }),
          ]);
    });
  }
}
