import 'package:flutter/material.dart';
import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:ravenclaw_codejam2018/StaticVariables.dart';
import 'location_handler.dart';

class MapFlutterImplementationPage extends StatefulWidget {

  final SingleLocation userLocation;

  MapFlutterImplementationPage(this.userLocation);

  @override
  _MapFlutterImplementationPageState createState() => new _MapFlutterImplementationPageState();
}

class _MapFlutterImplementationPageState extends State<MapFlutterImplementationPage> {

  GoogleMapController mapController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: new AppBar(
        backgroundColor: StaticVariables.primaryColor,
        title: Text(StaticVariables.appName)
      ),
      body: Padding(
        padding: EdgeInsets.all(15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Expanded(
                child: GoogleMap(
                      onMapCreated: _onMapCreated
                    )
              ),
              RaisedButton(
                child: Text('Reload Data'),
                onPressed: _reloadData
              )
            ],
        )
      )
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    setState(() { mapController = controller; });
    _navigateToUserLocation();
  }

  void _reloadData() {
    _navigateToUserLocation();
  }

  void _navigateToUserLocation() {
    if(mapController != null) {
      mapController.animateCamera(CameraUpdate.newCameraPosition(
          CameraPosition(
              bearing: 270.0,
              target: LatLng(widget.userLocation.latitude, widget.userLocation.longitude),
              tilt: 30.0,
              zoom: 17.0
          )
      ));
    }
  }
}