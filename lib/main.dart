import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:rapigo/app/application.dart';

void main() async {
  final Application app = Application();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  /**
   *
   */
  runApp(app);
}

/*
  void _query() async {
    final QuerySnapshot query = await FirebaseFirestore.instance.collection("usuarios").get();
    query.docs.forEach((element) {
      GeoPoint x = element.data()["position"];
      print("lat: ${x.latitude}, lng: ${x.longitude}");
    });
  }
*/