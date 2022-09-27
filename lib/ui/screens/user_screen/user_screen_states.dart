// Состояния отображения для страницы пользователя (состояние постов, альбомов)
part of 'user_screen.dart';

Widget _postsLoadedState(
    PostsUserLoadedState state, BuildContext context, User user) {
  return Column(
    children: [
      ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: 3,
          itemBuilder: (context, index) {
            return Hero(
              tag: 'postCard$index',
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
                  children: [
                    ListTile(
                      shape: const RoundedRectangleBorder(
                        side: BorderSide(
                          color: Colors.white,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                      ),
                      tileColor: primaryColor.withOpacity(0.3),
                      title: Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Text(
                          state.posts[index].title,
                          style: GoogleFonts.montserrat(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 15),
                        ),
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(left: 15),
                        child: Text(
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          state.posts[index].body.replaceAll('\n', ''),
                          style: GoogleFonts.montserrat(
                              color: Colors.white, fontSize: 13),
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
                        // SnackBar snackBar =
                        //     SnackBar(content: Text("Tapped : ${index + 1}"));
                        // ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      },
                    ),
                  ],
                ),
              ),
            );
          }),
      const SizedBox(
        height: 10,
      ),
      TextButton(
          onPressed: () {
            final PostsUserBloc bloc = BlocProvider.of<PostsUserBloc>(context);
            Navigator.of(context).push(MaterialPageRoute<void>(
                builder: (_) => BlocProvider.value(
                      value: bloc,
                      child: const PostsScreen(),
                    )));
          },
          child: const Text('Посмотреть все >')),
    ],
  );
}

Widget _postsLoadingSate() => const LoadingWidget();

Widget _getDataErrorState(BuildContext context, void Function() onPressed) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text(
        'Ошибка при получении данных...',
        style: GoogleFonts.cambo(color: Colors.white, fontSize: 20),
      ),
      const SizedBox(
        height: 15,
      ),
      TextButton(onPressed: onPressed, child: const Text('Повторить')),
    ],
  );
}

Widget _textEmptyState(String text) => Text(
      text,
      style: GoogleFonts.cambo(color: Colors.white, fontSize: 20),
    );

CardSlider userAlbumsLoadedState(UserAlbumsState state, BuildContext context) {
  final pageController = PageController(viewportFraction: 0.8, initialPage: 0);

  return CardSlider(
    pageController: pageController,
    itemCount: state.albums.length,
    onPageChanged: BlocProvider.of<UserAlbumsCubit>(context).setCurrentAlbum,
    onTap: () {
      Navigator.of(context).push(MaterialPageRoute<void>(
          builder: (_) => AlbumScreen(
                album: state.albums[state.currentAlbum],
              )));
    },
    builder: (numPage) {
      return Text(
        state.albums[numPage].title,
        style: GoogleFonts.montserrat(
            color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
      );
    },
  );
}
