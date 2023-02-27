import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/auth_controller.dart';

final AuthController controller = Get.put(AuthController());

class LoginForm extends StatelessWidget {
  const LoginForm({super.key});

  @override
  Widget build(BuildContext context) {
    final phoneNumberController = TextEditingController();
    final passwordController = TextEditingController();

    return Form(
      child: Column(children: [
        TextField(
            decoration: InputDecoration(labelText: 'phone_number'.tr),
            controller: phoneNumberController),
        TextField(
          obscureText: true,
          decoration: InputDecoration(labelText: 'password1'.tr),
          controller: passwordController,
        ),
        MaterialButton(
          color: Colors.deepOrange,
          textColor: Colors.white,
          onPressed: () async {
            controller.authenticate(
                phoneNumberController.text, passwordController.text, null);
          },
          child: Text('login'.tr),
        ),
      ]),
    );
  }
}
