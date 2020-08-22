import 'package:flutter/material.dart';
import 'package:rapigo/screen/login_screen.dart';
import 'package:rapigo/screen/map_screen.dart';

// ignore: non_constant_identifier_names
final Map<String, WidgetBuilder> Routes = {
  "/": (BuildContext context) => LoginScreen(),
  "/map": (BuildContext context) => MapScreen(),
};