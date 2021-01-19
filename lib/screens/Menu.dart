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
    fontSize: 25.0,
    fontFamily: 'Times',
  );

  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    var paddingLR = w * 0.2;
    var paddingTB = h * 0;
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
        decoration: BoxDecoration(
//              color: Colors.black.withOpacity(0.5),
          image: DecorationImage(
              image: AssetImage('assets/wallpaper3.jpg'),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.15), BlendMode.multiply)),
        ),
        child: Padding(
          padding: EdgeInsets.fromLTRB(0, h * 0.25, 0, h * 0.3),
          child: Column(
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(paddingLR, paddingTB, paddingLR, paddingTB),
                    child: FlatButton(
                      onPressed: (){
                        Navigator.push(context, MaterialPageRoute(builder: (_) => News()));
                      },
                      child: Text(
                        'News',
                        style: menuText,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(paddingLR, paddingTB, paddingLR, paddingTB),
                    child: Divider(
                      color: Colors.black87,
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(paddingLR, paddingTB, paddingLR, paddingTB),
                    child: FlatButton(
                      onPressed: (){
                        Navigator.push(context, MaterialPageRoute(builder: (_) => WeatherPage()));
                      },
                      child: Text(
                        'Weather',
                        style: menuText,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(paddingLR, paddingTB, paddingLR, paddingTB),
                    child: Divider(
                      color: Colors.black87,
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(paddingLR, paddingTB, paddingLR, paddingTB),
                    child: FlatButton(
                      onPressed: (){
                        Navigator.push(context, MaterialPageRoute(builder: (_) => Calculator()));
                      },
                      child: Text(
                        'Calculator',
                        style: menuText,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(paddingLR, paddingTB, paddingLR, paddingTB),
                    child: Divider(
                      color: Colors.black87,
                    ),
                  ),
                ),
                Expanded(
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
                ),
              ],
            ),
        ),
        ),
    );
  }
}

