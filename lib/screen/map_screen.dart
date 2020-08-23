import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:rapigo/database/model/pedidos_model.dart';
import 'package:rapigo/database/model/user_position_model.dart';
import 'package:rapigo/other/map_style.dart';
import 'package:rapigo/services/file_manager_service.dart';

class MapScreen extends StatefulWidget  {
  @override
  State<StatefulWidget> createState() => _MapScreen();
}

class _MapScreen extends State<MapScreen> {
  FileManagerService _fileManagerService = FileManagerService();
  StreamSubscription<LocationData> _streamSubscriptionCurrentLocation;
  StreamSubscription<QuerySnapshot> _streamSubscriptionLocations;
  StreamSubscription<QuerySnapshot> _streamSubscriptionPedidos;
  List<Pedido> _pedidosList = List();
  List<UserPosition> _userPositionList = List();
  GoogleMapController _googleMapController;
  Location _location = Location();

  // ===========================================================================

  @override
  void initState() {
    super.initState();
    _initLocation();
  }

  @override
  void dispose() {
    if (_streamSubscriptionCurrentLocation != null) _streamSubscriptionCurrentLocation.cancel();
    if (_streamSubscriptionLocations != null) _streamSubscriptionLocations.cancel();
    if (_streamSubscriptionPedidos != null) _streamSubscriptionPedidos.cancel();
    super.dispose();
  }

  // ===========================================================================

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
      if (_permissionGranted != PermissionStatus.granted) return print("No permission");
    }

    /**
     * Listen change position user in Could FireStore
     * >> Show all user with property "visible" is true
     * @Todo Mostrar solo aquellos que se encuentren en la pantalla
     */
    _streamSubscriptionLocations = UserPositionModel.Collection.snapshots().listen((QuerySnapshot snapshot) {
      _userPositionList = snapshot.docs
          .where((QueryDocumentSnapshot query) => query.data()["visible"] == true)
          .map((QueryDocumentSnapshot queryDocumentSnapshot) => UserPosition(
            queryDocumentSnapshot.data()["id"],
            queryDocumentSnapshot.data()["position"])
      ).toList();
      setState(() {});
    });

    /*
     *
     */
    _streamSubscriptionPedidos = PedidosModel.Collection.snapshots().listen((QuerySnapshot snapshot) {
      _pedidosList = snapshot.docs.map((QueryDocumentSnapshot queryDocumentSnapshot) => Pedido(
        queryDocumentSnapshot.data()["id"],
        queryDocumentSnapshot.data()["disponible"],
        queryDocumentSnapshot.data()["entregado"],
        queryDocumentSnapshot.data()["recogido"])
      ).toList();
      setState(() {});
    });

    /**
     * Listen change user local position (this)
     */
    final String _keyFromFileTemp = await _fileManagerService.readFile("temp.txt");
    print(">> key: $_keyFromFileTemp");

    _streamSubscriptionCurrentLocation = _location.onLocationChanged.listen((LocationData _locationData) {
      if (_googleMapController != null) {
        _googleMapController.setMapStyle(MyMapStyle);
        _googleMapController.animateCamera(CameraUpdate.newLatLng(LatLng(_locationData.latitude, _locationData.longitude)));

        /**
         * Update local position in Could FireStore
         * @Todo leer el archivo temporal y extraer la key
         */
        UserPositionModel.Collection.doc("eEWOUN3NJbFQ5hhImjUv").update({
          "position": GeoPoint(_locationData.latitude, _locationData.longitude)
        });
      }
    });



  }

  // ===========================================================================

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.black12,
      body: Stack(
        alignment: Alignment.bottomCenter,
        overflow: Overflow.clip,
        children: [
          GoogleMap(
            onMapCreated: (controller) => _googleMapController = controller,
            initialCameraPosition: CameraPosition(
              target: LatLng(32.4081212, -116.940533),
              zoom: 18,
            ),
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            compassEnabled: false,
            markers: _userPositionList.map((UserPosition userPosition) => Marker(
              markerId: MarkerId(userPosition.id),
              position: LatLng(
                  userPosition.position.latitude,
                  userPosition.position.longitude
              ),
              onTap: () => print(userPosition.id),
            )).toSet(),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
            child: DraggableScrollableSheet(
              initialChildSize: 0.075,
              maxChildSize: 0.5,
              minChildSize: 0.075,
              builder: (context, _controller) {
                return Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(20.0),
                      topLeft: Radius.circular(20.0),
                    ),
                    color: Colors.red,
                  ),
                  child: SingleChildScrollView(
                    controller: _controller,
                    child: Column(
                      children: [
                        Container(
                          height: 50,
                          width: double.infinity,
                          alignment: Alignment.center,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(padding: EdgeInsets.fromLTRB(15, 0, 15, 0), child: Icon(Icons.directions_bike, size: 25,),),
                              Text("PEDIDOS", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),)
                            ],
                          ),
                        ),
                        Column(
                          children: [
                            Card(
                              margin: EdgeInsets.fromLTRB(20, 30, 20, 30),
                              child: Column(
                                children: [
                                  Text("Nombre del local"),
                                  Text("Direccion"),
                                  Text("Tiempo al local"),
                                  Text("Tiempo total de entrega"),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                      MaterialButton(
                                        color: Colors.green,
                                        child: Text("Ver en mapa"),
                                        onPressed: (){},
                                      ),
                                      MaterialButton(
                                        color: Colors.blue,
                                        child: Text("Postularme"),
                                        onPressed: (){},
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Card(
                              margin: EdgeInsets.fromLTRB(20, 30, 20, 30),
                              child: Column(
                                children: [
                                  Text("Nombre del local"),
                                  Text("Direccion"),
                                  Text("Tiempo al local"),
                                  Text("Tiempo total de entrega"),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                      MaterialButton(
                                        color: Colors.green,
                                        child: Text("Ver en mapa"),
                                        onPressed: (){},
                                      ),
                                      MaterialButton(
                                        color: Colors.blue,
                                        child: Text("Postularme"),
                                        onPressed: (){},
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Card(
                              margin: EdgeInsets.fromLTRB(20, 30, 20, 30),
                              child: Column(
                                children: [
                                  Text("Nombre del local"),
                                  Text("Direccion"),
                                  Text("Tiempo al local"),
                                  Text("Tiempo total de entrega"),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                      MaterialButton(
                                        color: Colors.green,
                                        child: Text("Ver en mapa"),
                                        onPressed: (){},
                                      ),
                                      MaterialButton(
                                        color: Colors.blue,
                                        child: Text("Postularme"),
                                        onPressed: (){},
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}