import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:dailydigest/theme/global.dart';

class WeatherPage extends StatefulWidget {
  @override
  _WeatherPageState createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {

  var temp;
  var visibility;
  var currently;
  var humidity;
  var windSpeed;
  var lat;
  var lon;
  var loc;
  String error;

  TextStyle numText = new TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w400,
    color: Colors.black87
  );

  TextStyle gridText = new TextStyle(
    fontSize: 16,
    color: Colors.black54
  );

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
      this.visibility = (results['visibility'] / 1000).round();
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
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        centerTitle: true,
        leading: BackButton(
          color: Colors.black87,
        ),
        backgroundColor: Colors.transparent,
        elevation: 0.1,
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
              width: w * 0.8,
              height: h * 0.6,
              padding: EdgeInsets.fromLTRB(0, h * 0.2, 0, 0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, h * 0.03, 0, h * 0.03),
                    child: Text(
                      loc != null ? loc.toString() : "Loading",
                      style: TextStyle(
                        fontSize: 25,
                      ),
                    ),
                  ),
                  Text(
                    temp != null ? temp.toString() + "\u00B0" + "F" : "Loading",
                    style: TextStyle(
                      fontSize: 64,
                    ),
                  ),
                  Text(
                    currently != null ? currently.toString() : "Loading",
                    style: TextStyle(
                      fontSize: 30,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: w * 0.8,
              margin: EdgeInsets.only(top:h * 0.01),
              height: h * 0.15,
              decoration: new BoxDecoration(
                boxShadow: [
                  new BoxShadow(
                    color: Colors.white38,
                    blurRadius: 20.0,
                  ),
                ],
              ),
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.all(0),
                child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      grid(w, humidity, "Humidity", " %"),
                      Container(
                        color: Colors.black38,
                        width: w * 0.002,
                        height: h * 0.08,
                      ),
                      grid(w, visibility, "Visibility", " km"),
                      Container(
                        color: Colors.black38,
                        width: w * 0.002,
                        height: h * 0.08,
                      ),
                      grid(w, windSpeed, "Wind", " m/s")
                    ],
                  ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget grid(var w, var num, String name, String flag) {
    return Container(
      width: w * 0.2,
      margin: EdgeInsets.symmetric(horizontal: w * 0.02),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(num != null ? num.toString() + flag : "Loading", style: numText),
          Text(name, style: gridText)
        ],
      ),
    );
  }
}
