import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:dailydigest/theme/global.dart';

class WebViewPage extends StatefulWidget {
  final url;
  WebViewPage(this.url);
  @override
  _WebViewPageState createState() => _WebViewPageState(this.url);
}

class _WebViewPageState extends State<WebViewPage> {
  var _url;
  final _key = UniqueKey();
  _WebViewPageState(this._url);

  @override
  Widget build(BuildContext context) {
//    print(_url);
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.1,
          title: Text("News Read", style: appbarText),
        ),
        body: Column(
          children: [
            Expanded(
                child: WebView(
                    key: _key,
                    javascriptMode: JavascriptMode.unrestricted,
                    initialUrl: _url))
          ],
        ));
  }
}
