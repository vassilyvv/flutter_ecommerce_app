import 'package:very_supply_mobile_marketplace_1/src/view/screen/profile_info.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/auth_controller.dart';
import '../form/login.dart';
import '../form/registration.dart';
import '../form/reset_password.dart';

final AuthController controller = Get.put(AuthController());

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return AuthScreenState();
  }
}

class AuthScreenState extends State<AuthScreen> {
  String currentForm = 'login';

  Widget _registrationFormScreen() {
    return Column(children: [
      const RegistrationForm(),
      MaterialButton(
          child: Text("login".tr),
          onPressed: () {
            setState(() {
              currentForm = 'login';
            });
          })
    ]);
  }

  Widget _loginFormScreen() {
    return Column(children: [
      const LoginForm(),
      MaterialButton(
          child: Text("register".tr),
          onPressed: () {
            setState(() {
              currentForm = 'register';
            });
          }),
      MaterialButton(
          child: Text("reset_password".tr),
          onPressed: () {
            setState(() {
              currentForm = 'reset_password';
            });
          })
    ]);
  }

  Widget _resetPasswordFormScreen() {
    return Column(children: [
      const ResetPasswordForm(),
      MaterialButton(
          child: Text("login".tr),
          onPressed: () {
            setState(() {
              currentForm = 'login';
            });
          })
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Obx(() => Center(
            child: SizedBox(
                width: 300,
                child: controller.authenticatedUser.value != null
                    ? const ProfileInfo()
                    : currentForm == 'register'
                        ? _registrationFormScreen()
                        : currentForm == 'login'
                            ? _loginFormScreen()
                            : currentForm == 'reset_password'
                                ? _resetPasswordFormScreen()
                                : const Text('invalid form'))))
      ],
    ));
  }
}
