// ignore_for_file: public_member_api_docs, sort_constructors_first

part of 'send_comment_cubit.dart';

enum CommentFormStates {
  formSubmit,
  emailChanged,
  nameChanged,
  commentChanged,
  fieldUnfocus
}

class CommentFieldsState extends Equatable {
  final FormzStatus state;
  final TextField name;
  final TextField email;
  final TextField comment;

  static const String nameReg = r'^[a-zA-ZА-Яа-яёЁ ]+$';
  static const String emailReg =
      r'^[a-zA-Z0-9.-_]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)+$';
  static const String commentReg = r'^[a-zA-ZА-Яа-яёЁ1-9,.!?;: ]+$';

  const CommentFieldsState._({
    this.state = FormzStatus.pure,
    this.name = const TextField.pure(regExp: nameReg),
    this.email = const TextField.pure(regExp: emailReg),
    this.comment = const TextField.pure(regExp: commentReg),
  });
  const CommentFieldsState.empty() : this._();
  //const CommentFieldsState.emailChanged(String email) : this._(email: email);

  @override
  List<Object> get props => [state, name, email, comment];

  CommentFieldsState copyWith({
    FormzStatus? state,
    TextField? name,
    TextField? email,
    TextField? comment,
  }) {
    return CommentFieldsState._(
      state: state ?? this.state,
      name: name ?? this.name,
      email: email ?? this.email,
      comment: comment ?? this.comment,
    );
  }
}
