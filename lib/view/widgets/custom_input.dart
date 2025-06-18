import 'package:flutter/material.dart';

class CustomInput extends StatelessWidget {
  final String label;
  final IconData icon;
  final TextEditingController controller;
  final bool obscureText;
  final Widget? suffix;

  const CustomInput({
    super.key,
    required this.label,
    required this.icon,
    required this.controller,
    this.obscureText = false,
    this.suffix,
  });

  @override
  Widget build(BuildContext context) {
    final textColor = Theme.of(context).textTheme.bodyLarge?.color;
    final hintColor = Theme.of(context).hintColor;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 12, color: hintColor)),
        TextField(
          controller: controller,
          obscureText: obscureText,
          style: TextStyle(color: textColor),
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: hintColor),
            suffixIcon: suffix,
            hintStyle: TextStyle(color: hintColor),
            border: const UnderlineInputBorder(),
          ),
        ),
        const SizedBox(height: 15),
      ],
    );
  }
}
