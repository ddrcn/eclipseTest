import 'package:eclipse_test/bloc/bloc/user_posts/posts_bloc.dart';
import 'package:eclipse_test/data/utils/app_theme.dart';
import 'package:eclipse_test/ui/animations/navigator_route.dart';
import 'package:eclipse_test/ui/screens/post_screen/post_screen.dart';
import 'package:eclipse_test/ui/widgets/text_icon_message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

// Страница всех постов пользователя
class PostsScreen extends StatelessWidget {
  const PostsScreen({this.userName = 'User', super.key});
  //final PostsUserBloc bloc;
  final String userName;
  @override
  Widget build(BuildContext context) {
    final PostsUserBloc postsBloc = BlocProvider.of<PostsUserBloc>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          '$userName\'s posts',
          style: GoogleFonts.montserrat(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: SizedBox.expand(
        child: DecoratedBox(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [
                gradientStartColor,
                gradientEndColor,
              ],
            ),
          ),
          child: BlocBuilder<PostsUserBloc, PostsUserState>(
            bloc: postsBloc,
            builder: (context, state) {
              if (state is PostsUserLoadedState) {
                return ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: state.posts.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        child: Card(
                          margin: const EdgeInsets.all(12),
                          elevation: 4,
                          color: primaryColor.withOpacity(0),
                          shape: const RoundedRectangleBorder(
                            side: BorderSide(
                              color: Colors.white,
                            ),
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 15, bottom: 5, top: 10),
                                child: Text(
                                  //maxLines: 1,
                                  //overflow: TextOverflow.ellipsis,
                                  state.posts[index].title,
                                  style: GoogleFonts.montserrat(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(15),
                                child: Text(
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  softWrap: false,
                                  state.posts[index].body.replaceAll('\n', ''),
                                  style: GoogleFonts.montserrat(
                                      color: Colors.white, fontSize: 13),
                                ),
                              ),
                            ],
                          ),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            scaleRoute(
                              PostScreen(
                                post: state.posts[index],
                                tagName: 'postCard$index',
                              ),
                            ),
                          );
                        },
                      );
                    });
              } else {
                return const TextIconMessage(
                  message: 'Ошибка при загрузке постов пользователя',
                  imgPath: 'assets/sorry_error.png',
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
