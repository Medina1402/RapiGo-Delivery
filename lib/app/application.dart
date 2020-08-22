import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rapigo/app/router.dart';

class Application extends StatelessWidget {
  void afterBuild() {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.transparent));
  }

  // ===========================================================================

  @override
  Widget build(BuildContext context) {
    afterBuild();

    return MaterialApp(
      title: "RapiGo Delivery",
      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      debugShowCheckedModeBanner: false,
      routes: Routes,
    );
  }
}