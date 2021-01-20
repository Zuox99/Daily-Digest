import 'package:flutter/material.dart';
import 'package:dailydigest/services/rssfeed.dart';
import 'package:webfeed/domain/rss_feed.dart';
import 'package:flutter/cupertino.dart';
import 'WebViewPage.dart';
import 'package:dailydigest/theme/global.dart';

class News extends StatefulWidget {
  @override
  _NewsState createState() => _NewsState();
}

class _NewsState extends State<News> with SingleTickerProviderStateMixin {

  final List<List<String>> categories = [
    ["Breaking", "https://www.nasa.gov/rss/dyn/breaking_news.rss"],
    ["Education", "https://www.nasa.gov/rss/dyn/educationnews.rss"],
    ["Image of the Day", "https://www.nasa.gov/rss/dyn/lg_image_of_the_day.rss"],
    ["Earth", "https://www.nasa.gov/rss/dyn/earth.rss"],
    ["Aeronautics", "https://www.nasa.gov/rss/dyn/aeronautics.rss"],
    ["Hurricane", "https://www.nasa.gov/rss/dyn/hurricaneupdate.rss"]
  ];

  TabController _tabController;
  List<RssFeed> feed ;

  @override
  void initState() {
    super.initState();
    setState(() {
      this.feed = new List();
      this.readFeed();
      _tabController = TabController(length: categories.length, vsync: this);
    });
  }

  readFeed() async {
    for(int i = 0; i < categories.length; i++) {
      RssFeed _feed = await RssFeedServices(categories[i][1]).getFeed();
      setState(() {
        this.feed.add(_feed);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0.1,
        leading: BackButton(
          color: Colors.black87,
        ),
        title: Text("News", style: appbarText),
        bottom: tabBar(),
      ),
      body:
      Container(
          alignment: Alignment.center,
          decoration: background,
          child: feed.length < categories.length ? Text("Loading...") :
            Container(
              color: Colors.white38,
              child: TabBarView(
                controller: _tabController,
                children: List.generate(
                    categories.length, (index) {
                      RssFeed rFeed = feed[index];
                      return ListView.builder(
                          itemCount: rFeed.items.length,
                          itemBuilder: (BuildContext ctxt, int index) {
                            final item = rFeed.items[index];
                            return newsCard(item);
                          });
                        }),
              ),
            ),
      ),
    );
  }

  Widget tabBar() {
    return TabBar(
      controller: _tabController,

      labelColor: Colors.black87,
      isScrollable: true,
      labelStyle: TextStyle(
          fontFamily: 'Times',
          fontSize: 22,
          fontWeight: FontWeight.bold
      ),
      unselectedLabelColor: Colors.black87,
      unselectedLabelStyle: TextStyle(
        fontSize: 20,
        fontFamily: 'Times',
      ),
      indicator: UnderlineTabIndicator(),
      indicatorSize: TabBarIndicatorSize.tab,
      indicatorWeight: 10,

      tabs: List.generate(categories.length, (index) => Text(categories[index][0])),
    );
  }

  Widget newsCard(final item) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;

    return InkWell(
      onTap: () async {
        print(item.link);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => WebViewPage(item.link.replaceFirst('http', 'https'))));
      },

      child: Container(
        padding: EdgeInsets.symmetric(vertical: h * 0.01, horizontal: w * 0.05),
        decoration: new BoxDecoration(
          color: Colors.white70,
          borderRadius: BorderRadius.circular(10),
        ),
        alignment: Alignment.center,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            imageAndDescription(item),
            Container(
              margin: EdgeInsets.symmetric(vertical: h * 0.01, horizontal: w * 0.02),
              child: Text('Published at ' + item.pubDate,
                  style: TextStyle(fontSize: 13, color: Colors.black)),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: w * 0.02),
              child: Text(item.title,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  Widget imageAndDescription(final item) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;

    return Container(
      height: h * 0.25,
      margin: EdgeInsets.symmetric(horizontal: w * 0.01),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        image: DecorationImage(
            image: NetworkImage(item.enclosure.url), fit: BoxFit.fill),
      ),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.black.withOpacity(0.5),
              ),
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Center(
                child: Text(
                  item.description,
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.white),
                  maxLines: 2,
                  overflow: TextOverflow.fade,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
