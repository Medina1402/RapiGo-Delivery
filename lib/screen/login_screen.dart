import 'package:flutter/material.dart';
import 'package:rapigo/database/model/user_model.dart';
import 'package:rapigo/screen/loader_screen.dart';
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
  bool _loader = true;

  @override
  void initState() {
    super.initState();
    _fileManagerService.readFile("temp.txt").then((_content) => {
      if(_content!=null && _content.length >= 20) _userFind()
    });
    setState(() => _loader = false);
  }

  @override
  void dispose() {
    _username.dispose();
    _password.dispose();
    super.dispose();
  }

  // ===========================================================================

  _help() async {
    var _key = await _fileManagerService.readFile("temp.txt");
    print(_key);
  }

  _userFind() {
    _username.clear();
    _password.clear();
    Navigator.pushReplacementNamed(context, "/map");
  }

  _notFound() async {
    print("El usuario no es valido");
  }

  _validateUser() async {
    String _key = await UserModel.login(_username.text, _password.text);
    if(_key == null) return _notFound();
    await _fileManagerService.writeFile("temp.txt", _key);
    _userFind();
  }

  // ===========================================================================
  bool _showPwd = true;
  // Toggle show password
  void showPwd() {
    setState(() {_showPwd = !_showPwd;});
  }


  @override
  Widget build(BuildContext context) {
    return (_loader) ?LoaderScreen :Scaffold(
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
        onPressed: _help,
      ),
      backgroundColor: Colors.blue,
      body: Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            radius: 1,
            colors: [Colors.lightBlueAccent, Colors.blueAccent],
          )
        ),
        alignment: Alignment.center,
        width: double.infinity,
        height: double.infinity,
        padding: EdgeInsets.all(30),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(20),
                child: TextField(
                  enableInteractiveSelection: false,
                  controller: _username,
                  decoration: InputDecoration(
                      labelText: "Username",
                      suffixIcon: Icon(Icons.person_outline)
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(20),
                child: TextField(
                  enableInteractiveSelection: false,
                  controller: _password,
                  obscureText: _showPwd,
                  decoration: InputDecoration(
                    labelText: "Password",
                    suffixIcon: IconButton(
                      icon: Icon((_showPwd)?Icons.lock:Icons.lock_open),
                      onPressed: showPwd,
                    )
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(20),
                child: MaterialButton(
                  height: 50,
                  elevation: 0,
                  color: Colors.red,
                  minWidth: double.infinity,
                  onPressed: _validateUser,
                  child: Text("Ingresar"),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    MaterialButton(
                      child: Text("Registrarme"),
                      onPressed: (){},
                    ),
                    MaterialButton(
                      child: Text("Olvide mi contraseña"),
                      onPressed: (){},
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}