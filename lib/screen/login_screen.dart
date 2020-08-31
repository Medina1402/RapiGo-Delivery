import 'package:flutter/material.dart';
import 'package:rapigo/database/model/user_model.dart';
import 'package:rapigo/database/sqflite_provider.dart';
import 'package:rapigo/other/colors_style.dart';
import 'package:rapigo/widget/input_decoration_login_widget.dart';

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
  _help(BuildContext context) {}

  /*
   *
   */
  _userFind(String key) async {
    await SqfliteProvider.delete(key);
    await SqfliteProvider.insert(UserRapigoDB(key, _username.text, 0, 0));

    Navigator.pushReplacementNamed(context, "/map");

    _username.clear();
    _password.clear();
  }

  /*
   *
   */
  _validateUser(BuildContext context) async {
    if (_username.text.length <= 0 || _password.text.length <= 0) {
      return null;
    }

    String _key = await UserModel.login(_username.text, _password.text);
    if (_key != null) return await _userFind(_key);

    return null;
  }

  // ===========================================================================
  bool _showPwd = true;

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
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colores.Primary,
        elevation: 0,
        child: Icon(
          Icons.help_outline,
          color: Colors.white30,
        ),
        onPressed: _help(context),
      ),
      backgroundColor: Colors.transparent,
      body: Container(
        color: Colores.Primary,
        alignment: Alignment.center,
        width: double.infinity,
        height: double.infinity,
        padding: EdgeInsets.all(30),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Image(
                image: AssetImage('assets/images/logo.png'),
                width: 200,
                height: 200,
              ),
              InputDecorationField(
                hintText: "Username",
                controller: _username,
                suffixIcon: Icon(Icons.person_outline),
              ),
              InputDecorationField(
                hintText: "Password",
                visibleText: _showPwd,
                controller: _password,
                suffixIcon: IconButton(
                  icon: Icon((_showPwd) ? Icons.lock : Icons.lock_open),
                  onPressed: showPwd,
                ),
              ),
              Padding(
                padding: EdgeInsets.all(20),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: MaterialButton(
                    height: 50,
                    elevation: 0,
                    color: Colors.blue,
                    minWidth: double.infinity,
                    onPressed: () => _validateUser(context),
                    child: Text(
                      "INGRESAR",
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
