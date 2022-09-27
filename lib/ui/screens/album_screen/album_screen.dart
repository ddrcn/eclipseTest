import 'package:eclipse_test/bloc/cubit/user_photos/user_photos_cubit.dart';
import 'package:eclipse_test/data/models/album.dart';
import 'package:eclipse_test/data/utils/app_theme.dart';
import 'package:eclipse_test/services/repository/global_repo.dart';
import 'package:eclipse_test/ui/widgets/card_slider.dart';
import 'package:eclipse_test/ui/widgets/loading_widget.dart';
import 'package:eclipse_test/ui/widgets/text_icon_message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

// Страница всех фотографий альбома
class AlbumScreen extends StatelessWidget {
  const AlbumScreen({required this.album, super.key});
  final Album album;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<UserPhotosCubit>(
      create: (context) {
        final cubit =
            UserPhotosCubit(repo: context.read<GlobalRepo>(), album: album)
              ..getPhotos();
        // cubit.getPhotoPreview(cubit.state.photos[0].thumbnailUrl);
        return cubit;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Album #${album.id}',
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
            child: BlocBuilder<UserPhotosCubit, UserPhotosState>(
              builder: (context, state) {
                switch (state.state) {
                  case UserPhotosStates.loading:
                    return _loadingState();
                  case UserPhotosStates.loaded:
                  case UserPhotosStates.loadingPhoto:
                    return _loadedState(state, context);
                  case UserPhotosStates.empty:
                    return _textMessageState(
                        message: 'Фотографии отсутствуют...',
                        imgPath: 'assets/no-data.png');
                  case UserPhotosStates.error:
                  default:
                    return _textMessageState(
                        message: 'Ошибка при загрузке фотографий альбома...',
                        imgPath: 'assets/sorry_error.png');
                }
              },
            ),
          ),
        ),
      ),
    );
  }

  CardSlider _loadedState(UserPhotosState state, BuildContext context) {
    return CardSlider(
      height: 400,
      numericCount: true,
      pageController: PageController(viewportFraction: 0.8, initialPage: 0),
      itemCount: state.photos.length,
      onPageChanged: (n) {
        BlocProvider.of<UserPhotosCubit>(context)
            .setCurrentPhoto(n, getPreview: true);
        // BlocProvider.of<UserPhotosCubit>(context)
        //     .getPhotoPreview(state.photos[n].thumbnailUrl);
      },
      onTap: () {},
      builder: (numPage) {
        final fileImg = state.imagesFilesMap[
            state.photos[numPage].thumbnailUrl.hashCode.toString()];

        return Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            fileImg != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.file(
                      fileImg,
                      scale: 0.7,
                    ),
                  )
                : const LoadingWidget(),
            Padding(
              padding: const EdgeInsets.all(30),
              child: Text(
                state.photos[numPage].title,
                style: GoogleFonts.montserrat(
                    color: Colors.white,
                    //fontWeight: FontWeight.bold,
                    fontSize: 12),
              ),
            ),
          ],
        );
      },
    );
  }

  Center _textMessageState({required String message, String imgPath = ''}) {
    return Center(
      child: TextIconMessage(
        message: message,
        imgPath: imgPath,
      ),
    );
  }

  Center _loadingState() {
    return const Center(
      child: LoadingWidget(),
    );
  }
}
