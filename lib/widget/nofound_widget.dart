import 'package:flutter/material.dart';

errorWindow(BuildContext context, String message, Widget _container) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text("¡Error de registro!"),
        content: (_container == null)
            ? Row(
                children: [
                  Icon(
                    Icons.error_outline,
                    color: Colors.orange,
                  ),
                  Text(message),
                ],
              )
            : _container,
        elevation: 24,
        backgroundColor: Colors.white,
      );
    },
    barrierDismissible: true,
  );
}
