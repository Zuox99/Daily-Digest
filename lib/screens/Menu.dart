import 'package:flutter/material.dart';
import 'package:dailydigest/services/auth.dart';
class Menu extends StatefulWidget {
  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  TextStyle menuText = new TextStyle(color: Colors.black, fontSize: 35.0);
  TextStyle appbarText = new TextStyle(fontSize: 21, color: Colors.grey[200]);
  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    var paddingLR = w * 0.2;
    var paddingTB = h * 0;
    return Scaffold(
      appBar: AppBar(
        title: Text("Menu", style: appbarText),
        automaticallyImplyLeading : false,
        actions: <Widget>[
          FlatButton(
            onPressed: (){},
            child: Text("Logout", style: appbarText),
          )
        ],
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
          padding: EdgeInsets.fromLTRB(0, h * 0.14, 0, h * 0.3),
          child: Column(
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(paddingLR, paddingTB, paddingLR, paddingTB),
                    child: FlatButton(
                      onPressed: (){

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

                      },
                      child: Text(
                        'Calculator',
                        style: menuText,
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

