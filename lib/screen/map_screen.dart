import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:rapigo/database/model/user_model.dart';
import 'package:rapigo/other/map_style.dart';

class MapScreen extends StatefulWidget  {
  @override
  State<StatefulWidget> createState() => _MapScreen();
}

class _MapScreen extends State<MapScreen> {
  StreamSubscription<LocationData> _streamSubscriptionLocation;
  StreamSubscription<QuerySnapshot> _streamSubscriptionQuerySnapshot;
  List<UserPosition> _userPositionList = List();
  GoogleMapController _googleMapController;
  Location _location = Location();

  @override
  void initState() {
    super.initState();
    _initLocation();
  }

  @override
  void dispose() {
    if (_streamSubscriptionLocation != null) _streamSubscriptionLocation.cancel();
    if (_streamSubscriptionQuerySnapshot != null) _streamSubscriptionQuerySnapshot.cancel();
    super.dispose();
  }

  Future<void> _initLocation() async {
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
    _streamSubscriptionQuerySnapshot = UserModel.UserCollection.snapshots().listen((QuerySnapshot snapshot) {
      _userPositionList = snapshot.docs
          .where((QueryDocumentSnapshot query) => query.data()["visible"] == true)
          .map((QueryDocumentSnapshot queryDocumentSnapshot) => UserPosition(
            queryDocumentSnapshot.data()["id"],
            queryDocumentSnapshot.data()["position"])
      ).toList();
      setState(() {});
    });

    /**
     * Listen change user local position (this)
     */
    _streamSubscriptionLocation = _location.onLocationChanged.listen((LocationData _locationData) {
      if (_googleMapController != null) {
        _googleMapController.setMapStyle(MyMapStyle);
        _googleMapController.animateCamera(CameraUpdate.newLatLng(LatLng(_locationData.latitude, _locationData.longitude)));

        /**
         * Update local position in Could FireStore
         */
        UserModel.UserCollection.doc("eEWOUN3NJbFQ5hhImjUv").update({
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
          RaisedButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18.0),
              side: BorderSide(color: Colors.lightBlueAccent),
            ),
            color: Colors.lightBlueAccent,
            elevation: 0,
            child: Icon(Icons.keyboard_arrow_up),
            onPressed: (){
              print("Press button stack");
            },
          )
        ],
      ),
    );
  }

}