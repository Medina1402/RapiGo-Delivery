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
import 'package:rapigo/widget/card_pedido_widget.dart';
import 'package:rapigo/widget/drawer_maps_widget.dart';
import 'package:rapigo/widget/scroll_view_widget.dart';

class MapScreen extends StatefulWidget {
  String _id = "";
  @override
  State<StatefulWidget> createState() => _MapScreen();
}

class _MapScreen extends State<MapScreen> {
  StreamSubscription<LocationData> _streamSubscriptionCurrentLocation;
  StreamSubscription<QuerySnapshot> _streamSubscriptionLocations;
  GoogleMapController _googleMapController;

  List<UserPosition> _userPositionList = List();
  Location _location = Location();

  ScrollController _scrollController = ScrollController();
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  LocationData _locData;

  // ===========================================================================
  List<UserPosition> _route = List();
  bool _locationVisible = true;
  bool _showAllPerson = true;
  BitmapDescriptor _icons;

  @override
  void initState() {
    super.initState();

    widget._id = "${SqfliteProvider.data.then((value) => value.id)}";

    _initLocation();
  }

  @override
  void dispose() {
    if(_streamSubscriptionCurrentLocation != null) _streamSubscriptionCurrentLocation.cancel();
    if(_streamSubscriptionLocations != null) _streamSubscriptionLocations.cancel();
    _googleMapController.dispose();
    super.dispose();
  }

  // ===========================================================================

  /*
   *
   */
  _logout(BuildContext context) async {
    Navigator.of(context).pop();
    UserPositionModel.disconnect(widget._id);
    SqfliteProvider.delete(widget._id);
    Navigator.pushReplacementNamed(context, "/");
  }

  /*
   * Current position in center screen
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
   * View for all users, update visible field in Could Firestore
   */
  _toggleViewCurrent() async {
    setState(() => _locationVisible = !_locationVisible);
    UserPositionModel.Collection.doc(widget._id).update({
      "visible": _locationVisible
    });
  }

  /*
   * Toggle View all locations for all users
   */
  _allToggleStopLocation() {
    _showAllPerson = !_showAllPerson;
    if(!_showAllPerson) {
      _streamSubscriptionLocations.pause();
      var x = _userPositionList.toSet();
      x.forEach((element) => _userPositionList.remove(element));
    } else _allLocations;
    setState(() {});
  }

  /*
   * Listen change position user in Could FireStore
   * >> Show all user with property "visible" is true
   */
  get _allLocations async {
    _streamSubscriptionLocations = UserPositionModel.Collection.snapshots().listen((QuerySnapshot snapshot) {
      _userPositionList = snapshot.docs
          .where((QueryDocumentSnapshot query) => query.data()["visible"] == true)
          .map((QueryDocumentSnapshot queryDocumentSnapshot) => UserPosition(
              id: queryDocumentSnapshot.data()["id"],
              position: queryDocumentSnapshot.data()["position"],
              visible: queryDocumentSnapshot.data()["visible"],
              tipo: queryDocumentSnapshot.data()["tipo"],
          )).toList();
      setState(() {});
    });
  }

  /*
   * Default config init
   */
  _initLocation() async {
    _icons = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(devicePixelRatio: 3.0),
      "assets/images/markeruser.png",
    );

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
     * First Loader
     */
    await _allLocations;

    /**
     * Listen change user local position (this)
     */
    _streamSubscriptionCurrentLocation = _location.onLocationChanged.listen((LocationData _locationData) {
      if (_googleMapController != null) {
        _googleMapController.setMapStyle(MyMapStyle);
        _locData = _locationData;
        /**
         * Update local position in Could FireStore
         */
        UserPositionModel.Collection.doc(widget._id).update({
          "position": GeoPoint(_locationData.latitude, _locationData.longitude)
        });
      }
    });
  }

  /*
   * Stream builder
   */
  get _streamBuilderDelivery {
    return StreamBuilder(
      stream: PedidosModel.Collection.snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        return (!snapshot.hasData)
        ? Text("Sin pedidos")
        : ListView.builder(
          controller: _scrollController,
          shrinkWrap: true,
          itemCount: snapshot.data.docs.length,
          itemBuilder: (BuildContext ctx, int index) {
            final item = snapshot.data.docs[index].data();
            return CardDeliver(
              item: item,
              onPressDelivery: () => print("Delivery >>>>>> ${item["id"]}"),
              onPressMap: () {
                setState(() {
                  _route.forEach((element) => _userPositionList.remove(element));
                  _route = List();

                  _route.add(UserPosition(
                      id: "from-${item["id"]}",
                      position: item["from"],
                      tipo: "from",
                      visible: true,
                  ));

                  _route.add(UserPosition(
                      id: "to-${item["id"]}",
                      position: item["to"],
                      visible: true,
                      tipo: "to"
                  ));
                });
              },
            );
          },
        );
      },
    );
  }


  /*
   * Markers
   */
  Set<Marker> get _markers {
    _route.forEach((element) => _userPositionList.add(element));
    return _userPositionList.map((UserPosition userPosition) => Marker(
      markerId: MarkerId(userPosition.id),
      position: LatLng(
        userPosition.position.latitude,
        userPosition.position.longitude,
      ),
      icon: BitmapDescriptor.defaultMarkerWithHue(
          (userPosition.tipo == "repartidor")
              ?BitmapDescriptor.hueGreen
              :(userPosition.tipo == "local")
                ?BitmapDescriptor.hueMagenta
                :BitmapDescriptor.hueCyan
      ),
      onTap: () => print("${userPosition.id} - ${userPosition.tipo}"),
      infoWindow: InfoWindow(
        title: "nombre del local",
        snippet: "Contenido",
      ),
    )).toSet();
  }

  // ===========================================================================

  @override
  Widget build(BuildContext context) {
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
      drawer: DrawerMaps(
        editProfile: null,
        history: null,
        closed: () => _logout(context),
        visible: _toggleViewCurrent,
        viewAll: _allToggleStopLocation,
        currentViewAll: _showAllPerson,
        currentVisible: _locationVisible,
      ),
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: (controller) {
              setState(() {
                _googleMapController = controller;
                _locationCenter();
              });
            },
            initialCameraPosition: CameraPosition(
              target: LatLng(32.4081212, -116.940533),
              zoom: 14,
            ),
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            compassEnabled: false,
            markers: _markers,
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
          ScrollViewWidget(
            title: "PEDIDOS",
            streamBuilder: _streamBuilderDelivery,
          ),
        ],
      ),
    );
  }
}
