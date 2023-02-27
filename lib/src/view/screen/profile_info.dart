import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/auth_controller.dart';

final AuthController controller = Get.put(AuthController());

class ProfileInfo extends StatelessWidget {
  const ProfileInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(children:[Text(controller.authenticatedUser.value!.phoneNumber!), ElevatedButton(onPressed: (){controller.logout();}, child: Text("logout".tr))]);
  }
}
