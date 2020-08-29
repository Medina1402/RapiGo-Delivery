import 'package:flutter/material.dart';

InputDecoration inputDecorationLogin(String hintText, Widget suffixIcon) {
  return InputDecoration(
    border: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(15.0)),
    ),
    fillColor: Colors.white,
    filled: true,
    hintStyle: TextStyle(color: Colors.grey, fontSize: 20),
    hintText: hintText,
    suffixIcon: suffixIcon,
  );
}
