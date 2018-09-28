import 'package:flutter/material.dart';
import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:ravenclaw_codejam2018/StaticVariables.dart';
import 'location_handler.dart';
import 'dart:math';

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
  bool crimeAlertsDisplayed = false;
  bool weatherAlertsDisplayed = false;
  bool crashAlertsDisplayed = false;

  _MapFlutterImplementationPageState() {
    new Timer.periodic(const Duration(seconds: 5), (_) {
      updateAlertValues();
    });
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

  void _onMapChanged() {
    setState(() {
      _extractMapInfo();
    });
  }

  void _extractMapInfo() {
    setState(() {
      _options = mapController.options;
      _position = mapController.cameraPosition;
      _isMoving = mapController.isCameraMoving;
    });
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

  void updateAlertValues() {
    print("Update Alert");
    var rng = new Random();
    var cutOff = 10; //10 percent chance to show alert
    var keepChance = 85;
    var showChance = 5;
    var displayCrime = false;
    var displayWeather = false;
    var displayCrash = false;

    if(crimeAlertsDisplayed) {
      cutOff = keepChance; // 85 percent chance to keep alert
    }
    displayCrime = rng.nextInt(100) <= cutOff;
    cutOff = showChance;


    if(weatherAlertsDisplayed) {
      cutOff = keepChance; // 85 percent chance to keep alert
    }
    displayWeather = rng.nextInt(100) <= cutOff;
    cutOff = showChance;

    if(crashAlertsDisplayed) {
      cutOff = keepChance; // 85 percent chance to keep alert
    }
    displayCrash = rng.nextInt(100) <= cutOff;

    if(displayCrime) { print("Crime!"); }
    if(displayWeather) { print("Weather!"); }
    if(displayCrash) { print("Crash!"); }

    setState(() {
      crimeAlertsDisplayed = displayCrime;
      weatherAlertsDisplayed = displayWeather;
      crashAlertsDisplayed = displayCrash;
    });
  }

  TextStyle get alertTextStyle {
    return TextStyle(
      fontWeight: FontWeight.w400,
      fontSize: 18.0,
      color: Colors.white
    );
  }

  Widget get alerts {
    bool notNull(Object o) => o != null;
    Column alertChildren = Column(
        children: <Widget>[
          crimeClaimAlerts,
          crimeAlertsDisplayed && weatherAlertsDisplayed? Divider(color: Colors.white, height: 2.0) : null,
          weatherDamageAlert,
          (crimeAlertsDisplayed || weatherAlertsDisplayed) && crashAlertsDisplayed? Divider(color: Colors.white, height: 2.0) : null,
          crashClaimAlert
        ].where(notNull).toList()
    );

    if(crimeAlertsDisplayed || weatherAlertsDisplayed || crashAlertsDisplayed) {
      return Container(
          decoration: new BoxDecoration(color: Colors.red),
          child: alertChildren,
      );
    } else {
      return Container();
    }
  }

  Widget get crimeClaimAlerts {
    if(crimeAlertsDisplayed) {
      return Container(
          padding: EdgeInsets.all(10.0),
          child: Text(
          "High Crime Detected 🦇🙋‍♂️",
          style: alertTextStyle
        )
      );
    } else {
      return Container();
    }
  }

  Widget get weatherDamageAlert {
    if(weatherAlertsDisplayed) {
      return Container(
        padding: EdgeInsets.all(10.0),
        child: Text(
          "Weather Damage Detected In Your Area",
            style: alertTextStyle
        )
      );
    } else {
      return Container();
    }
  }

  Widget get crashClaimAlert {
    if(crashAlertsDisplayed) {
      return Container(
          padding: EdgeInsets.all(10.0),
          child: Text(
          "High Crash Potential Detected",
            style: alertTextStyle
        )
      );
    } else {
      return Container();
    }
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
                  child: Text('Recenter Map'),
                  onPressed: _reloadData
              ),
            ],
          )
      )
    ];

    if(mapController != null) {
      columnChildren.add(
          Flexible(
              child: ListView(
                  children: <Widget>[
                    Center(child: Text('camera bearing: ${_position == null ? 'nil' : _position.bearing}',)),
                    _toggleCompassButton(),
                    alerts
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