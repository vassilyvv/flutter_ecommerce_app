import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/api/client.dart';
import '../../controller/auth_controller.dart';
import '../constants.dart';
import '../widget/fields/phone_number.dart';

final AuthController controller = Get.put(AuthController());

class ResetPasswordForm extends StatefulWidget {
  const ResetPasswordForm({super.key});

  @override
  State<StatefulWidget> createState() {
    return ResetPasswordFormState();
  }
}

class ResetPasswordFormState extends State<ResetPasswordForm> {
  bool byPhoneNumber = false;
  bool isSubmitted = false;

  @override
  Widget build(BuildContext context) {
    AutovalidateMode autovalidateMode = AutovalidateMode.disabled;

    final formKey = GlobalKey<FormState>();
    final phoneNumberController = TextEditingController();
    final emailController = TextEditingController();

    return Form(
        key: formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            isSubmitted
                ? Center(child: Text('password_reset_url_sent'.tr))
                : byPhoneNumber
                    ? PhoneNumberField(
                        controller: phoneNumberController,
                      )
                    : TextFormField(
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
                        autovalidateMode: autovalidateMode,
                      ),
            const SizedBox(height: 30),
            if (!isSubmitted)
              ElevatedButton(
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    APIClient()
                        .resetPassword(
                      byPhoneNumber ? phoneNumberController.text : null,
                      byPhoneNumber ? null : emailController.text,
                    )
                        .then(
                      (passwordResetResponse) {
                        if (passwordResetResponse.statusCode > 204) {
                          Get.snackbar(
                              snackPosition: SnackPosition.BOTTOM,
                              "unable_to_reset_password".tr,
                              passwordResetResponse.validationError!.tr,
                              colorText: Colors.black,
                              backgroundColor: const Color(0xFFEC6813));
                        } else {
                          setState(() => isSubmitted = true);
                        }
                      },
                    );
                  }
                },
                child: Text(
                  byPhoneNumber ? 'reset_by_sms'.tr : 'reset_by_email'.tr,
                ),
              ),
            if (!isSubmitted)
              ElevatedButton(
                onPressed: () => setState(() => byPhoneNumber = !byPhoneNumber),
                child: Text(
                  byPhoneNumber ? 'reset_by_email'.tr : 'reset_by_sms'.tr,
                ),
              ),
          ],
        ));
  }
}
