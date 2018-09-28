import 'package:flutter/material.dart';
import 'dart:async';

import 'package:ravenclaw_codejam2018/location_handler.dart';
import 'StaticVariables.dart';
import 'package:ravenclaw_codejam2018/map_flutter_implementation.dart';
import 'package:ravenclaw_codejam2018/weather_info.dart';

void main() {
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: StaticVariables.appName,
      theme: new ThemeData(
        primarySwatch: StaticVariables.primaryColor
      ),
      home: new MyHomePage(title: StaticVariables.appName),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  RavenclawLocation location;
  bool hasLocationPermission = false;
  LocationHandler handler = new LocationHandler();
  bool trackingLocation = false;

  _MyHomePageState() {
    _updateLocationPermission();
    _autoUpdateLocation();
  }

  void _updateLocation(RavenclawLocation newLocation) {
    setState(() =>
      location = newLocation
    );
  }

  void _autoUpdateLocation() {
    if(hasLocationPermission) {
      handler.addLocationListener((location) =>
        _updateLocation(new RavenclawLocation(location))
      );
      trackingLocation = true;
    }
  }

  void _updateLocationPermission() async {
    var hasPermission = await handler.hasPermission;
    setState(() {
      hasLocationPermission = hasPermission;
    });
    if(!trackingLocation) {
      _autoUpdateLocation();
    }
  }

  void _navigateToMap() async {
    var isAndroid = Theme.of(context).platform == TargetPlatform.android;
    if(isAndroid) {
      var location = await handler.currentLocation;
      if(location == null) {
        showNoLocationDialog();
      }
      //Navigate to map
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) {
            return MapFlutterImplementationPage(location);
          }
        )
      );
    } else {
      showIosDisabledDialog();
    }
  }

  void refresh() {
    setState(() {});
  }

  Future showIosDisabledDialog() async {
    return showDialog(
      context: context,
      child: AlertDialog(
        title: Text("iOS Map is Currently Disabled"),
        content: Text("Blame Google's Flutter API"),
        actions: [
          FlatButton(
            child: Text("Bummer"),
            onPressed: () => Navigator.of(context).pop()
          )
        ]
      )
    );
  }

  Future showNoLocationDialog() async {
    return showDialog(
        context: context,
        child: AlertDialog(
            title: Text("Unable to determine your location"),
            content: Text("Try again later"),
            actions: [
              FlatButton(
                  child: Text("Okay"),
                  onPressed: () => Navigator.of(context).pop()
              )
            ]
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body:  Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            WeatherData(notifyParent: refresh),
            RaisedButton(
              onPressed: _updateLocationPermission,
              child: Text('Refresh Weather'),
              color: StaticVariables.primaryColor,
              textColor: Colors.white
            )
          ],
        ),
      floatingActionButton: new FloatingActionButton(
        onPressed: _navigateToMap,
        tooltip: 'View The Map',
        child: new Icon(Icons.map),
      ),
    );
  }
}
