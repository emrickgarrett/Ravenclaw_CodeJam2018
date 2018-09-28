import 'package:flutter/material.dart';
import 'package:ravenclaw_codejam2018/location_handler.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:ravenclaw_codejam2018/Keys.dart';

class WeatherData extends StatefulWidget {
  final Function() notifyParent;
  WeatherData({Key key, @required this.notifyParent}) : super(key: key);

  @override
  _WeatherDataState createState() => new _WeatherDataState();
}

class _WeatherDataState extends State<WeatherData> {
  LocationHandler handler = new LocationHandler();
  RavenclawLocation location;
  bool hasLocation = false;
  WeatherPost result;

  _WeatherDataState() {
    handler.addLocationListener((locationData) =>
        updateLocation(locationData)
    );
  }

  void updateLocation(Map<String, double> locationData) {
    if(location == null) {
      setState(() =>
      location = new RavenclawLocation(locationData)
      );
    }
  }

  void updatePostData(WeatherPost data) {
    setState(() =>
      result = data
    );
    widget.notifyParent();
  }

  Future<WeatherPost> fetchPost() async {
    final response =
    await http.get('https://api.openweathermap.org/data/2.5/weather?lat=${location.latitude}&lon=${location.longitude}&APPID=${Keys.openWeatherKey}');

    if (response.statusCode == 200) {
      hasLocation = true;
      return WeatherPost.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load Weather JSON');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FutureBuilder<WeatherPost>(
        future: fetchPost(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            print(snapshot.data.toString());
              return ListBody(
                mainAxis: Axis.vertical,
                children: <Widget>[
                  Center(child: Text(snapshot.data.city)),
                  Center(child: Text(snapshot.data.condition)),
                  Center(child: Text(snapshot.data.description)),
                  Center(child: Text("Windspeed: ${snapshot.data.windSpeed} mph"))
                ],
              );
          } if(snapshot.hasError) {
            print(snapshot.error);
          }
            return CircularProgressIndicator();
          },
        ),
    );
  }
}


class WeatherPost {
  final String condition;
  final String description;
  final double temp;
  final double maxTemp;
  final double minTemp;
  final int humidity;
  final double windSpeed;
  final int sunrise;
  final int sunset;
  final String city;

  WeatherPost({
    this.condition, this.description, this.temp, this.maxTemp, this.minTemp,
  this.humidity, this.windSpeed, this.sunrise, this.sunset, this.city});

  factory WeatherPost.fromJson(Map<String, dynamic> jsonData) {
    Map<String, dynamic> weatherJson = jsonData['weather'][0];
    print("Standard JSON: $jsonData");
    print("Weather JSON: $weatherJson");
    print("Test Windspeed ${jsonData['wind']['speed']}");
    print("Test Temp: ${jsonData['main']['temp']}");
    print("Test TempMax: ${jsonData['main']['temp_max']}");
    print("Test TempMin: ${jsonData['main']['temp_min']}");
    print("Test Humidity: ${jsonData['main']['humidity']}");
    print("Test Sunset: ${jsonData['sys']['sunset']}");

    return WeatherPost(
      condition: weatherJson['main'],
      description: weatherJson['description'],
      temp: jsonData['main']['temp'],
      maxTemp: jsonData['main']['temp_max'],
      minTemp: jsonData['main']['temp_min'],
      humidity: jsonData['main']['humidity'],
      windSpeed: jsonData['wind']['speed'],
      sunrise: jsonData['sys']['sunrise'],
      sunset: jsonData['sys']['sunset'],
      city: jsonData['name']
    );
  }
}
