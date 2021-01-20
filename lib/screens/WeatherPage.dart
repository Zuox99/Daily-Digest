import 'package:dailydigest/services/dailyWeather.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:dailydigest/theme/global.dart';
import 'package:intl/intl.dart';

class WeatherPage extends StatefulWidget {
  @override
  _WeatherPageState createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {

  var loc;
  var daily;
  DailyWeather currently;
  List<DailyWeather> dailyWeather;
  var dayOfWeek;

  var weekday = {
    1: 'Mon',
    2: 'Tue',
    3: 'Wed',
    4: 'Thu',
    5: 'Fri',
    6: 'Sat',
    0: 'Sun'
  };
  var parseWeekday = {
    'Mon': 1,
    'Tue': 2,
    'Wed': 3,
    'Thu': 4,
    'Fri': 5,
    'Sat': 6,
    'Sun': 7
  };

  getDate() {
    var now = new DateTime.now();
    var formatted = new DateFormat("E");
    setState(() {
      this.dayOfWeek = parseWeekday[formatted.format(now)];
      print(dayOfWeek);
    });
  }

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

    var lat = position.latitude.toString();
    var lon = position.longitude.toString();

    http.Response response = await http.get("http://api.openweathermap.org/data/2.5/onecall?lat=$lat&lon=$lon&exclude=minutely,hourly,alerts&appid=f7965d72995d4dcdd190c668a2f1f7cf");
    http.Response response2 = await http.get("https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&exclude=minutely,hourly,alerts&appid=f7965d72995d4dcdd190c668a2f1f7cf");

    var results = jsonDecode(response.body);

    setState(() {
      var today = results['current'];
      this.currently = new DailyWeather(
          0, 0, today['weather'][0]['main'], today['weather'][0]['icon'],
          today['temp'], today['pressure'], today['humidity'], today['wind_speed']);
      this.loc = jsonDecode(response2.body)['name'];
      this.daily = results['daily'];
      for(int i = 0; i < this.daily.length; i++) {
        this.dailyWeather.add(
            new DailyWeather(daily[i]['temp']['min'], daily[i]['temp']['max'], daily[i]['weather'][0]['main'],
                daily[i]['weather'][0]['icon'], daily[i]['temp']['day'], daily[i]['pressure'], daily[i]['humidity'], daily[i]['wind_speed']
            )
        );
      }
    });
  }

  @override
  void initState() {
    super.initState();
    this.dailyWeather = new List();
    this.getWeather();
    this.getDate();
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
          image: DecorationImage(
              image: AssetImage('assets/wallpaper3.jpg'),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.25), BlendMode.multiply)),
        ),
        child: (currently != null && dailyWeather != null && loc != null) ? Container(
          width: w * 0.9,
          height: h * 0.9,
          decoration: new BoxDecoration(
            boxShadow: [
              new BoxShadow(
                color: Colors.white60,
                blurRadius: 20.0,
              ),
            ],
          ),
          margin: EdgeInsets.only(top: 0.12 * h),
          child: Column(
            children: <Widget>[
              location(),
              todayInfo(),
              //forecast
              Container(
                width: w * 0.8,
                height: h * 0.5,
                child: ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: dailyWeather.length,
                  itemBuilder: (BuildContext ctxt, int index) {
                    final DailyWeather item = dailyWeather[index];
                    final day = weekday[(index + dayOfWeek) % 7];
                    return forecastGrid(item, day);
                  },
                ),
              ),
            ],
          ),
        ) : Text("Loading...")
      ),
    );
  }

  Widget location() {
    var h = MediaQuery.of(context).size.height;

    return Padding(
      padding: EdgeInsets.only(top: h * 0.08),
      child: Text(
        loc.toString(),
        style: TextStyle(
          fontSize: 25,
        ),
      ),
    );
  }

  Widget todayInfo() {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;

    return Container(
      width: w * 0.8,
      height: h * 0.2,
      padding: EdgeInsets.only(top: h * 0.03),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            width: w * 0.5,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  currently.temp.toString() + "\u00B0" + "F",
                  style: TextStyle(
                    fontSize: 64,
                  ),
                ),
                Text(
                  currently.main.toString(),
                  style: TextStyle(
                    fontSize: 22,
                  ),
                ),
              ],
            ),
          ),
          Image.network(
            "http://openweathermap.org/img/wn/${currently.icon}@2x.png",
            width: w * 0.2,
            height: h * 0.2,
          ),
        ],
      ),
    );
  }

  Widget forecastGrid(DailyWeather item, String day) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;

    TextStyle _textStyle = new TextStyle(
      fontSize: 20,
    );
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: w * 0.05),
      child: Row(
        children: <Widget>[
          Container(
            width: w * 0.15,
            child: Text(
              day,
              style: _textStyle,
            ),
          ),
          Container(
            width: w * 0.35,
            alignment: Alignment.center,
            child: Image.network(
              "http://openweathermap.org/img/wn/${item.icon}@2x.png",
              width: w * 0.08,
              height: h * 0.08,
            ),
          ),
          Container(
            width: w * 0.1,
            alignment: Alignment.center,
            child: Text(
              item.minTemp.toString(),
              style: _textStyle,
            ),
          ),
          Container(
            width: w * 0.1,
            alignment: Alignment.center,
            child: Text(
                item.maxTemp.toString(),
              style: _textStyle,
            ),
          ),
        ],
      ),
    );
  }
}
