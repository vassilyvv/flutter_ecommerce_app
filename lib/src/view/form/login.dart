import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';

import '../../controller/auth_controller.dart';

final AuthController controller = Get.put(AuthController());

class LoginForm extends StatelessWidget {
  const LoginForm({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormBuilderState>();
    final phoneNumberFieldKey = GlobalKey<FormBuilderFieldState>();
    final passwordFieldKey = GlobalKey<FormBuilderFieldState>();
    final phoneNumberController = TextEditingController();
    final passwordController = TextEditingController();

    return FormBuilder(
      key: formKey,
      child: Column(children: [
        FormBuilderTextField(
          key: phoneNumberFieldKey,
          name: 'phone',
          decoration: const InputDecoration(labelText: 'Phone number'),
          controller: phoneNumberController
        ),
        FormBuilderTextField(
          key: passwordFieldKey,
          name: 'text',
          obscureText: true,
          decoration: const InputDecoration(labelText: 'Password'),
          controller: passwordController,
        ),
        ElevatedButton(
          child: const Text('Submit'),
          onPressed: () async {
            controller.authenticate(phoneNumberController.text, passwordController.text, null);
          },
        ),
      ]),
    );
  }
}
