// Состояния для отображения грида карточек пользователей

part of 'home_screen.dart';

Widget _errorView(HomePageState state, HomePageBloc bloc) {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Ошибка при получении данных...',
          style: GoogleFonts.cambo(color: Colors.white, fontSize: 20),
        ),
        const SizedBox(
          height: 25,
        ),
        state is HomeErrorState
            ? Text(
                (state.e.toString()),
                style:
                    GoogleFonts.montserrat(color: Colors.white, fontSize: 10),
              )
            : const SizedBox(
                height: 0,
              ),
        const SizedBox(
          height: 25,
        ),
        Image.asset(
          'assets/sorry_error.png',
          height: 350,
          width: 350,
        ),
        const SizedBox(
          height: 25,
        ),
        ElevatedButton(
          onPressed: () {
            bloc.add(HomeLoadEvent());
          },
          child: const Text('Повторить'),
        ),
      ],
    ),
  );
}

Widget _loadedView(HomePageState state, HomePageBloc bloc) {
  var users = (state as HomeLoadedState).users;
  return RefreshIndicator(
    onRefresh: () async {
      bloc.add(HomeLoadEvent());
    },
    child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, crossAxisSpacing: 10, mainAxisSpacing: 10),
        itemCount: users.length,
        itemBuilder: (context, index) {
          return UserCard(
            name: users[index].name,
            username: users[index].username,
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute<void>(
                    builder: (_) => BlocProvider.value(
                          value: BlocProvider.of<HomePageBloc>(context),
                          child: UserScreen(users[index]),
                        ))),
          );
        }),
  );
}

Widget _loadingView(HomePageState state, HomePageBloc bloc) => const Center(
      child: LoadingWidget(),
    );

Widget _emptyView(HomePageState state, HomePageBloc bloc) => Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Нет данных',
            style: GoogleFonts.montserrat(color: Colors.white, fontSize: 20),
          ),
          const SizedBox(
            height: 10,
          ),
          Image.asset(
            'assets/no-data.png',
            height: 350,
            width: 350,
          ),
          const SizedBox(
            height: 20,
          ),
          ElevatedButton(
            onPressed: () {
              bloc.add(HomeLoadEvent());
            },
            child: const Text('Загрузить пользователей'),
          ),
        ],
      ),
    );
