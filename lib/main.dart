import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:rapigo/app/application.dart';

void main() async {
  final Application app = Application();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  
  runApp(app);
}