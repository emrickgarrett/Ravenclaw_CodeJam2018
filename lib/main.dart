import 'package:flutter/material.dart';
import 'dart:async';

import 'location_handler.dart';
import 'StaticVariables.dart';
import 'map_flutter_implementation.dart';

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
  SingleLocation location;
  bool hasLocationPermission = false;
  LocationHandler handler = new LocationHandler();

  _MyHomePageState() {
    _updateLocationPermission();
    _autoUpdateLocation();
  }

  void _updateLocation(SingleLocation newLocation) {
    setState(() =>
      location = newLocation
    );
  }

  void _autoUpdateLocation() {
    if(hasLocationPermission) {
      handler.addLocationListener((location) =>
        _updateLocation(new SingleLocation(location))
      );
    }
  }

  void _updateLocationPermission() async {
    var hasPermission = await handler.hasPermission;
    setState(() {
      hasLocationPermission = hasPermission;
    });
  }

  void _navigateToMap() async {
    var isAndroid = Theme.of(context).platform == TargetPlatform.android;
    if(isAndroid) {
      var location = await handler.currentLocation;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Do you have Location Permission?',
            ),
            Text(
              hasLocationPermission? "Yes" : "No",
              style: Theme.of(context).textTheme.display1,
            ),
            RaisedButton(
              onPressed: _updateLocationPermission,
              child: Text('Refresh Permission'),
              color: StaticVariables.primaryColor,
              textColor: Colors.white
            )
          ],
        ),
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: _navigateToMap,
        tooltip: 'View The Map',
        child: new Icon(Icons.map),
      ),
    );
  }
}
