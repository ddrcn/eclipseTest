import 'package:eclipse_test/bloc/cubit/post_comments/comments_cubit.dart';
import 'package:eclipse_test/bloc/cubit/send_comment/send_comment_cubit.dart';
import 'package:eclipse_test/data/utils/app_theme.dart';
import 'package:eclipse_test/services/repository/global_repo.dart';
import 'package:eclipse_test/ui/widgets/loading_widget.dart';
import 'package:eclipse_test/ui/widgets/text_icon_message.dart';
import 'package:flutter/material.dart';

import 'package:eclipse_test/data/models/post.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:google_fonts/google_fonts.dart';

// Страница конкретного поста пользователя с комментариями
class PostScreen extends StatelessWidget {
  const PostScreen({Key? key, required this.post, required this.tagName})
      : super(key: key);
  final Post post;
  final String tagName;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              CommentsCubit(post: post, repo: context.read<GlobalRepo>())
                ..getComments(),
        ),
        BlocProvider(
          create: (context) =>
              CommentFieldCubit(repo: context.read<GlobalRepo>(), post: post),
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Post #${post.id}',
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
            child: Builder(builder: (context) {
              return BlocListener<CommentFieldCubit, CommentFieldsState>(
                listener: (context, state) {
                  if (state.state.isSubmissionSuccess) {
                    context.read<CommentsCubit>().getComments();
                    SnackBar snackBar = SnackBar(
                        duration: const Duration(seconds: 1),
                        backgroundColor: Colors.green[300],
                        content: const Text(
                          'Комментарий успешно добавлен!',
                          textAlign: TextAlign.center,
                        ));
                    // ignore: use_build_context_synchronously
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  }
                  if (state.state.isSubmissionFailure) {
                    context.read<CommentsCubit>().getComments();
                    SnackBar snackBar = SnackBar(
                        duration: const Duration(seconds: 1),
                        backgroundColor: Colors.red[300],
                        content: const Text(
                          'Ошибка при отправке комментария!',
                          textAlign: TextAlign.center,
                        ));
                    // ignore: use_build_context_synchronously
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  }
                  if (state.state.isSubmissionInProgress) {
                    Navigator.pop(context);
                  }
                },
                child: Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Text(
                                post.title,
                                style: GoogleFonts.montserrat(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 20, right: 10),
                              child: Text(
                                post.body,
                                style: GoogleFonts.montserrat(
                                    color: Colors.white, fontSize: 13),
                              ),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            const Divider(
                              color: Colors.white70,
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            const PostComments(),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20.0, top: 20.0),
                      child: ElevatedButton(
                          onPressed: () {
                            showAddingCommentDialog(context);
                          },
                          child: const Text('Добавить комментарий')),
                    ),
                  ],
                ),
              );
            }),
          ),
        ),
      ),
    );
  }

  ///Открыть диалог добавления комментария к посту
  void showAddingCommentDialog(BuildContext context) {
    showDialog<void>(
        context: context,
        builder: (_) {
          final blocField = BlocProvider.of<CommentFieldCubit>(context);
          //print(blocField.state.state);
          final emailFocusNode = FocusNode();
          final nameFocusNode = FocusNode();
          final commentFocusNode = FocusNode();
          emailFocusNode.addListener(() {
            if (!emailFocusNode.hasFocus) {
              blocField.emailUnfocus();
            }
          });
          nameFocusNode.addListener(() {
            if (!nameFocusNode.hasFocus) {
              blocField.nameUnfocus();
              // FocusScope.of(context)
              //     .requestFocus(emailFocusNode);
            }
          });
          commentFocusNode.addListener(() {
            if (!commentFocusNode.hasFocus) {
              blocField.commentUnfocus();
            }
          });
          return BlocBuilder<CommentFieldCubit, CommentFieldsState>(
            bloc: blocField,
            builder: (context, state) {
              return SimpleDialog(
                // backgroundColor:
                //     getThemeData(context).backgroundColor,
                title: Text(
                  'Оставить комментарий',
                  style: GoogleFonts.montserrat(
                      color: Colors.black87,
                      //fontWeight: FontWeight.bold,
                      fontSize: 12),
                ),
                children: [
                  SimpleDialogOption(
                      child: TextFormField(
                          onChanged: (value) {
                            blocField.nameChanged(value);
                          },
                          initialValue: state.name.value,
                          focusNode: nameFocusNode,
                          maxLength: 30,
                          style: GoogleFonts.montserrat(
                              color: Colors.black,
                              //fontWeight: FontWeight.bold,
                              fontSize: 13),
                          decoration: InputDecoration(
                            errorMaxLines: 2,
                            errorText: state.name.invalid
                                ? 'Имя должно содержать только буквы'
                                : null,
                            border: const OutlineInputBorder(),
                            labelText: 'Имя',
                          ))),
                  SimpleDialogOption(
                      child: TextFormField(
                          onChanged: (value) {
                            blocField.emailChanged(value);
                          },
                          initialValue: state.email.value,
                          maxLength: 30,
                          focusNode: emailFocusNode,
                          style: GoogleFonts.montserrat(
                              color: Colors.black,
                              //fontWeight: FontWeight.bold,
                              fontSize: 13),
                          decoration: InputDecoration(
                            errorMaxLines: 2,
                            errorText: state.email.invalid
                                ? 'Введите корректный адрес электронной почты'
                                : null,
                            border: const OutlineInputBorder(),
                            labelText: 'Email',
                          ))),
                  SimpleDialogOption(
                      child: TextFormField(
                          onChanged: (value) {
                            blocField.commentChanged(value);
                          },
                          initialValue: state.comment.value,
                          focusNode: commentFocusNode,
                          style: GoogleFonts.montserrat(
                              color: Colors.black,
                              //fontWeight: FontWeight.bold,
                              fontSize: 13),
                          maxLines: 5,
                          maxLength: 100,
                          decoration: InputDecoration(
                            errorMaxLines: 2,
                            errorText: state.comment.invalid
                                ? 'Некорректные символы'
                                : null,
                            border: const OutlineInputBorder(),
                            labelText: 'Комментарий',
                          ))),
                  SimpleDialogOption(
                      child: ElevatedButton(
                    child: const Text('Отправить комментарий'),
                    onPressed: () {
                      blocField.submitForm();
                    },
                  )),
                  SimpleDialogOption(
                      child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red[500]),
                    child: const Text('Очистить и закрыть'),
                    onPressed: () {
                      blocField.clearInput();
                      Navigator.pop(context);
                    },
                  )),
                ],
              );
            },
          );
        });
  }
}

class PostComments extends StatelessWidget {
  const PostComments({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Center(
          child: Text(
            //maxLines: 1,
            //overflow: TextOverflow.ellipsis,
            'comments:',
            style: GoogleFonts.montserrat(color: Colors.white70, fontSize: 15),
          ),
        ),
        const SizedBox(
          height: 8,
        ),
        const CommentsList(),
      ],
    );
  }
}

class CommentsList extends StatelessWidget {
  const CommentsList({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        BlocBuilder<CommentsCubit, CommentsState>(
          builder: (context, state) {
            switch (state.state) {
              case CommentStates.loading:
                return _loadingState();
              case CommentStates.empty:
                return _textMessageState(
                    message: 'Комментарии к посту отсутствуют...',
                    imgPath: 'assets/no-data.png');
              case CommentStates.loaded:
                return _loadedState(state);
              case CommentStates.error:
                return _textMessageState(
                    message: 'Ошибка при загрузке комментариев...',
                    imgPath: 'assets/sorry_error.png');
              default:
                return _textMessageState(
                    message: 'Ошибка при загрузке комментариев...',
                    imgPath: 'assets/sorry_error.png');
            }
          },
        ),
      ],
    );
  }

  ListView _loadedState(CommentsState state) {
    return ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: state.comments.length,
        itemBuilder: (context, index) {
          return Card(
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
                  padding: const EdgeInsets.only(left: 15, bottom: 5, top: 10),
                  child: Text(
                    state.comments[index].name.toUpperCase(),
                    style: GoogleFonts.montserrat(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 15),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: Text(
                    state.comments[index].email,
                    style: GoogleFonts.montserrat(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 15),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: Text(
                    state.comments[index].body,
                    style: GoogleFonts.montserrat(
                        color: Colors.white, fontSize: 13),
                  ),
                ),
              ],
            ),
          );
        });
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
