import 'package:flutter/material.dart';
import 'package:rapigo/database/model/user_model.dart';
import 'package:rapigo/database/sqflite_provider.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _LoginScreen();
}

class _LoginScreen extends State<LoginScreen> {
  TextEditingController _username = TextEditingController();
  TextEditingController _password = TextEditingController();

  // ===========================================================================

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _username.dispose();
    _password.dispose();
    super.dispose();
  }

  // ===========================================================================

  /*
   *
   */
  _help(BuildContext context) async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Ayuda"),
          content: Container(
            height: 120,
            child: Column(
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.help,
                      color: Colors.orange,
                    ),
                    Text("  Cualquier duda o aclaracion"),
                  ],
                ),
                Text("\n\nabraham.medina.carrillo@uabc.edu.mx"),
              ],
            ),
          ),
          elevation: 24,
          backgroundColor: Colors.white,
        );
      },
      barrierDismissible: true,
    );
  }

  /*
   *
   */
  _userFind(String key) async {
    await SqfliteProvider.delete(key);
    await SqfliteProvider.insert(UserRapigoDB(key, _username.text, 0, 0));

    _username.clear();
    _password.clear();
    Navigator.pushReplacementNamed(context, "/map");
  }

  /*
   *
   */
  _notFound(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("¡Error de registro!"),
          content: Row(
            children: [
              Icon(
                Icons.error_outline,
                color: Colors.orange,
              ),
              Text(message),
            ],
          ),
          elevation: 24,
          backgroundColor: Colors.white,
        );
      },
      barrierDismissible: true,
    );
  }

  /*
   *
   */
  _validateUser(BuildContext context) async {
    if (_username.text.length <= 0 || _password.text.length <= 0) {
      _notFound(context, "  Debes llenar todos los datos");
      return null;
    }

    String _key = await UserModel.login(_username.text, _password.text);
    if (_key != null) {
      await _userFind(_key);
      return null;
    }

    _notFound(context, "  Usuario no encontrado");
  }

  // ===========================================================================

  bool _showPwd = true;
  final double _padding = 20;

  /*
   * Toggle show password
   */
  void showPwd() {
    setState(() {
      _showPwd = !_showPwd;
    });
  }

  // ===========================================================================

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
//              Image(
//                image: AssetImage('assets/images/bg.jpg'),
//                width: double.infinity,
//                height: double.infinity,
//                fit: BoxFit.cover,
//              ),
        Scaffold(
          floatingActionButton: MaterialButton(
            minWidth: double.minPositive,
            elevation: 0,
            child: Icon(
              Icons.help_outline,
              color: Colors.black54,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(100),
            ),
            onPressed: () => _help(context),
          ),
          backgroundColor: Colors.transparent,
          body: Container(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                colors: [Colors.blueAccent, Colors.blue],
                radius: 0.75,
              ),
            ),
            alignment: Alignment.center,
            width: double.infinity,
            height: double.infinity,
            padding: EdgeInsets.all(30),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Image(
                    image: AssetImage('assets/images/logo.jpg'),
                    width: 200,
                    height: 200,
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(_padding, 10, _padding, 10),
                    child: TextField(
                      enableInteractiveSelection: false,
                      controller: _username,
                      decoration: InputDecoration(
                        labelStyle: TextStyle(color: Colors.black),
                        labelText: "Username",
                        suffixIcon: Icon(Icons.person_outline),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(_padding, 10, _padding, 10),
                    child: TextField(
                      enableInteractiveSelection: false,
                      controller: _password,
                      obscureText: _showPwd,
                      decoration: InputDecoration(
                        labelText: "Password",
                        labelStyle: TextStyle(color: Colors.black),
                        suffixIcon: IconButton(
                          icon: Icon(
                            (_showPwd) ? Icons.lock : Icons.lock_open,
                          ),
                          onPressed: showPwd,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(_padding),
                    child: MaterialButton(
                      height: 50,
                      elevation: 0,
                      color: Colors.red,
                      minWidth: double.infinity,
                      onPressed: () => _validateUser(context),
                      child: Text("Ingresar", style: TextStyle(fontSize: 20),),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(
                      _padding,
                      0,
                      _padding,
                      0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
//                              MaterialButton(
//                                child: Text("Registrarme"),
//                                onPressed: () {},
//                              ),
//                              MaterialButton(
//                                child: Text("Olvide mi contraseña"),
//                                onPressed: () {},
//                              ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
}
