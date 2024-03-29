import 'package:flutter/material.dart';

class SectionText extends StatelessWidget {
  String text;
  Color textColor;

  SectionText({super.key, required this.text, required this.textColor});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
          fontSize: 18, color: textColor, fontWeight: FontWeight.w800),
    );
  }
}
