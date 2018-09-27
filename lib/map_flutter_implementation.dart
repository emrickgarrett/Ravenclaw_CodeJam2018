import 'package:flutter/material.dart';
import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:ravenclaw_codejam2018/StaticVariables.dart';
import 'location_handler.dart';

class MapFlutterImplementationPage extends StatefulWidget {

  final RavenclawLocation userLocation;

  MapFlutterImplementationPage(this.userLocation);

  @override
  _MapFlutterImplementationPageState createState() => new _MapFlutterImplementationPageState();
}

class _MapFlutterImplementationPageState extends State<MapFlutterImplementationPage> {

  GoogleMapController mapController;
  CameraPosition _position;
  GoogleMapOptions _options = GoogleMapOptions(
      trackCameraPosition: true,
      compassEnabled: true
  );
  bool _isMoving = false;

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

  void _onMapChanged() {
    setState(() {
      _extractMapInfo();
    });
  }

  void _extractMapInfo() {
    _options = mapController.options;
    _position = mapController.cameraPosition;
    _isMoving = mapController.isCameraMoving;
  }

  @override
  void dispose() {
    mapController.removeListener(_onMapChanged);
    super.dispose();
  }

  Widget _toggleCompassButton() {
    return FlatButton(
        child: Text('${_options.compassEnabled ? 'disable' : 'enable' } compass'),
        onPressed: () {
          mapController.updateMapOptions(GoogleMapOptions(compassEnabled: !_options.compassEnabled));
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> columnChildren = <Widget>[
      Padding(
          padding: EdgeInsets.all(15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              SizedBox(
                width: double.infinity,
                height:300.0,
                child: GoogleMap(
                    onMapCreated: _onMapCreated
                )
            ),
            RaisedButton(
                child: Text('Reload Data'),
                onPressed: _reloadData
            )],
          )
      )
    ];

    if(mapController != null) {
      columnChildren.add(
          Flexible(
              child: ListView(
                  children: <Widget>[
                    Text('camera bearing: ${_position == null ? 'nil' : _position.bearing}',),
                    _toggleCompassButton()
                  ]
              )
          )
      );
    }

    return  Scaffold(
        backgroundColor: Colors.white,
        appBar: new AppBar(
          backgroundColor: StaticVariables.primaryColor,
          title: Text(StaticVariables.appName)
        ),
        body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: columnChildren
      )
    );
  }
}