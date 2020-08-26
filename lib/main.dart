import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:rapigo/app/application.dart';
import 'package:rapigo/database/sqflite_provider.dart';
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

  /**
   * Test Sqflite
   */
  UserRapigoDB user = UserRapigoDB("1a", "Medina", 0, 0);
  int _userInsert = await SqfliteProvider.insert(user);
  print(">>>> Insert $_userInsert");

  UserRapigoDB _query = await SqfliteProvider.data;
  print(">>>> Query ${_query.toString()}");

  UserRapigoDB user2 = UserRapigoDB(user.id, user.name, 1, user.all_show);
  int _updateUser2 = await SqfliteProvider.update(user2);
  print(">>>> updateUser2 $_updateUser2");

  UserRapigoDB _query2 = await SqfliteProvider.data;
  print(">>>> Query2 ${_query2.toString()}");

  int _remove = await SqfliteProvider.delete(user.id);
  print(">>>> Remove $_remove");

  print(">>>> All query =>>> ${await SqfliteProvider.data}");

  runApp(app);
}