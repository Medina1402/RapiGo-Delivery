import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rapigo/other/colors_style.dart';

class DrawerMaps extends StatelessWidget {
  final editProfile;
  final history;
  final visible;
  final viewAll;
  final closed;

  final bool currentVisible;
  final bool currentViewAll;

  DrawerMaps({
    this.editProfile,
    this.history,
    this.closed,
    this.visible,
    this.viewAll,

    this.currentVisible = true,
    this.currentViewAll = true,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Colores.Primary,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                DrawerHeader(
                  decoration: BoxDecoration(color: Colors.blue),
                  child: Center(
                    child: Text("Header"),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 5, 0, 10),
                  child: MaterialButton(
                    elevation: 0,
                    minWidth: double.infinity,
                    height: 50,
                    child: Row(
                      children: [
                        Icon(Icons.person, color: Colors.white),
                        Text(
                          "   Editar datos de perfil",
                          style: TextStyle(color: Colors.white, fontSize: 18,),
                        ),
                      ],
                    ),
                    onPressed: editProfile,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 5, 0, 10),
                  child: MaterialButton(
                    elevation: 0,
                    minWidth: double.infinity,
                    height: 50,
                    child: Row(
                      children: [
                        Icon(
                          Icons.history,
                          color: Colors.white,
                        ),
                        Text(
                          "   Historial de entrega",
                          style: TextStyle(color: Colors.white, fontSize: 18,),
                        ),
                      ],
                    ),
                    onPressed: this.history,
                  ),
                ),
                Divider(color: Colors.black),
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 5, 0, 10),
                  child: MaterialButton(
                    elevation: 0,
                    minWidth: double.infinity,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.my_location,
                              color: Colors.white,
                            ),
                            Text(
                              "   Locacion visible",
                              style: TextStyle(color: Colors.white, fontSize: 18,),
                            ),
                          ],
                        ),
                        Checkbox(
                          value: currentVisible,
                          onChanged: null,
                        )
                      ],
                    ),
                    onPressed: visible
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 5, 0, 10),
                  child: MaterialButton(
                    elevation: 0,
                    minWidth: double.infinity,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.directions_bike,
                              color: Colors.white,
                            ),
                            Text(
                              "   Repartidores visibles",
                              style: TextStyle(color: Colors.white, fontSize: 18)),
                          ],
                        ),
                        Checkbox(
                          value: currentViewAll,
                          onChanged: null,
                        ),
                      ],
                    ),
                    onPressed: viewAll
                  ),
                ),
              ],
            ),
            MaterialButton(
              elevation: 0,
              minWidth: double.infinity,
              height: 55,
              color: Colors.blue,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.exit_to_app,
                    color: Colors.white,
                  ),
                  Text(
                    "   Cerrar sesion",
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ],
              ),
              onPressed: closed,
            ),
          ],
        ),
      ),
    );
  }
}