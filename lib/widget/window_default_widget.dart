import 'package:flutter/material.dart';

// ignore: non_constant_identifier_names
ErrorWindows( final BuildContext context, final Widget title, final Widget container, final List<dynamic> actions){
     showDialog(
      barrierDismissible: true,
      context: context,
      builder: (context) {
        return AlertDialog(
          title: title,
          elevation: 24,
          backgroundColor: Colors.white,
          actions: actions,
          content: container
        );
      },
    );
}
