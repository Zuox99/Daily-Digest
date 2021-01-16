import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:geolocator/geolocator.dart';

class WeatherPage extends StatefulWidget {
  @override
  _WeatherPageState createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {

  var temp;
  var description;
  var currently;
  var humidity;
  var windSpeed;
  var lat;
  var lon;
  var loc;
  TextStyle appbarText = new TextStyle(fontSize: 21, color: Colors.grey[200]);
  String error;

  Future getWeather() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permantly denied, we cannot request permissions.');
    }

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        return Future.error(
            'Location permissions are denied (actual value: $permission).');
      }
    }

    Position position = new Position();
    position = await Geolocator.getCurrentPosition();

    setState(() {
      this.lat = position.latitude.toString();
      this.lon = position.longitude.toString();
    });

    http.Response response = await http.get("http://api.openweathermap.org/data/2.5/weather?lat=${this.lat}&lon=${this.lon}&appid=f7965d72995d4dcdd190c668a2f1f7cf");
    var results = jsonDecode(response.body);
    setState(() {
      this.temp = ((results['main']['temp'] - 273.15) * 1.8 + 32).round();
      this.description = results['weather'][0]['description'];
      this.currently = results['weather'][0]['main'];
      this.humidity = results['main']['humidity'];
      this.windSpeed = results['wind']['speed'];
      this.loc = results['name'];
    });
  }

  @override
  void initState() {
    super.initState();
    this.getWeather();
  }

  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text("Weather", style: appbarText),
      ),
      body: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
//              color: Colors.black.withOpacity(0.5),
          image: DecorationImage(
              image: AssetImage('assets/wallpaper3.jpg'),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.15), BlendMode.multiply)),
        ),
        child: Column(
          children: <Widget>[
            Container(
              width: w,
              height: h * 0.3,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(bottom: 10),
                    child: Text(
                      loc != null ? loc.toString() : "Loading",
                      style: TextStyle(
                        fontSize: 30,
                      ),
                    ),
                  ),
                  Text(
                    temp != null ? temp.toString() + "\u00B0" : "Loading",
                    style: TextStyle(
                      fontSize: 40,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              decoration: new BoxDecoration(
                boxShadow: [
                  new BoxShadow(
                    color: Colors.white70,
                    blurRadius: 20.0,
                  ),
                ],
              ),
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  children: <Widget>[
                    ListTile(
                      leading: FaIcon(FontAwesomeIcons.thermometerHalf),
                      title: Text("Temperature"),
                      trailing: Text(temp != null ? temp.toString() + "\u00B0" : "Loading"),
                    ),
                    ListTile(
                      leading: FaIcon(FontAwesomeIcons.cloud),
                      title: Text("Weather"),
                      trailing: Text(description != null ? description.toString() : "Loading"),
                    ),
                    ListTile(
                      leading: FaIcon(FontAwesomeIcons.sun),
                      title: Text("Temperature"),
                      trailing: Text(humidity != null ? humidity.toString() : "Loading"),
                    ),
                    ListTile(
                      leading: FaIcon(FontAwesomeIcons.wind),
                      title: Text("Wind speed"),
                      trailing: Text(windSpeed != null ? windSpeed.toString() : "Loading"),
                    ),
                  ],
                ),
                ),
            ),
          ],
        ),
      ),
    );
  }
}
