import 'package:dailydigest/screens/Menu.dart';
import 'package:dailydigest/screens/Signup.dart';
import 'package:flutter/material.dart';
import 'package:dailydigest/services/auth.dart';
import 'package:dailydigest/theme/global.dart';
import 'package:dailydigest/Users.dart';
import 'package:firebase_auth/firebase_auth.dart';


class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
//  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  String email = "";
  String password = "";
  String error = "";

  TextStyle loginText = new TextStyle(color: Colors.black, fontSize: 20.0);
  TextStyle hintText = new TextStyle(color: Colors.black54, fontSize: 18.0);

  Color lineColor = Colors.black;
  Color hintColor = Colors.black54;


  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        decoration: background,
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                logo(),
                inputBox("email", Icons.email),
                inputBox("password", Icons.lock),
                noAccount(),
                loginButton(),
                Text(
                  error,
                  style: TextStyle(color: Colors.red, fontSize: 14.0),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget logo() {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;

    return Padding(
        padding: EdgeInsets.fromLTRB(w * 0.1, 0, w * 0.1, h * 0.05),
        child: Text(
          "Daily Digest",
          style: TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.bold,
              fontFamily: "Times"
          ),
        )
    );
  }

  Widget inputBox(var flag, var _icon) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: w * 0.05, vertical: h * 0.01),
      child: TextFormField(
        validator: (val) => flag == "email" ?
        (RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(val) ? null : "Enter an email")
            : (val.length < 6 ? "Enter a password 6+ chars long" : null),
        onChanged: (val) {
          setState(() {
            if(flag == "email") {
              this.email = val;
            } else {
              this.password = val;
            }
          });
        },
        style: loginText,
        decoration: InputDecoration(
          enabledBorder: new UnderlineInputBorder(borderSide: new BorderSide(color: lineColor)),
          prefixIcon: Icon(_icon, color: lineColor, size: 25.0,),
          hintText: flag == "email" ? 'Enter an email' : 'Enter password',
          hintStyle: hintText,
        ),
        obscureText: flag == "email" ? false : true,
      ),
    );
  }

  Widget noAccount() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: FlatButton(
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (_) => Signup()));
        },
        child: Text(
          'Don\'t have an account?',
          style: TextStyle(color: Colors.black87, fontSize: 18.0),
        ),
      ),
    );
  }

  Widget loginButton() {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;

    return Container(
      height: h * 0.08,
      width: w * 0.7,
      decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.circular(20)),
      child: FlatButton(
        onPressed: () async {
          if(_formKey.currentState.validate()) {
            try {
              await _auth.signInWithEmailAndPassword(email: email.trim(), password: password.trim());
//              User user = result.user;
              Navigator.push(context, MaterialPageRoute(builder: (_) => Menu()));
            } catch (error) {
              _showMyDialog(error.toString());
            }
          }
        },
        child: Text(
          'Login',
          style: TextStyle(color: Colors.white, fontSize: 25),
        ),
      ),
    );
  }

  Future _showMyDialog(var e) async {
    print(e);
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        Future.delayed(Duration(seconds: 3), () {
          Navigator.of(context).pop(true);
        });
        return AlertDialog(
          title: Text(e.toString()),
        );
      },
    );
  }
}
