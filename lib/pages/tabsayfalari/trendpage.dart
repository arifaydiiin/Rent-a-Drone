import 'package:flutter/material.dart';

class Trend extends StatefulWidget {
  Trend({Key key}) : super(key: key);

  @override
  _TrendState createState() => _TrendState();
}

class _TrendState extends State<Trend> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text("Trendler")),
    );
  }
}
