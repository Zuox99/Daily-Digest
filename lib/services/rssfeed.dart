import 'package:http/http.dart' as http;
import 'package:webfeed/webfeed.dart';

class RssFeedServices {
  final _targetUrl =
//      'https://abcnews.go.com/abcnews/topstories';
      'https://www.hindustantimes.com/feeds/rss/business/rssfeed.xml';


  Future<RssFeed> getFeed() async{
    var client = http.Client();
    var response = await client.get(_targetUrl);
    return RssFeed.parse(response.body);
  }
}