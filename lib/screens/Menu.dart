import 'package:dailydigest/screens/Calculator.dart';
import 'package:dailydigest/screens/News.dart';
import 'package:dailydigest/screens/SignOutPage.dart';
import 'package:dailydigest/screens/WeatherPage.dart';
import 'package:flutter/material.dart';
import 'package:dailydigest/theme/global.dart';
import 'package:dailydigest/services/auth.dart';

class Menu extends StatefulWidget {
  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<Menu> {

  TextStyle menuText = new TextStyle(
    color: Colors.black,
    fontSize: 28.0,
    fontFamily: 'Times',
  );

  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        centerTitle: true,
        title: Text("Menu", style: appbarText),
        backgroundColor: Colors.transparent,
        elevation: 0.1,
        automaticallyImplyLeading : false,
      ),
      body: Container(
        alignment: Alignment.center,
        decoration: background,
        child: Padding(
          padding: EdgeInsets.fromLTRB(0, h * 0.25, 0, h * 0.3),
          child: Column(
              children: <Widget>[
                menuChoices("News"),
                dividerLine(),
                menuChoices("Weather"),
                dividerLine(),
                menuChoices("Calculator"),
                dividerLine(),
                logOutButton(),
              ],
            ),
        ),
        ),
    );
  }

  Widget menuChoices(var choice) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;

    var paddingLR = w * 0.2;
    var paddingTB = h * 0;

    return Expanded(
      child: Padding(
        padding: EdgeInsets.fromLTRB(paddingLR, paddingTB, paddingLR, paddingTB),
        child: FlatButton(
          onPressed: (){
            Navigator.push(context, MaterialPageRoute(
                builder: (_) => choice == "News" ? News() : (choice == "Weather" ? WeatherPage() : Calculator())));
          },
          child: Text(
            choice,
            style: menuText,
          ),
        ),
      ),
    );
  }

  Widget dividerLine() {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;

    var paddingLR = w * 0.2;
    var paddingTB = h * 0;

    return Expanded(
      child: Padding(
        padding: EdgeInsets.fromLTRB(paddingLR, paddingTB, paddingLR, paddingTB),
        child: Divider(
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget logOutButton() {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;

    var paddingLR = w * 0.2;
    var paddingTB = h * 0;

    return Expanded(
      child: Padding(
        padding: EdgeInsets.fromLTRB(paddingLR, paddingTB, paddingLR, paddingTB),
        child: FlatButton(
          onPressed: () async {
            await _auth.signOut();
            Navigator.push(context, MaterialPageRoute(builder: (_) => SignOutPage()));
          },
          child: Text(
            'Logout',
            style: TextStyle(
              color: Colors.black,
              fontSize: 20.0,
              fontFamily: 'Times',
            ),
          ),
        ),
      ),
    );
  }
}

