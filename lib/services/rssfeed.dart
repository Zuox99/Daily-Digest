import 'package:http/http.dart' as http;
import 'package:webfeed/webfeed.dart';

class RssFeedServices {
  var _targetUrl = "";
//      'https://abcnews.go.com/abcnews/topstories';
//  'https://www.nasa.gov/rss/dyn/breaking_news.rss';
//      'https://www.hindustantimes.com/feeds/rss/business/rssfeed.xml';


  RssFeedServices(var targetUrl) {
    this._targetUrl = targetUrl;
  }

  Future<RssFeed> getFeed() async{
    var client = http.Client();
    var response = await client.get(_targetUrl);
    return RssFeed.parse(response.body);
  }
}