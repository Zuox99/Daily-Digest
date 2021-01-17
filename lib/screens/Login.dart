import 'package:dailydigest/screens/Menu.dart';
import 'package:dailydigest/screens/Signup.dart';
import 'package:flutter/material.dart';
import 'package:dailydigest/services/auth.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {

  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  String email = "";
  String password = "";
  String error = "";

  TextStyle loginText = new TextStyle(color: Colors.black, fontSize: 18.0);
  TextStyle hintText = new TextStyle(color: Colors.black54, fontSize: 16.0);
  TextStyle signupText = new TextStyle(color: Colors.black87, fontSize: 16.0);

  Color lineColor = Colors.black;
  Color hintColor = Colors.black54;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
//      appBar: AppBar(
//        title: Text("Login Page"),
//      ),
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
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 80.0),
                child: Center(
                  child: Container(
                      width: 200,
                      height: 100,
                      child: Text(
                        "Daily Digest",
                        style: TextStyle(
                          fontSize: 38,
                        ),
                      )),
                ),
              ),
              Padding(
                //padding: const EdgeInsets.only(left:15.0,right: 15.0,top:0,bottom: 0),
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: TextFormField(
                  validator: (val) => val.isEmpty ? "Enter an email" : null,
                  onChanged: (val) {
                    setState(() {
                      email = val;
                    });
                  },
                  style: loginText,
                  decoration: InputDecoration(
                    enabledBorder: new UnderlineInputBorder(
                        borderSide: new BorderSide(color: lineColor)),
                    prefixIcon: Icon(Icons.email, color: lineColor, size: 25.0,),
//                      labelText: 'Email',
                    hintText: 'Enter an email',
                    hintStyle: hintText,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 20.0, right: 20.0, top: 20, bottom: 10),
                child: TextFormField(
                  validator: (val) => val.length < 6 ? "Enter a password 6+ chars long" : null,
                  onChanged: (val) {
                    setState(() {
                      password = val;
                    });
                  },
                  style: loginText,
                  obscureText: true,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.lock, color: lineColor, size: 25.0,),
                    enabledBorder: new UnderlineInputBorder(
                        borderSide: new BorderSide(color: lineColor)),
//                      border: OutlineInputBorder(),
//                      labelText: 'Password',
                    hintText: 'Enter password',
                    hintStyle: hintText,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget> [
                    FlatButton(
                      onPressed: (){
                        Navigator.push(context, MaterialPageRoute(builder: (_) => Signup()));
                      },
                      child: Text(
                        'Sign Up',
                        style: signupText,
                      ),
                    ),

                    FlatButton(
                      onPressed: (){
                        //TODO FORGOT PASSWORD SCREEN GOES HERE
                      },
                      child: Text(
                        'Forgot Password',
                        style: signupText,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: 50,
                width: 250,
                decoration: BoxDecoration(
                    color: Colors.blue, borderRadius: BorderRadius.circular(20)),
                child: FlatButton(
                  onPressed: () async {
                    if(_formKey.currentState.validate()) {
                      dynamic result = await _auth.signInWithEmailAndPassword(email.trim(), password.trim());
                      if(result == null) {
                        setState(() {
                          error = 'Could not sign in with those credentials';
                        });
                      } else {
                        Navigator.push(context, MaterialPageRoute(builder: (_) => Menu()));
                      }
//                      print(email);
//                      print(password);
                    }
                  },
                  child: Text(
                    'Login',
                    style: TextStyle(color: Colors.white, fontSize: 25),
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
