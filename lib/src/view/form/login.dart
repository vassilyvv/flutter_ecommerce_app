import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormBuilderState>();
    final phoneNumberFieldKey = GlobalKey<FormBuilderFieldState>();
    final passwordFieldKey = GlobalKey<FormBuilderFieldState>();

    return FormBuilder(
      key: formKey,
      child: Column(children: [
        FormBuilderTextField(
          key: phoneNumberFieldKey,
          name: 'phone',
          decoration: const InputDecoration(labelText: 'Phone number'),
          onChanged: (val) {
            print(val); // Print the text value write into TextField
          },
        ),
        FormBuilderTextField(
          key: passwordFieldKey,
          name: 'text',
          obscureText: true,
          decoration: const InputDecoration(labelText: 'Password'),
          onChanged: (val) {
            print(val); // Print the text value write into TextField
          },
        ),
        ElevatedButton(
          child: const Text('Submit'),
          onPressed: () async {

          },
        ),
      ]),
    );
  }
}
