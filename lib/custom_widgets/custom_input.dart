import 'package:flutter/material.dart';

class CustomInput extends StatelessWidget {
  const CustomInput(
      {super.key,
      required this.labelName,
      this.textStyle = const TextStyle(
          fontSize: 16, color: Color.fromARGB(255, 197, 197, 203)),
      required this.textFormField});

  final String labelName;
  final TextStyle textStyle;
  final TextFormField textFormField;

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(labelName, style: textStyle),
          const SizedBox(height: 6),
          textFormField
        ]);
  }
}
