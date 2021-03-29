import "package:flutter/material.dart";

class IlanDetayi extends StatefulWidget {
  final String aciklama;
  final String fiyat;
  final String ilanadi;
  final String il;
  final String ilce;
  final String deneyim;
  final String boostmu;

  IlanDetayi(
      {Key key,
      this.aciklama,
      this.fiyat,
      this.ilanadi,
      this.il,
      this.ilce,
      this.deneyim,
      this.boostmu})
      : super(key: key);

  @override
  _IlanDetayiState createState() => _IlanDetayiState();
}

class _IlanDetayiState extends State<IlanDetayi> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Text(widget.aciklama),
            Text(widget.deneyim),
          ],
        ),
      ),
    );
  }
}
