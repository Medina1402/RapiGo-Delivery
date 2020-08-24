import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:rapigo/app/application.dart';
import 'package:rapigo/services/file_manager_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FileManagerService _fileManagerService = FileManagerService();
  String _routeDefaultHome = "/";

  String key = await _fileManagerService.readFile("temp.txt");
  if(key!=null) _routeDefaultHome = "/map";
  print(_routeDefaultHome);

  final Application app = Application(_routeDefaultHome);
  await Firebase.initializeApp();
  
  runApp(app);
}