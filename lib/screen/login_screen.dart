import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rapigo/database/model/user_model.dart';
import 'package:rapigo/database/model/user_position_model.dart';
import 'package:rapigo/other/colors_style.dart';
import 'package:rapigo/services/file_manager_service.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _LoginScreen();
}

class _LoginScreen extends State<LoginScreen> {
  FileManagerService _fileManagerService = FileManagerService();
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
  _userFind() {
    _username.clear();
    _password.clear();
    Navigator.pushReplacementNamed(context, "/map");
  }

  /*
   *
   */
  _notFound(BuildContext context) {
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
              Text("  Debes llenar todos los datos"),
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
    String _key = await UserModel.login(_username.text, _password.text);
    if (_key != null) _userFind();
    if (_username.text.length <= 0 || _password.text.length <= 0) {
      _notFound(context);
      return null;
    }

    final User _user = User(_username.text, _password.text);
    _key = await UserModel.create(_user);
    await _fileManagerService.writeFile("temp.txt", _key);

    final UserPosition _userModel = UserPosition(_key, GeoPoint(0, 0));
    await UserPositionModel.create(_userModel);

    _userFind();
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
                colors: [Colores.Primary, Colores.Secondary],
                radius: 0.5,
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
                      child: Text("Ingresar"),
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
