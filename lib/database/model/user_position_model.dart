import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rapigo/database/firebase_provider.dart';

class UserPosition {
  String id;
  GeoPoint position;
  UserPosition(this.id, this.position);
}

class UserPositionModel {
  // ignore: non_constant_identifier_names
  static final Collection = FirebaseProvider.Collection("usuarios");
}