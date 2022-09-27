import 'package:formz/formz.dart';

enum TextFieldValidationError { invalid }

class TextField extends FormzInput<String, TextFieldValidationError> {
  const TextField.pure({required this.regExp, String value = ''})
      : super.pure(value);
  const TextField.dirty({required this.regExp, String value = ''})
      : super.dirty(value);

  final String regExp;

  @override
  TextFieldValidationError? validator(String? value) {
    final regExpression = RegExp(regExp);
    return regExpression.hasMatch(value ?? '')
        ? null
        : TextFieldValidationError.invalid;
  }
}
