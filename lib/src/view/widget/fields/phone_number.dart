import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PhoneNumberField extends StatelessWidget {
  final TextEditingController controller;
  final void Function(String newValue)? onValueChanged;

  const PhoneNumberField(
      {Key? key, required this.controller, this.onValueChanged})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      key: key,
      keyboardType: TextInputType.phone,
      onChanged: (newValue) {
        newValue = newValue.replaceAll(RegExp(r'\D'), '');
        controller.text = '+$newValue';
        controller.selection = TextSelection.fromPosition(
            TextPosition(offset: controller.text.length));
        onValueChanged?.call(controller.text);
      },
      decoration: InputDecoration(labelText: 'phone_number'.tr),
      controller: controller,
      validator: (value) {
        if (value!.isEmpty) {
          return 'enter_phone_number'.tr;
        }
        return null;
      },
    );
  }
}
