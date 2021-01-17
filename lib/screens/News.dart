import 'package:flutter/material.dart';
import 'package:dailydigest/services/rssfeed.dart';
import 'package:webfeed/domain/rss_feed.dart';
import 'package:flutter/cupertino.dart';
import 'WebViewPage.dart';
import 'package:intl/intl.dart';

class News extends StatefulWidget {
  @override
  _NewsState createState() => _NewsState();
}

class _NewsState extends State<News>{

  TextStyle appbarText = new TextStyle(fontSize: 21, color: Colors.grey[200]);
  RssFeed feed;

  @override
  void initState() {
    super.initState();
    this.readFeed();
  }

  readFeed() async {
    RssFeed feed = await RssFeedServices().getFeed();
    setState(() {
      this.feed = feed;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("News", style: appbarText),
      ),
      body: feed == null ?
      Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
//              color: Colors.black.withOpacity(0.5),
            image: DecorationImage(
                image: AssetImage('assets/wallpaper3.jpg'),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                    Colors.black.withOpacity(0.15), BlendMode.multiply)),
          ),
          child: Text(
            "Loading...",
        ),
      ) :
      ListView.builder(
          itemCount: feed.items.length,
          itemBuilder: (BuildContext ctxt, int index) {
            final item = feed.items[index];

            return
            ListTile(
              title: Text(item.title),
              subtitle: Text('Published at ' +
                  DateFormat.yMd().format(DateTime.parse(item.pubDate))),
              contentPadding: EdgeInsets.all(16.0),
              onTap: () async {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => WebViewPage(item.link)));
              },
            );
          }),
    );
  }
}
