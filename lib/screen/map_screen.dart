import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:rapigo/database/model/pedidos_model.dart';
import 'package:rapigo/database/model/user_position_model.dart';
import 'package:rapigo/database/sqflite_provider.dart';
import 'package:rapigo/other/colors_style.dart';
import 'package:rapigo/other/map_style.dart';

class MapScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MapScreen();
}

class _MapScreen extends State<MapScreen> {
  StreamSubscription<LocationData> _streamSubscriptionCurrentLocation;
  StreamSubscription<QuerySnapshot> _streamSubscriptionLocations;
  List<UserPosition> _userPositionList = List();
  GoogleMapController _googleMapController;
  Location _location = Location();

  ScrollController _scrollController = ScrollController();
  LocationData _locData;
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // ===========================================================================
  bool _locationVisible = true;
  bool _showAllPerson = true;

  @override
  void initState() {
    super.initState();
    _initLocation();
  }

  @override
  void dispose() {
    if (_streamSubscriptionCurrentLocation != null)
      _streamSubscriptionCurrentLocation.cancel();
    if (_streamSubscriptionLocations != null)
      _streamSubscriptionLocations.cancel();
    _googleMapController.dispose();
    super.dispose();
  }

  // ===========================================================================

  _logout(BuildContext context) async {
    Navigator.of(context).pop();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        elevation: 24,
        backgroundColor: Colors.white,
        content: Text("¿Deseas cerrar sesion?"),
        title: Row(
          children: [
            Icon(
              Icons.warning,
              color: Colors.red,
            ),
            Text("  Cerrar sesion"),
          ],
        ),
        actions: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                child: MaterialButton(
                  color: Colors.red,
                  child: Text("Aceptar"),
                  onPressed: () async {
                    _streamSubscriptionCurrentLocation.pause();
                    _streamSubscriptionLocations.pause();

                    final String _keyFromFileTemp =
                        await SqfliteProvider.data.then((value) => value.id);
                    UserPositionModel.disconnect(_keyFromFileTemp);
                    await SqfliteProvider.delete(_keyFromFileTemp);
                    Navigator.pushReplacementNamed(context, "/");
                  },
                ),
              ),
              MaterialButton(
                color: Colors.green,
                child: Text("Cancelar"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        ],
      ),
      barrierDismissible: true,
    );
  }

  /*
   *
   */
  _locationCenter() async {
    _googleMapController.animateCamera(
      CameraUpdate.newLatLng(
        LatLng(_locData.latitude, _locData.longitude),
      ),
    );
    setState(() {});
  }

  /*
   *
   */
  _initLocation() async {
    /**
     * Service Location enabled
     */
    bool _serviceEnabled = await _location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await _location.requestService();
      if (!_serviceEnabled) return;
    }

    /**
     * Permission current Location
     */
    PermissionStatus _permissionGranted = await _location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await _location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted)
        return print("No permission");
    }

    /**
     * Listen change position user in Could FireStore
     * >> Show all user with property "visible" is true
     * @Todo Mostrar solo aquellos que se encuentren en la pantalla
     */
    _streamSubscriptionLocations = UserPositionModel.Collection.snapshots()
        .listen((QuerySnapshot snapshot) {
      _userPositionList = snapshot.docs
          .where(
              (QueryDocumentSnapshot query) => query.data()["visible"] == true)
          .map((QueryDocumentSnapshot queryDocumentSnapshot) => UserPosition(
              queryDocumentSnapshot.data()["id"],
              queryDocumentSnapshot.data()["position"]))
          .toList();
      setState(() {});
    });

    /**
     * Listen change user local position (this)
     */
    final _keyFromFileTemp = await SqfliteProvider.data;

    _streamSubscriptionCurrentLocation =
        _location.onLocationChanged.listen((LocationData _locationData) {
      if (_googleMapController != null) {
        _googleMapController.setMapStyle(MyMapStyle);
        _locData = _locationData;

        /**
         * Update local position in Could FireStore
         */
        UserPositionModel.Collection.doc(_keyFromFileTemp.id).update({
          "position": GeoPoint(_locationData.latitude, _locationData.longitude)
        });
      }
    });
  }

  // ===========================================================================

  @override
  Widget build(BuildContext context) {
    _locationCenter();
    /**
     *
     */
    return Scaffold(
      backgroundColor: Colors.black,
      floatingActionButtonLocation: FloatingActionButtonLocation.miniStartTop,
      floatingActionButton: Builder(
        key: _scaffoldKey,
        builder: (ctx) => FloatingActionButton(
          heroTag: "btnMenu",
          child: Icon(Icons.menu),
          elevation: 2,
          backgroundColor: Colors.blue,
          onPressed: () => Scaffold.of(ctx).openDrawer(),
        ),
      ),
      drawer: Drawer(
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
                    padding: EdgeInsets.fromLTRB(
                      0,
                      5,
                      0,
                      10,
                    ),
                    child: MaterialButton(
                      elevation: 0,
                      minWidth: double.infinity,
                      height: 50,
                      child: Row(
                        children: [
                          Icon(
                            Icons.person,
                            color: Colors.white,
                          ),
                          Text(
                            "   Editar datos de perfil",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                      onPressed: () {},
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(
                      0,
                      5,
                      0,
                      10,
                    ),
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
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                      onPressed: () {},
                    ),
                  ),
                  Divider(
                    color: Colors.black,
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
                                Icons.my_location,
                                color: Colors.white,
                              ),
                              Text(
                                "   Locacion visible",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                          Checkbox(
                              value: _locationVisible,
                              onChanged: (bool value) async {
                                setState(() {
                                  _locationVisible = !_locationVisible;
                                });
                              })
                        ],
                      ),
                      onPressed: () {
                        setState(() {
                          _locationVisible = !_locationVisible;
                        });
                      },
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
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18),
                              ),
                            ],
                          ),
                          Checkbox(
                              value: _showAllPerson,
                              onChanged: (bool value) {
                                setState(() {
                                  _showAllPerson = !_showAllPerson;
                                });
                              }),
                        ],
                      ),
                      onPressed: () {
                        setState(() {
                          _showAllPerson = !_showAllPerson;
                        });
                      },
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
                onPressed: () => _logout(context),
              ),
            ],
          ),
        ),
      ),
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: (controller) => _googleMapController = controller,
            initialCameraPosition: CameraPosition(
              target: LatLng(
                32.4081212,
                -116.940533,
              ),
              zoom: 18,
            ),
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            compassEnabled: false,
            markers: _userPositionList
                .map((UserPosition userPosition) => Marker(
                      markerId: MarkerId(userPosition.id),
                      position: LatLng(
                        userPosition.position.latitude,
                        userPosition.position.longitude,
                      ),
                      onTap: () => print(userPosition.id),
                    ))
                .toSet(),
          ),
          Positioned(
            bottom: 80,
            right: 15,
            child: FloatingActionButton(
              heroTag: "centerLocation",
              elevation: 0,
              backgroundColor: Colores.Primary,
              child: Icon(Icons.my_location),
              onPressed: _locationCenter,
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
            child: DraggableScrollableSheet(
              initialChildSize: 0.075,
              maxChildSize: 0.5,
              minChildSize: 0.075,
              builder: (context, _controller) {
                return Container(
                  color: Colors.blue,
                  child: SingleChildScrollView(
                    controller: _controller,
                    child: Column(
                      children: [
                        Container(
                          height: 60,
                          width: double.infinity,
                          alignment: Alignment.center,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                                child: Icon(
                                  Icons.directions_bike,
                                  size: 25,
                                  color: Colores.Primary,
                                ),
                              ),
                              Text(
                                "PEDIDOS",
                                style: TextStyle(
                                  letterSpacing: 5,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colores.Primary,
                                ),
                              )
                            ],
                          ),
                        ),
                        Column(
                          children: [
                            StreamBuilder(
                              stream: PedidosModel.Collection.snapshots(),
                              builder: (BuildContext context,
                                  AsyncSnapshot<QuerySnapshot> snapshot) {
                                if (!snapshot.hasData)
                                  return Text("Sin pedidos");
                                return ListView.builder(
                                  controller: _scrollController,
                                  shrinkWrap: true,
                                  itemCount: snapshot.data.docs.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    final item =
                                        snapshot.data.docs[index].data();
                                    return Card(
                                        key: Key("${item["id"]}"),
                                        margin:
                                            EdgeInsets.fromLTRB(30, 20, 30, 20),
                                        child: Padding(
                                          padding: EdgeInsets.fromLTRB(
                                              10, 10, 10, 0),
                                          child: Column(
                                            children: [
                                              Text("Local: ${item["id"]}"),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                      "disponible: ${item["disponible"]}"),
                                                  Text(
                                                      "recogido: ${item["recogido"]}"),
                                                  Text(
                                                      "entregado: ${item["entregado"]}"),
                                                ],
                                              ),
                                              Text(
                                                  "Direccion: ${item["direccion"]}"),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text("Tiempo aprox: 5min"),
                                                  MaterialButton(
                                                    color: Colors.blue,
                                                    child: Text("Ver en mapa"),
                                                    onPressed: () {},
                                                  ),
                                                ],
                                              ),
                                              MaterialButton(
                                                minWidth: double.infinity,
                                                color: Colors.blue,
                                                child: Text("Aceptar pedido"),
                                                onPressed: () {},
                                              ),
                                            ],
                                          ),
                                        ));
                                  },
                                );
                              },
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
