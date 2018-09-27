import 'package:location/location.dart';
import 'dart:async';

class LocationHandler {
  Location location = new Location();
  Map<String, double> updatingLocation;
  List<Function> callbacks = new List();

  LocationHandler() {
    location = new Location();
    location.onLocationChanged().listen((Map<String, double> updatingLocation) {
      for(var callback in callbacks) {
        callback(updatingLocation);
      }
    });
  }

  Future<Map<String, double>> get currentLocation async {
    return location.getLocation();
  }

  void addLocationListener(Function f) {
    callbacks.add(f);
  }

  void removeLocationListener(Function f) {
    callbacks.remove(f);
  }

  Future<bool> get hasPermission async {
    bool hasPermission = await location.hasPermission();
    if(hasPermission == null) {
      hasPermission = false;
    }
    return hasPermission;
  }


}