import 'package:eclipse_test/data/models/form_fields/text_field.dart';
import 'package:eclipse_test/data/models/models_with_adapters.dart';
import 'package:eclipse_test/services/repository/global_repo.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

part 'send_comment_state.dart';

class CommentFieldCubit extends Cubit<CommentFieldsState> {
  final GlobalRepo repo;
  final Post post;
  CommentFieldCubit({required this.repo, required this.post})
      : super(const CommentFieldsState.empty());

  Future<void> emailChanged(String val) async {
    const regExp = CommentFieldsState.emailReg;
    final email = TextField.dirty(value: val, regExp: regExp);
    emit(state.copyWith(
        email: email.valid ? email : TextField.pure(value: val, regExp: regExp),
        state: Formz.validate([email, state.name, state.comment])));
  }

  Future<void> nameChanged(String val) async {
    const regExp = CommentFieldsState.nameReg;
    final name = TextField.dirty(value: val, regExp: regExp);
    emit(state.copyWith(
        name: name.valid ? name : TextField.pure(value: val, regExp: regExp),
        state: Formz.validate([name, state.email, state.comment])));
  }

  Future<void> commentChanged(String val) async {
    const regExp = CommentFieldsState.commentReg;
    final comment = TextField.dirty(value: val, regExp: regExp);
    emit(state.copyWith(
        comment: comment.valid
            ? comment
            : TextField.pure(value: val, regExp: regExp),
        state: Formz.validate([comment, state.name, state.email])));
  }

  Future<void> emailUnfocus() async {
    const regExp = CommentFieldsState.emailReg;
    final email = TextField.dirty(value: state.email.value, regExp: regExp);
    emit(state.copyWith(
        email: email,
        state: Formz.validate([email, state.name, state.comment])));
  }

  Future<void> nameUnfocus() async {
    const regExp = CommentFieldsState.nameReg;
    final name = TextField.dirty(value: state.name.value, regExp: regExp);
    emit(state.copyWith(
        name: name, state: Formz.validate([name, state.email, state.comment])));
  }

  Future<void> commentUnfocus() async {
    const regExp = CommentFieldsState.commentReg;
    final comment = TextField.dirty(value: state.comment.value, regExp: regExp);
    emit(state.copyWith(
        comment: comment,
        state: Formz.validate([comment, state.name, state.email])));
  }

  Future<void> clearInput() async {
    emit(const CommentFieldsState.empty());
  }

  Future<void> submitForm() async {
    const regExpEmail = CommentFieldsState.emailReg;
    const regExpName = CommentFieldsState.nameReg;
    const regExpComment = CommentFieldsState.commentReg;

    final comment =
        TextField.dirty(value: state.comment.value, regExp: regExpComment);
    final name = TextField.dirty(value: state.name.value, regExp: regExpName);
    final email =
        TextField.dirty(value: state.email.value, regExp: regExpEmail);
    emit(state.copyWith(
        comment: comment,
        name: name,
        email: email,
        state: Formz.validate([comment, name, email])));
    if (state.state.isValidated) {
      emit(state.copyWith(state: FormzStatus.submissionInProgress));
      PostComment resultComment = PostComment(
          postId: post.id,
          id: -1,
          name: name.value,
          email: email.value,
          body: comment.value);
      bool res =
          await repo.postComment(postId: post.id, comment: resultComment);
      if (isClosed) return;
      //print('**** VALIDATED ****');
      if (res) {
        emit(state.copyWith(state: FormzStatus.submissionSuccess));
      } else {
        emit(state.copyWith(state: FormzStatus.submissionFailure));
      }
      clearInput();
    }
  }
}
