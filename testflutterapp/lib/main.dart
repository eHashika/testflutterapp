import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:html/dom.dart' as dom;

void main() {
  runApp(Test());
}

class Test extends StatelessWidget {
  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          appBarTheme: const AppBarTheme(color: Colors.blue),
          textTheme: const TextTheme(
            bodyText2: TextStyle(fontSize: 24),
          ),
        ),
        home: _TestState(),
      );
}

class _TestState extends StatefulWidget {
  @override
  __TestStateState createState() => __TestStateState();
}

class __TestStateState extends State<_TestState> {
  List<Article> articles = [];

  @override
  void initState() {
    super.initState();

    getWebsiteData();
  }

  Future getWebsiteData() async {
    final url = Uri.parse('https://www.amazon.com/s?k=iphone');
    final response = await http.get(url);
    dom.Document html = dom.Document.html(response.body);

    final titles = html
        .querySelectorAll('h2 > a > span')
        .map((element) => element.innerHtml.trim())
        .toList();

    final urls = html
        .querySelectorAll('h2 > a')
        .map(
            (element) => 'https://www.amazon.com/${element.attributes['href']}')
        .toList();

    final urlImages = html
        .querySelectorAll('span > a > div > img')
        .map((element) => element.attributes['src']!)
        .toList();

    setState(() {
      articles = List.generate(
        titles.length,
        (index) => Article(
          title: titles[index],
          url: urls[index],
          urlImage: urlImages[index],
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Web Scraping'),
          centerTitle: true,
        ),
        body: ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: articles.length,
          itemBuilder: (context, index) {
            final article = articles[index];

            return ListTile(
              leading: Image.network(
                article.urlImage,
                width: 50,
                fit: BoxFit.fitHeight,
              ),
              title: Text(article.title),
              subtitle: Text(article.url),
            );
          },
        ),
      );
}

class Article {
  final String url;
  final String title;
  final String urlImage;

  const Article({
    required this.url,
    required this.title,
    required this.urlImage,
  });
}
