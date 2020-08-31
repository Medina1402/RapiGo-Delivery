import 'package:cloud_firestore/cloud_firestore.dart';

import '../firebase_provider.dart';

class Pedido {
  String id;
  bool disponible;
  bool entregado;
  bool recogido;
  Pedido({
    this.id,
    this.disponible,
    this.entregado,
    this.recogido,
  });
}


class PedidosModel {
  // ignore: non_constant_identifier_names
  static final Collection = FirebaseProvider.Collection("pedidos");

  static Future<List<Pedido>> findAll() async {
    List<Pedido> _pedidos = List();

    Collection.snapshots().listen((QuerySnapshot snapshot) {
      _pedidos = snapshot.docs.map((QueryDocumentSnapshot documentSnapshot) => Pedido(
          id: documentSnapshot.data()["id"],
          disponible: documentSnapshot.data()["disponible"],
          entregado: documentSnapshot.data()["entregado"],
          recogido: documentSnapshot.data()["recogido"]
      )).toList();
    });

    return _pedidos;
  }
}