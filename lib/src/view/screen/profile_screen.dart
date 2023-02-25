import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/auth_controller.dart';
import '../form/login.dart';


final AuthController controller = Get.put(AuthController());

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Obx(() => controller.authenticatedUser.value == null ?  LoginForm():Text(controller.authenticatedUser.value!.phoneNumber!)),
        ],
      ),
    );
  }
}
