import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

void main() => runApp(WeatherApp());

class WeatherApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Weather App',
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
    primaryColor: Colors.black,
    accentColor: Colors.black
    ),
    home: Home(),
  );
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}
class _HomeState extends State<Home> {
  List<Weather> _weather = <Weather>[];

  @override
  void initState() {
    super.initState();
    listenForWeather();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      centerTitle: true,
      title: Text('London Weather'),
    ),
    body: ListView.builder(
      itemCount: _weather.length,
      itemBuilder: (context, index)  {
        return ListTile(
          title: Text("${_weather[index].time.year}-${_weather[index].time.month}-${_weather[index].time.day}"),
          subtitle:Text(_weather[index].weather),
          leading: Container(
            margin: EdgeInsets.only(left: 6.0),
            child: Text("${_weather[index].temp.toInt().toString()}F")
          )
        );
      },
    ),
  );

  void listenForWeather() async {
    Future<dynamic> stream = getWeather();
    stream.then((dynamic weather) =>
        setState(() =>  addToList(jsonDecode(weather)))
    );
  }
  void addToList(var json) {
    var list = json["list"];
    print(list);
    for (Map<String, dynamic> i in list) {
      print(i);
      _weather.add(Weather.fromJson(i));
    }
  }
}

getWeather() async {
  final String url = 'api.openweathermap.org';
  var queryParameters = {
    "appid" : "6a261db84ea66e779fc0d949ca3d203c",
    "zip" : "77584",
    "units" : "imperial",
    "q" : "London"
  };
  final streamedRest = await
      http.get(Uri.https(url, "/data/2.5/forecast", queryParameters));

  return streamedRest.body;
}

class Weather {
  num temp;

  DateTime time;

  String weather;
  Weather.fromJson(Map<String, dynamic> json) {
    temp = json['main']['temp'];
    time = DateTime.parse(json["dt_txt"]);
    weather = json["weather"][0]["main"];
  }
}

