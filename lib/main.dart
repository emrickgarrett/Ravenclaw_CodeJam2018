import 'package:flutter/material.dart';
import 'location_handler.dart';
import 'StaticVariables.dart';

void main() => runApp(new MyApp());

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
  Map<String, double> location;
  bool hasLocationPermission = false;
  LocationHandler handler = new LocationHandler();

  _MyHomePageState() {
    _updateLocationPermission();
    _autoUpdateLocation();
  }

  void _updateLocation(Map<String, double> newLocation) {
    setState(() =>
      location = newLocation
    );
  }

  void _autoUpdateLocation() {
    if(hasLocationPermission) {
      handler.addLocationListener((location) =>
        _updateLocation(location)
      );
    }
  }

  void _updateLocationPermission() async {
    var hasPermission = await handler.hasPermission;
    setState(() {
      hasLocationPermission = hasPermission;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
      ),
      body: new Center(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Text(
              'Your current location',
            ),
            new Text(
              'Have Permission? - $hasLocationPermission',
              style: Theme.of(context).textTheme.display1,
            ),
          ],
        ),
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: _updateLocationPermission,
        tooltip: 'Retry For Permission',
        child: new Icon(Icons.refresh),
      ),
    );
  }
}
