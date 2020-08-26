import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class UserRapigoDB {
  final String id;
  final String name;
  // ignore: non_constant_identifier_names
  final int local_show;
  // ignore: non_constant_identifier_names
  final int all_show;

  UserRapigoDB(this.id, this.name, this.local_show, this.all_show);

  @override
  String toString() {
    return "UserRapigo{id: $id, name: $name, local_show: $local_show, all_show: $all_show}";
  }

  Map<String, dynamic> get toMap {
    return {
      "id": this.id,
      "name": this.name,
      "local_show": this.local_show,
      "all_show": this.all_show,
    };
  }
}

class SqfliteProvider {
  // ignore: non_constant_identifier_names
  static final String DBName = "rapigo_database";
  static final String _table = "user";

  /*
   * Connection DB
   */
  // ignore: non_constant_identifier_names
  static Future<Database> get CONNECT async {
    return openDatabase(
        join(await getDatabasesPath(), "$DBName.db"),
        onCreate: (Database db, int version) => db.execute(
            "CREATE TABLE $_table(id TEXT PRIMARY KEY, name TEXT, local_show INTEGER, all_show INTEGER)"
        ),
        version: 1,
    );
  }

  /*
   * Insert field in table of DB
   */
  static Future<int> insert(UserRapigoDB user) async {
    final Database _db = await CONNECT;
    return await _db.insert(
        _table,
        user.toMap,
    );
  }

  /*
   * Get One UserRapigoDB
   */
  static Future<UserRapigoDB> get data async {
    final Database _db = await CONNECT;
    final Map<String, dynamic> _query = (await _db.query(_table)).first;
    return UserRapigoDB(
      _query["id"],
      _query["name"],
      _query["local_show"],
      _query["all_show"],
    );
  }

  /*
   * Update UserRapigo
   */
  static Future<int> update(UserRapigoDB user) async {
    final Database _db = await CONNECT;
    return await _db.update(
        _table,
        user.toMap,
        where: "id = ?",
        whereArgs: [user.id],
    );
  }

  /*
   * Remove field User
   */
  static Future<int> delete(String id) async {
    final Database _db = await CONNECT;
    return await _db.delete(
        _table,
        where: "id = ?",
        whereArgs: [id],
    );
  }
}