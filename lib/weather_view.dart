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

  TextStyle get titleTextStyle {
    return TextStyle(
        color: StaticVariables.primaryColor,
        fontWeight: FontWeight.w500,
        fontSize: 60.0,
        decoration: TextDecoration.underline,
        decorationStyle: TextDecorationStyle.wavy,
        decorationColor: StaticVariables.primaryColor);
  }

  TextStyle get subtitleTextStyle {
    return TextStyle(
        color: StaticVariables.primaryAccentColor,
        fontWeight: FontWeight.w400,
        fontSize: 22.0);
  }

  TextStyle get standardTextStyle {
    return TextStyle(
        color: StaticVariables.primaryAccentColor,
        fontWeight: FontWeight.w300,
        fontSize: 20.0);
  }

  TextStyle get weatherTextStyle {
    return TextStyle(
        color: StaticVariables.primaryAccentColor,
        fontWeight: FontWeight.w500,
        fontSize: 22.0);
  }



  Widget get title {
    return Center(
        child: Text(
            widget.data.city,
            style: titleTextStyle));
  }

  Widget get header {
    return Center(
        child:
            Text(
              "Below is Your Weather Forecast",
              style: subtitleTextStyle,
              textAlign: TextAlign.center,
            )
      );
  }

  Widget get condition {
    WeatherType weather = new WeatherType(widget.data.description);
    return Center(
        child: Container(
            padding: EdgeInsets.only(top: 20.0, bottom: 10.0),
            child: Column(
                children: <Widget> [
                  Icon(
                      weather.icon,
                      color: weather.color,
                      size: 120.0
                  ),
                  Text(
                    widget.data.condition,
                    style: weatherTextStyle,
                  )
                ]
            )
        )
    );
  }

  Widget get description {
    return Center(
        child: Text(
            widget.data.description,
            style: standardTextStyle
        ));
  }

  Widget get windSpeed {
    return Center(
        child: Text(
            "Windspeed: ${widget.data.windSpeed} mph",
            style: standardTextStyle
        ));
  }

  Widget get warnings {
    if(false) {
      return Text("You are dead m8");
    }
    return Container();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        children: <Widget>[
          title,
          header,
          condition,
          description,
          windSpeed,
          warnings
          ],
        )
    );
  }
}

class WeatherType {
  String description;
  IconData icon;
  Color color;

  WeatherType(String weatherDescription) {
    description = weatherDescription;
    setIcon(weatherDescription);
  }

  void setIcon(String description) {
    switch(description.toLowerCase()) {
      case "clear sky":
        icon = Icons.wb_sunny;
        color = Colors.yellow[500];
        return;
      case "few clouds":
      case "scattered clouds":
      case "broken clouds":
        icon = Icons.wb_cloudy;
        color = Colors.blueGrey[300];
        return;
      case "shower rain":
      case "rain":
        icon = Icons.pool;
        color = Colors.lightBlue[300];
        return;
      case "thunderstorm":
        icon = Icons.lightbulb_outline;
        color = Colors.yellow[800];
        return;
      case "snow":
        icon = Icons.pregnant_woman;
        color = Colors.blueGrey[200];
        return;
      case "mist":
        icon = Icons.fast_rewind;
        color = Colors.blueGrey[100];
        return;
      default:
        icon = Icons.wb_sunny;
        color = Colors.yellow[500];
        return;
    }
  }
}