import 'package:dailydigest/screens/Login.dart';
import 'package:dailydigest/screens/News.dart';
import 'package:flutter/material.dart';
import 'package:dailydigest/theme/global.dart';

class SignOutPage extends StatefulWidget {
  @override
  _SignOutPageState createState() => _SignOutPageState();
}

class _SignOutPageState extends State<SignOutPage> {
  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        decoration: background,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: h * 0.3, horizontal: 0),
          child: Column(
            children: <Widget>[
              Expanded(
                child: Text(
                  "Thank You!",
                  style: TextStyle(
                    fontFamily: "Times",
                    color: Colors.black87,
                    fontSize: 54
                  ),
                ),
              ),
              Expanded(
                child: FlatButton(
                    onPressed: (){
                      Navigator.push(context, MaterialPageRoute(builder: (_) => Login()));
                    },
                    child: Text(
                      'Login Here!',

                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 18
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


