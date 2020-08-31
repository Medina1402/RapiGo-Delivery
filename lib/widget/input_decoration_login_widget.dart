import 'package:flutter/material.dart';

class InputDecorationField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final suffixIcon;
  final bool visibleText;
  final decoration;

  InputDecorationField({
    this.hintText,
    this.visibleText = false,
    this.suffixIcon,
    this.controller,
    this.decoration
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
      child: TextField(
        enableInteractiveSelection: false,
        controller: this.controller,
        obscureText: this.visibleText,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(15.0)),
          ),
          fillColor: Colors.white,
          filled: true,
          hintStyle: TextStyle(color: Colors.grey, fontSize: 20),
          hintText: this.hintText,
          suffixIcon: this.suffixIcon,
        ),
      ),
    );
  }
}