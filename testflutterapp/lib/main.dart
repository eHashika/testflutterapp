import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' show parse;

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String price = '';

  Future<void> _scrapePrice() async {
    var response = await http
        .get(Uri.parse('https://www.binance.com/en/markets/coinInfo-BTCUSDT'));
    if (response.statusCode == 200) {
      var document = parse(response.body);
      var priceElement = document.querySelector('.price-current');
      setState(() {
        price = priceElement?.text ?? 'Price not found';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Web Scraping'),
        ),
        body: Center(
          child: Text(price),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _scrapePrice,
          child: Icon(Icons.refresh),
        ),
      ),
    );
  }
}
