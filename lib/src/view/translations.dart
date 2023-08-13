import 'package:get/get.dart';

class AppTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
    'en_US': {
      'first_name': 'First name',
      'reset_password': 'Reset password',
      'reset_by_sms': 'Reset by SMS',
      'reset_by_email': 'Reset by email',
      'enter_first_name': 'Enter first name',
      'last_name': 'Last name',
      'enter_last_name': 'Enter last name',
      'email': 'Email',
      'search_query': 'Search',
      'enter_email': 'Enter email',
      'phone_number': 'Phone number',
      'enter_phone_number': 'Enter phone number',
      'invalid_email': 'Invalid email',
      'password1': 'Password',
      'password2': 'Repeat password',
      'enter_password': 'Enter password',
      'passwords_not_match': 'Passwords not match',
      'register': 'Register',
      'login': 'Log in',
      'unable_to_login': 'Unable to log in',
      'invalid_credentials': 'Invalid credentials',
    },
    'ru_RU': {
      'first_name': 'Имя',
      'reset_password': 'Восстановить пароль',
      'reset_by_sms': 'Восстановить по SMS',
      'reset_by_email': 'Восстановить по Email',
      'enter_first_name': 'Введите имя',
      'last_name': 'Фамилия',
      'enter_last_name': 'Введите фамилию',
      'email': 'Email',
      'enter_email': 'Введите email',
      'phone_number': 'Номер телефона',
      'enter_phone_number': 'Введите номер телефона',
      'invalid_email': 'Неверный email',
      'password1': 'Пароль',
      'password2': 'Повторите пароль',
      'enter_password': 'Введите пароль',
      'passwords_not_match': 'Пароли не совпадают',
      'register': 'Зарегистрироваться',
      'register': 'Войти',
      'unable_to_login': 'Не получилось войти',
      'invalid_credentials': 'Неправильный логин или пароль',
    }
  };
}