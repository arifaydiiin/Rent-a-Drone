import "package:flutter/material.dart";

class Ilanresmibuyuk extends StatefulWidget {
  final String url;
  Ilanresmibuyuk({this.url});

  @override
  _IlanresmibuyukState createState() => _IlanresmibuyukState();
}

class _IlanresmibuyukState extends State<Ilanresmibuyuk> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back)),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Image.network(widget.url),
      ),
    );
  }
}
