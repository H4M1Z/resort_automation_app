import 'package:form_validation/form_validation.dart';

//.......EMAIL VALIDATION FOR LOGIN AND SIGNUP
String? emailValidation(String? value) {
  final validator = Validator(
    validators: [
      const RequiredValidator(),
      const EmailValidator(),
    ],
  );

  return validator.validate(
    label: 'Email',
    value: value,
  );
}

//.......PASSWORD VALIDATION FOR LOGIN AND SIGNUP

String? passwordValidation(String? value) {
  final validator = Validator(
    validators: [
      const RequiredValidator(),
    ],
  );

  return validator.validate(
    label: 'Password',
    value: value,
  );
}
