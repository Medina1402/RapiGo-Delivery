import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rapigo/database/firebase_provider.dart';

class UserPosition {
  String id;
  GeoPoint position;
  UserPosition(this.id, this.position);

  get json {
    return {
      "id": this.id,
      "position": this.position,
      "visible": true
    };
  }
}

class UserPositionModel {
  // ignore: non_constant_identifier_names
  static final Collection = FirebaseProvider.Collection("usuarios");

  static create(UserPosition _userPosition) async {
    await Collection.doc(_userPosition.id).set(_userPosition.json);
  }

  static void disconnect(String idDoc) async {
    await Collection.doc(idDoc).delete();
  }
}