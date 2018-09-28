import 'package:flutter/material.dart';
import 'package:ravenclaw_codejam2018/weather_info.dart';
import 'package:ravenclaw_codejam2018/StaticVariables.dart';

class WeatherView extends StatefulWidget {

  final WeatherPost data;

  WeatherView(this.data);

  @override
  _WeatherViewState createState() => new _WeatherViewState();
}

class _WeatherViewState extends State<WeatherView> {

  @override
  Widget build(BuildContext context) {
    return ListBody(
      mainAxis: Axis.vertical,
      children: <Widget>[
        Center(
            child: Text(
                widget.data.city,
                style: TextStyle(
                    color: StaticVariables.primaryColor,
                    fontWeight: FontWeight.w500,
                    fontSize: 60.0,
                    decoration: TextDecoration.underline,
                    decorationStyle: TextDecorationStyle.wavy,
                    decorationColor: StaticVariables.primaryColor

            ))),
        Center(child: Text(widget.data.condition)),
        Center(child: Text(widget.data.description)),
        Center(child: Text("Windspeed: ${widget.data.windSpeed} mph"))
      ],
    );
  }
}