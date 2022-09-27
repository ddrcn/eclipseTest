import 'package:eclipse_test/data/models/user.dart';
import 'package:eclipse_test/services/repository/global_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomePageBloc extends Bloc<HomePageEvent, HomePageState> {
  final GlobalRepo _userRepo;
  HomePageBloc(this._userRepo) : super(HomeEmptyState()) {
    on<HomeLoadEvent>(
      (event, emit) async {
        emit(HomeLoadingState());
        try {
          final List<User> loadedUsers = await _userRepo.getUsers();
          if (isClosed) return;
          //await Future.delayed(const Duration(seconds: 3));
          emit(HomeLoadedState(users: loadedUsers));
        } catch (e) {
          emit(HomeErrorState(e as Exception));
        }
      },
    );
    on<HomeClearEvent>(
      (event, emit) async {
        emit(HomeEmptyState());
      },
    );
  }
}
