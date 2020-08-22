import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseProvider {
  // ignore: non_constant_identifier_names
  static CollectionReference Collection (String collection) {
    return FirebaseFirestore.instance.collection(collection);
  }
}