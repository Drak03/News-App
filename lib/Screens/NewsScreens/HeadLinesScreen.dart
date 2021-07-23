import 'dart:async';
import 'dart:convert';
import 'dart:ui';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:news_assignment/widgets/SideDraw.dart';
import './WebViewScreen.dart';
import 'package:url_launcher/url_launcher.dart';
import '/modal/newsModal.dart';

class NewsHome extends StatefulWidget {
  @override
  _NewsHomeState createState() => _NewsHomeState();
}

class _NewsHomeState extends State<NewsHome> {
  StreamController streamController = StreamController();

  getdata() async {
    Uri url = Uri.parse(
        "https://newsapi.org/v2/top-headlines?country=in&apiKey=ad6e24f8e94741189add2767908a4d20");
    Response response = await get(url);

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonData = jsonDecode(response.body);
      NewsFeed news = NewsFeed.fromJson(jsonData);
      if (!streamController.isClosed) {
        return streamController.sink.add(news);
      } else {
        return null;
      }
    } else {
      throw "Network Error";
    }
  }

  @override
  void initState() {
    getdata();
    super.initState();
  }

  @override
  void dispose() {
    streamController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Top Headlines in India"),
        backgroundColor: Colors.red[900],
      ),
      drawer: DrawNavigation(),
      backgroundColor: Colors.grey[800],
      body: StreamBuilder(
          stream: streamController.stream,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return PageView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: snapshot.data.articles.length,
                  itemBuilder: (context, index) {
                    final news = snapshot.data.articles[index];
                    return PageViewWidget(
                      news: news,
                      context: context,
                    );
                  });
            } else if (snapshot.hasError) {
              return Center(
                child: Text(
                  "Error in getting Data !!!",
                  style: TextStyle(color: Colors.red, fontSize: 30),
                ),
              );
            }
            return Center(child: CircularProgressIndicator());
          }),
    );
  }
}

class PageViewWidget extends StatelessWidget {
  final Article news;
  final BuildContext context;

  PageViewWidget({
    Key key,
    @required this.news,
    @required this.context,
  });
  final snackBar = SnackBar(
      content: Text(
    "Swipe left to view full Article.",
    style: TextStyle(fontSize: 20),
  ));
  void swipeOpenUrl(DragEndDetails details) async {
    final url = news.url;
    final name = news.source.name;
    if (details.primaryVelocity.compareTo(0) == -1) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (btx) => WebViewScreen(
                    url: url,
                    name: name,
                  )));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  void openUrl() async {
    final url = news.url;
    if (await canLaunch(url))
      await launch(url);
    else
      throw "Could not launch $url";
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragEnd: (DragEndDetails details) => swipeOpenUrl(details),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text("By ${news.author}" ?? "No Data",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic,
                          color: Colors.grey[300])),
                ),
                Text("Updated on ${DateFormat.yMd().format(news.publishedAt)}",
                    style: TextStyle(
                        fontStyle: FontStyle.italic, color: Colors.grey[300]))
              ],
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height / 2.3,
            decoration: BoxDecoration(
              image: DecorationImage(
                  fit: BoxFit.cover,
                  image: (news?.urlToImage == null)
                      ? AssetImage("asset/img_01_l.jpeg")
                      : NetworkImage(news.urlToImage)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              children: [
                Text(news.title ?? "No Data",
                    style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 25,
                        color: Colors.red)),
                SizedBox(height: 10),
                (news.description == null)
                    ? Text("No Data",
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w400,
                            color: Colors.grey,
                            fontStyle: FontStyle.italic))
                    : RichText(
                        text: (news.description.length > 100)
                            ? TextSpan(children: [
                                TextSpan(
                                    text:
                                        "${news.description.substring(0, 100)}...",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.white)),
                                TextSpan(
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () => openUrl(),
                                  text: "View full article in Browser.",
                                  style: TextStyle(
                                      color: Colors.blue,
                                      fontStyle: FontStyle.italic),
                                )
                              ])
                            : TextSpan(
                                children: [
                                  TextSpan(
                                      text: news.description,
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.white)),
                                  TextSpan(
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () => openUrl(),
                                    text: "View full article in Browser.",
                                    style: TextStyle(
                                        color: Colors.blue,
                                        fontStyle: FontStyle.italic),
                                  )
                                ],
                              ),
                      ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
