import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rapigo/database/firebase_provider.dart';

class User {
  String phone;
  String password;

  User(this.phone, this.password);

  get json {
    return  {
      phone: this.phone,
      password: this.password,
    };
  }
}

class UserModel {
  // ignore: non_constant_identifier_names
  static final Collection = FirebaseProvider.Collection("repartidores");

  /*
   * Find one user and return data
   */
  static findOne(String phone) async {
    try {
      QuerySnapshot querySnapshot = await Collection.where("phone", isEqualTo: phone.toString()).get();
      return querySnapshot.docs.first.data();
    } catch (e) {
      return null;
    }
  }

  /*
   * Find one user and compare password
   */
  static Future<String> login(String _phone, String _password) async {
    if(_phone == null || _phone.length <= 0) return null;
    var _user = await findOne(_phone);
    if(_user == null || _user["password"] != _password) return null;
    return _user["id"];
  }


  static create(User _user) async {
    String _key = Collection.doc().id;
    Collection.doc(_key).set(_user.json);
    return _key;
  }
}