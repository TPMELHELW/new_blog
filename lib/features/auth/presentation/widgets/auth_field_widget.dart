import 'package:flutter/material.dart';

class AuthFieldWidget extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final bool isObscure;
  const AuthFieldWidget({
    super.key,
    required this.hintText,
    required this.controller,
    this.isObscure = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        // border: OutlineInputBorder(),/
      ),
      validator: (String? value) {
        if (value!.isEmpty) {
          return "$hintText is Empty";
        }
        return null;
      },
      obscureText: isObscure,
    );
  }
}
