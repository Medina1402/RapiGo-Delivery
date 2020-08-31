import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CardDeliver extends StatelessWidget {
  final item;
  final onPressMap;
  final onPressDelivery;

  CardDeliver({
    this.item,
    this.onPressMap,
    this.onPressDelivery
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      key: Key("${item["id"]}"),
      margin: EdgeInsets.fromLTRB(30, 20, 30, 20),
      child: Padding(
        padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
        child: Column(
          children: [
            Text("${item["nombre"]}"),
            Text((item["createdAt"] as Timestamp).toDate().toString()),
            Text("Entrega: ${item["direccion"]}"),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Tiempo aprox: x min", style: TextStyle(fontSize: 15),),
                MaterialButton(
                  elevation: 0,
                  color: Colors.blue,
                  child: Text("Ver en mapa"),
                  onPressed: this.onPressMap,
                ),
              ],
            ),
            MaterialButton(
              minWidth: double.infinity,
              color: Colors.blue,
              child: Text("Aceptar pedido"),
              onPressed: onPressDelivery,
            ),
          ],
        ),
      ),
    );
  }
}