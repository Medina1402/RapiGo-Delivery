import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rapigo/app/router.dart';

// ignore: must_be_immutable
class Application extends StatelessWidget {
  String routeDefault;
  Application({this.routeDefault});

  void afterBuild() async {
    await Firebase.initializeApp();
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.transparent));
  }

  // ===========================================================================

  @override
  Widget build(BuildContext context) {
    afterBuild();

    return MaterialApp(
      title: "RapiGo Delivery",
//      debugShowMaterialGrid: true,
      debugShowCheckedModeBanner: false,
      routes: Routes,
      initialRoute: this.routeDefault,
    );
  }
}