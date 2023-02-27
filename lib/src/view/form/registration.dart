import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/auth_controller.dart';
import '../constants.dart';
import '../widget/fields/phone_number.dart';

final AuthController controller = Get.put(AuthController());

class RegistrationForm extends StatefulWidget {
  const RegistrationForm({super.key});

  @override
  State<StatefulWidget> createState() {
    return RegistrationFormState();
  }
}

class RegistrationFormState extends State<RegistrationForm> {
  final formKey = GlobalKey<FormState>();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController password1Controller = TextEditingController();
  TextEditingController password2Controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          PhoneNumberField(controller: phoneNumberController),
          TextFormField(
            decoration: InputDecoration(labelText: 'first_name'.tr),
            controller: firstNameController,
            keyboardType: TextInputType.name,
            validator: (value) {
              if (value!.isEmpty) {
                return 'enter_first_name'.tr;
              }
              return null;
            },
          ),
          TextFormField(
            decoration: InputDecoration(labelText: 'last_name'.tr),
            controller: lastNameController,
            keyboardType: TextInputType.name,
            validator: (value) {
              if (value!.isEmpty) {
                return 'enter_last_name'.tr;
              }
              return null;
            },
          ),
          TextFormField(
            decoration: InputDecoration(labelText: 'email'.tr),
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value!.isEmpty) {
                return 'enter_email'.tr;
              }
              if (!RegExp(emailRegex).hasMatch(value)) {
                return 'invalid_email'.tr;
              }
              return null;
            },
          ),
          TextFormField(
            decoration: InputDecoration(labelText: 'password1'.tr),
            obscureText: true,
            controller: password1Controller,
            validator: (value) {
              if (value!.isEmpty) {
                return 'enter_password'.tr;
              }
              return null;
            },
          ),
          TextFormField(
              decoration: InputDecoration(labelText: 'password2'.tr),
              obscureText: true,
              controller: password2Controller,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'enter_password'.tr;
                }
                if (value != password1Controller.text) {
                  return 'passwords_dont_match'.tr;
                }
                return null;
              }),
          const SizedBox(height: 30),
          ElevatedButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                apiClient
                    .register(
                        firstNameController.text,
                        lastNameController.text,
                        phoneNumberController.text,
                        emailController.text,
                        password2Controller.text)
                    .then((registerResponse) {
                  if (registerResponse.statusCode == 201) {
                    controller.authenticate(phoneNumberController.text,
                        password1Controller.text, null);
                  } else {
                    Get.snackbar(
                        snackPosition: SnackPosition.BOTTOM,
                        "unable_to_register".tr,
                        registerResponse.validationErrors.values.toList()[0].tr,
                        colorText: Colors.black,
                        backgroundColor: const Color(0xFFEC6813));
                  }
                });
              }
            },
            child: Text('register'.tr),
          ),
        ],
      ),
    );
  }
}
