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

  Future<RavenclawLocation> get currentLocation async {
    return new RavenclawLocation(await location.getLocation());
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

class RavenclawLocation {
  Map<String, double> data;

  RavenclawLocation(Map<String, double> locationData) {
    data = locationData;
    print(data);
  }

  double get latitude {
    return data["latitude"];
  }

  double get longitude {
    return data["longitude"];
  }

  double get accuracy {
    return data["accuracy"];
  }

  double get altitude {
    return data["altitude"];
  }

  double get speed {
    return data["speed"];
  }

  double get speedAccuracy {
    return data["speed_accuracy"];
  }
}